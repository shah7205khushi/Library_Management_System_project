import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;
import java.sql.*;

public class AutoCancelUncollectedRequests extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "");

            // Find all approved but uncollected requests older than 24 hours
            String query = "SELECT br.request_id, br.copy_id, u.email, b.title FROM book_request br " +
                           "JOIN user u ON br.u_id = u.u_id " +
                           "JOIN book_copies bc ON br.copy_id = bc.copy_id " +
                           "JOIN book b ON bc.book_id = b.book_id " +
                           "WHERE br.request_status = 2 AND TIMESTAMPDIFF(HOUR, br.updated_at, NOW()) >= 24";

            PreparedStatement pst = con.prepareStatement(query);
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                int requestId = rs.getInt("request_id");
                int copyId = rs.getInt("copy_id");
                String email = rs.getString("email");
                String title = rs.getString("title");

                // Cancel the request
                PreparedStatement ps1 = con.prepareStatement("UPDATE book_request SET request_status = 0 WHERE request_id = ?");
                ps1.setInt(1, requestId);
                ps1.executeUpdate();

                // Make book available
                PreparedStatement ps2 = con.prepareStatement("UPDATE book_copies SET book_reservation_status = 0 WHERE copy_id = ?");
                ps2.setInt(1, copyId);
                ps2.executeUpdate();

                // Send email
                sendEmail(email, title);
            }

            response.getWriter().println("Auto-cancellation completed.");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }

    private void sendEmail(String to, String bookTitle) {
        String from = "your_email@gmail.com";
        String password = "your_app_password";

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject("Library Request Cancelled");
            message.setText("Your book request for \"" + bookTitle + "\" has been cancelled due to not collecting it within 24 hours.");
            Transport.send(message);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}