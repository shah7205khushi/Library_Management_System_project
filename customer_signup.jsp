<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String otp = (String) session.getAttribute("otp");
    boolean otpSent = otp != null;

    String regno = (String) session.getAttribute("regno");
    String fname = (String) session.getAttribute("fname");
    String lname = (String) session.getAttribute("lname");
    String email = (String) session.getAttribute("email");
    String phone = (String) session.getAttribute("phone");
    String role = (String) session.getAttribute("role");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Signup</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            background: linear-gradient(to right, #a1c4fd, #c2e9fb);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .form-box {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 400px;
        }
        .btn-blue {
    background-color: #007bff;
    color: white;
}

.btn-blue:hover {
    background-color: #0056b3;
}

        label {
            font-weight: bold;
        }
    </style>

    <%-- Handle messages --%>
    <%
        String error = request.getParameter("error");
        if ("already_registered".equals(error)) {
    %>
        <script>
            alert("You are already registered. Please login.");
            setTimeout(function () {
                window.location.href = "index.jsp";
            }, 3000);
        </script>
    <% } %>
</head>
<body>
<div class="form-box">
    <h4 class="text-center mb-4"><b>Register to DCS library</b></h4>

    <form method="post">
        <div class="form-group">
            <label>Registration No</label>
            <input type="text" name="regno" class="form-control" placeholder="Registration No" 
                   value="<%= regno != null ? regno : "" %>" <%= otpSent ? "readonly" : "" %> required>
        </div>
        <div class="form-group">
            <label>First Name</label>
            <input type="text" name="fname" class="form-control" placeholder="First Name" 
                   value="<%= fname != null ? fname : "" %>" <%= otpSent ? "readonly" : "" %> required>
        </div>
        <div class="form-group">
            <label>Last Name</label>
            <input type="text" name="lname" class="form-control" placeholder="Last Name" 
                   value="<%= lname != null ? lname : "" %>" <%= otpSent ? "readonly" : "" %> required>
        </div>
        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" class="form-control" placeholder="Email" 
                   value="<%= email != null ? email : "" %>" <%= otpSent ? "readonly" : "" %> required>
        </div>
        <div class="form-group">
            <label>Phone Number</label>
            <input type="text" name="phone" class="form-control" placeholder="Phone" 
                   value="<%= phone != null ? phone : "" %>" <%= otpSent ? "readonly" : "" %> required>
        </div>
        <div class="form-group">
            <label>Role</label>
            <select name="role" class="form-control" <%= otpSent ? "disabled" : "" %> required>
                <option value="">Select Role</option>
                <option value="student" <%= "student".equals(role) ? "selected" : "" %>>Student</option>
                <option value="teacher" <%= "teacher".equals(role) ? "selected" : "" %>>Teacher</option>
            </select>
        </div>

        <% if (!otpSent) { %>
<button type="submit" formaction="SendCustomerOTPServlet" class="btn btn-blue btn-block">Send OTP</button>
        <% } else { %>
            <div class="form-group">
                <label>Enter OTP</label>
                <input type="text" name="otp" class="form-control" placeholder="Enter OTP" required>
            </div>
<button type="submit" formaction="VerifyCustomerOTPServlet" class="btn btn-blue btn-block">Verify OTP</button>
        <% } %>
    </form>
</div>
   

</body>
</html>
