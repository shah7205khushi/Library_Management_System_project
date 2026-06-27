<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Book Inventory Report</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #eef2f3;
        }

        h2 {
            text-align: center;
            margin-top: 20px;
        }

        .print-button-container {
            text-align: center;
            margin-top: 20px;
        }

        .print-button {
            padding: 10px 20px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        table {
            width: 95%;
            margin: 20px auto;
            border-collapse: collapse;
            background: white;
        }

        th, td {
            padding: 10px;
            border: 1px solid #bbb;
            text-align: left;
        }

        th {
            background-color: #007bff;
            color: white;
        }

        @media print {
            .print-button-container {
                display: none;
            }

            body {
                background: white;
            }

            table {
                page-break-after: auto;
            }

            tr {
                page-break-inside: avoid;
                page-break-after: auto;
            }

            thead {
                display: table-header-group;
            }

            tfoot {
                display: table-footer-group;
            }
        }
    </style>
</head>
<body>

<h2>Library Book Inventory Report</h2>

<!-- Print/Download as PDF Button -->
<div class="print-button-container">
    <button class="print-button" onclick="window.print()">Download PDF</button>
</div>

<table>
    <thead>
    <tr>
        <th>No</th>
        <th>ISBN</th>
        <th>Title</th>
        <th>Edition</th>
        <th>Subject</th>
        <th>Total Copies</th>
        <th>Added Date</th>
        <th>Page Count</th>
        <th>Publisher</th>
    </tr>
    </thead>
    <tbody>
<%
    Connection con = null;
    Statement st = null;
    ResultSet rs = null;
    int index = 1;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "");

        String query = "SELECT b.book_id, b.ISBN, b.title, b.edition, s.subject_name, b.total_copies, b.added_date, b.page_count, p.publisher_name " +
                       "FROM book b " +
                       "LEFT JOIN subject s ON b.subject_id = s.subject_id " +
                       "LEFT JOIN publisher p ON b.publisher_id = p.publisher_id";

        st = con.createStatement();
        rs = st.executeQuery(query);

        while (rs.next()) {
%>
    <tr>
        <td><%= index++ %></td>
        <td><%= rs.getString("ISBN") %></td>
        <td><%= rs.getString("title") %></td>
        <td><%= rs.getString("edition") %></td>
        <td><%= rs.getString("subject_name") != null ? rs.getString("subject_name") : "N/A" %></td>
        <td><%= rs.getInt("total_copies") %></td>
        <td><%= rs.getDate("added_date") %></td>
        <td><%= rs.getInt("page_count") %></td>
        <td><%= rs.getString("publisher_name") != null ? rs.getString("publisher_name") : "N/A" %></td>
    </tr>
<%
        }
    } catch(Exception e) {
        out.println("<tr><td colspan='9' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
    } finally {
        try { if(rs != null) rs.close(); } catch(Exception e) {}
        try { if(st != null) st.close(); } catch(Exception e) {}
        try { if(con != null) con.close(); } catch(Exception e) {}
    }
%>
    </tbody>
</table>

</body>
</html>
