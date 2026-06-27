<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.Date" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <h2 class="mb-4 text-center">Admin List</h2>

    <table class="table table-bordered table-hover table-striped align-middle">
        <thead class="table-dark">
            <tr>
                <th>ID</th><th>Name</th><th>Email</th><th>Phone</th>
                <th>Joining Date</th><th>Resignation Date</th><th>Status</th><th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                String jdbcURL = "jdbc:mysql://localhost:3306/library_management_system";
                String dbUser = "root";
                String dbPass = "";

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(jdbcURL, dbUser, dbPass);

                    String sql = "SELECT * FROM admin";
                    ps = conn.prepareStatement(sql);
                    rs = ps.executeQuery();

                    // Date formatter to display only the date
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

                    while (rs.next()) {
                        int id = rs.getInt("a_id");
                        String name = rs.getString("name");
                        String email = rs.getString("email");
                        String phone = rs.getString("phone_num");
                        Timestamp joiningDate = rs.getTimestamp("joining_date");
                        Timestamp resignationDate = rs.getTimestamp("resignation_date");
                        int status = rs.getInt("status");
            %>
            <tr>
                <td><%= id %></td>
                <td><%= (name != null && !name.trim().isEmpty()) ? name : "-" %></td>
                <td><%= (email != null && !email.trim().isEmpty()) ? email : "-" %></td>
                <td><%= (phone != null && !phone.trim().isEmpty()) ? phone : "-" %></td>
                <td><%= (joiningDate != null) ? sdf.format(joiningDate) : "-" %></td>
                <td><%= (resignationDate != null) ? sdf.format(resignationDate) : "-" %></td>
                <td>
                    <span class="badge <%= (status == 1 ? "bg-success" : "bg-danger") %>">
                        <%= (status == 1 ? "Active" : "Inactive") %>
                    </span>
                </td>
                <td>
                    <a href="edit_admin.jsp?id=<%= id %>" class="btn btn-sm btn-primary">Edit</a>
                    <% if (status == 1) { %>
                        <a href="delete_admin.jsp?id=<%= id %>" class="btn btn-sm btn-danger"
                           onclick="return confirm('Are you sure you want to deactivate this admin?');">Inactive</a>
                    <% } else { %>
                        <button class="btn btn-sm btn-outline-secondary" disabled>Inactive</button>
                    <% } %>
                </td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='8' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
                } finally {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                }
            %>
        </tbody>
    </table>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
