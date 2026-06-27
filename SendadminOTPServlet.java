import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class RequestBookServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookIdStr = request.getParameter("book_id");
        String userIdStr = request.getParameter("user_id");

        if (bookIdStr == null || userIdStr == null || bookIdStr.equals("null") || userIdStr.equals("null")) {
            response.setContentType("text/html");
            response.getWriter().write(
                    "<script type='text/javascript'>"
                    + "alert('Missing or invalid book_id or user_id.');"
                    + "window.location='book_details.jsp';"
                    + "</script>"
            );
            return;
        }

        int bookId = Integer.parseInt(bookIdStr);
        int userId = Integer.parseInt(userIdStr);
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/library_management_system";
            String user = "root";
            String pass = "";
            Connection conn = DriverManager.getConnection(url, user, pass);
            conn.setAutoCommit(false);

            // ✅ Fetch user's role
            int role = 0; // default student
            PreparedStatement ps = conn.prepareStatement("SELECT role FROM user WHERE u_id = ?");
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                role = rs.getInt("role"); // 1 = faculty, 0 = student
            }
            rs.close();
            ps.close();

            int bookLimit = (role == 0) ? 2 : 5; // faculty: 5, student: 2

            // ✅ Count active requests
            int activeRequests = 0, activeTransactions = 0;

            ps = conn.prepareStatement(
                    "SELECT COUNT(*) FROM book_request WHERE u_id = ? AND request_status IN (0, 2, 4)"
            );
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) {
                activeRequests = rs.getInt(1);
            }
            rs.close();
            ps.close();

            // ✅ Count active transactions
            ps = conn.prepareStatement(
                    "SELECT COUNT(*) FROM transaction t "
                    + "JOIN book_request br ON t.request_id = br.request_id "
                    + "WHERE br.u_id = ? AND t.return_date IS NULL"
            );
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) {
                activeTransactions = rs.getInt(1);
            }
            rs.close();
            ps.close();
            
           int totalAllowed = bookLimit; // 2 for student, 5 for faculty

// Calculate how many books are still with user (not returned)
int activeHeldBooks = activeTransactions + activeRequests;

if (activeHeldBooks >= totalAllowed) {
    response.setContentType("text/html");
    response.getWriter().write(
            "<script type='text/javascript'>"
            + "alert('Limit reached: You already have " + totalAllowed + " active books. Please return one to continue.');"
            + "window.location='book_details.jsp?book_id=" + bookId + "';"
            + "</script>"
    );
    return;
}


            // ✅ Proceed only if within limit
            int copyId = getAvailableCopyId(conn, bookId);
            if (copyId == -1) {
                response.setContentType("text/html");
                response.getWriter().write(
                        "<script type='text/javascript'>"
                        + "alert('No available copies to request.');"
                        + "window.location='book_details.jsp?book_id=" + bookId + "';"
                        + "</script>"
                );
                return;
            }

            if (hasPendingRequest(conn, userId, copyId)) {
                response.setContentType("text/html");
                response.getWriter().write(
                        "<script type='text/javascript'>"
                        + "alert('You have already requested this book copy.');"
                        + "window.location='book_details.jsp?book_id=" + bookId + "';"
                        + "</script>"
                );
                return;
            }

            insertBookRequest(conn, userId, copyId);
            updateCopyReservationStatus(conn, copyId, 1); // Reserved
            conn.commit();

            response.setContentType("text/html");
            response.getWriter().write(
                    "<script type='text/javascript'>"
                    + "alert('Book request approved and reserved successfully.');"
                    + "window.location='book_details.jsp?book_id=" + bookId + "';"
                    + "</script>"
            );

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }

    private int getAvailableCopyId(Connection conn, int bookId) throws SQLException {
        String sql = "SELECT copy_id FROM book_copies WHERE book_id = ? AND book_reservation_status = 0 LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("copy_id");
                }
            }
        }
        return -1;
    }

    private boolean hasPendingRequest(Connection conn, int userId, int copyId) throws SQLException {
        String sql = "SELECT 1 FROM book_request WHERE u_id = ? AND copy_id = ? AND request_status = 0";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, copyId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    private void insertBookRequest(Connection conn, int userId, int copyId) throws SQLException {
        String sql = "INSERT INTO book_request (copy_id, u_id, request_date, request_status) VALUES (?, ?, CURDATE(), 2)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, copyId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    private void updateCopyReservationStatus(Connection conn, int copyId, int status) throws SQLException {
        String sql = "UPDATE book_copies SET book_reservation_status = ? WHERE copy_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, copyId);
            ps.executeUpdate();
        }
    }
}