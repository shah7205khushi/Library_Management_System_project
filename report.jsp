<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Admin - User Management - DCS library</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="" name="keywords">
        <meta content="" name="description">

        <link href="img/favicon.ico" rel="icon">

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600;700&display=swap" rel="stylesheet">

        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

        <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
        <link href="lib/tempusdominus/css/tempusdominus-bootstrap-4.min.css" rel="stylesheet" />

        <link href="css/bootstrap.min.css" rel="stylesheet">

        <link href="css/style.css" rel="stylesheet">
    </head>
    <body>
        <div class="container-xxl position-relative bg-white d-flex p-0">
            <div class="sidebar pe-4 pb-3">
                <nav class="navbar bg-light navbar-light">
                    <a href="admin_dashboard.jsp" class="navbar-brand mx-4 mb-3"> <h3 class="text-primary">ADMIN <BR>DASHBOARD</h3>
                    </a>
                    <!--session display start-->
                    <%@ page session="true" %>
                    <%
                        String userName = (String) session.getAttribute("admin_name");
                        if (userName == null || userName.isEmpty()) {
                            response.sendRedirect("admin_login.jsp");
                            return;
                        }
                    %>

                    <div class="d-flex align-items-center ms-4 mb-4">
                        <div class="position-relative border-2">
                        </div>
                        <div class="ms-3">
                            <h6 class="mb-0">
                                <%= (userName != null && !userName.isEmpty()) ? userName : "Welcome Admin"%>
                            </h6>
                            <span><%= "admin"%></span>
                        </div>
                    </div>
                    <!--session display end-->
                    <div class="navbar-nav w-100">
                        <a href="admin_dashboard.jsp" class="nav-item nav-link"><i class="bi bi-speedometer2 me-2"></i>Dashboard</a>
                        <a href="transaction.jsp" class="nav-item nav-link"><i class="bi bi-arrow-left-right me-2"></i>Transactions</a>
                        <a href="usermanagement.jsp" class="nav-item nav-link "><i class="bi bi-people-fill me-2"></i>Users</a>
                        <a href="books.jsp" class="nav-item nav-link"><i class="bi bi-book me-2"></i>Books</a> 
                        <a href="subject.jsp" class="nav-item nav-link"><i class="bi bi-collection me-2"></i>Subjects</a> 
                        <a href="report.jsp" class="nav-item nav-link active"><i class="bi bi-bar-chart-fill me-2"></i>Reports</a> </div>
                </nav>
            </div>
            <div class="content">
                <nav class="navbar navbar-expand bg-light navbar-light sticky-top px-4 py-0 ">
                    <a href="#" class="sidebar-toggler flex-shrink-0">
                        <i class="fa fa-bars"></i>
                    </a>
                    <div class="navbar-nav align-items-center ms-auto">
                        <form action="logoutServlet" method="post">
                            <!--                            <button class="btn btn-outline-primary" style="z-index: 1050;" type="button" data-bs-toggle="offcanvas" data-bs-target="#userFilterPanel" aria-controls="userFilterPanel">
                                                            <i class="bi bi-funnel-fill"></i> Filter
                                                        </button>-->
                            <button type="submit" class="btn btn-outline-primary m-4">Logout<i class="bi bi-box-arrow-right ms-2"></i></button>
                        </form>
                    </div>
                </nav>

                <div class="container p-4">
                    <div class="tab-content mt-3" id="usersTabContent">
                        <div class="tab-pane fade show active" id="usersListPane" role="tabpanel">


                            <!--report-->
                            <div class="row">
<!-- Book Issue Report -->
<div class="col-md-4">
  <div class="card shadow-sm rounded p-3 mb-4">
    <h5 class="card-title">Book Issue Report</h5>
    <p class="card-text">View all issued books with user details and issue dates.</p>

    <form action="issue_report.jsp" method="post">
      <div class="form-group">
        <label for="from_date">Start Date:</label>
        <input type="date" name="from_date" class="form-control" required>
      </div>
      <div class="form-group mt-2">
        <label for="to_date">End Date:</label>
        <input type="date" id="to_date" name="to_date" class="form-control" required>
      </div>

      <button type="submit" class="btn btn-primary mt-3 w-100">
        <i class="bi bi-file-earmark-check"></i> View Report
      </button>
    </form>
  </div>
</div>

<!-- Script to set default end date as today -->
<script>
  window.addEventListener('DOMContentLoaded', () => {
    const today = new Date();
    const oneMonthAgo = new Date();
    oneMonthAgo.setMonth(today.getMonth() - 1);

    const formatDate = (date) => date.toISOString().split('T')[0];

    document.querySelector('input[name="from_date"]').value = formatDate(oneMonthAgo);
    document.querySelector('input[name="to_date"]').value = formatDate(today);
  });
</script>

<!-- End Book Issue Report -->


  <!-- Return Report -->

<div class="col-md-4">
  <div class="card shadow-sm rounded p-3 mb-4">
    <h5 class="card-title">Book Return Report</h5>
    <p class="card-text">Check all book returns.</p>

    <form action="return_report.jsp" method="get">
      <div class="form-group">
        <label for="from_date">Start Date:</label>
        <input type="date" name="from_date" class="form-control" required>
      </div>
      <div class="form-group mt-2">
        <label for="endDate">End Date:</label>
<input type="date" name="to_date" class="form-control" required>
      </div>
      <button type="submit" class="btn btn-primary mt-3 w-100">
        <i class="bi bi-file-earmark-check"></i> View Report
      </button>
    </form>
  </div>
</div>
<!-- Return Report -->

  <!-- Overdue Report -->
<!-- Overdue Report -->
<div class="col-md-4">
  <div class="card shadow-sm rounded p-3 mb-4">
    <h5 class="card-title">Overdue Report</h5>
    <p class="card-text">List of books not returned by the due date.</p>

    <form action="overdue_report.jsp" method="get">
      <div class="form-group">
        <label for="fromDate">Start Date:</label>
        <input type="date" name="startDate" class="form-control" required value="2024-01-01">
      </div>
      <div class="form-group mt-2">
        <label for="toDate">End Date:</label>
        <input type="date" name="endDate" class="form-control" required value="2025-06-30">
      </div>
      <button type="submit" class="btn btn-primary mt-3 w-100">
        <i class="bi bi-file-earmark-check"></i> View Report
      </button>
    </form>
  </div>
</div>


  <!-- Overdue Report -->

  <!--User Activity Report-->
             <!--User Activity Report-->
<%
    // Generate current and 6 months ago dates
    java.util.Calendar cal = java.util.Calendar.getInstance();
    java.sql.Date currentDate = new java.sql.Date(cal.getTimeInMillis());

    cal.add(java.util.Calendar.MONTH, -6);
    java.sql.Date sixMonthsAgo = new java.sql.Date(cal.getTimeInMillis());
%>

<div class="col-md-4">
  <div class="card shadow-sm rounded p-3 mb-4">
    <h5 class="card-title">User Activity Report</h5>
    <p class="card-text">Track users who are inactive.</p>

    <form action="user_activity_report.jsp" method="get">
      <div class="mb-2">
        <label for="fromDate" class="form-label">From (6 Months Ago)</label>
        <input type="date" class="form-control" id="fromDate" name="from" value="<%= sixMonthsAgo %>" readonly>
      </div>
      <div class="mb-3">
        <label for="toDate" class="form-label">To (Today)</label>
        <input type="date" class="form-control" id="toDate" name="to" value="<%= currentDate %>" readonly>
      </div>
      <button type="submit" class="btn btn-primary w-100">
        <i class="bi bi-people-fill"></i> View Report
      </button>
    </form>
  </div>
</div>

<!--User Activity Report-->
<!--User Activity Report-->

<!--Book Inventory Report-->
<div class="col-md-4">
  <div class="card shadow-sm rounded p-3 mb-4">
    <h5 class="card-title">Book Inventory Report</h5>
    <p class="card-text">View all books with full details.</p>
    <a href="book_inventory_report.jsp" class="btn btn-primary w-100">
      <i class="bi bi-journal-bookmark"></i> View Report
    </a>
  </div>
</div>
<!--Book Inventory Report-->

<!--Reservation Status Report-->
<div class="col-md-4">
  <div class="card shadow-sm rounded p-3 mb-4">
    <h5 class="card-title">Reservation Status Report</h5>
    <p class="card-text">View all reserved books and user details.</p>
    <a href="reservation_status_report.jsp" class="btn btn-primary w-100">
      <i class="bi bi-bookmark-check"></i> View Report
    </a>
  </div>
</div>
<!--Reservation Status Report-->
                            
                            </div>

                            <!--report-->
                            
                            
                        </div> 
                    </div> 
                </div> 
                <div class="container-fluid pt-4 px-4">
                    <div class="bg-light rounded-top p-4">
                        <div class="row">
                            <div class="col-12 col-sm-6 text-center text-sm-start">
                            </div>
                            <div class="col-12 col-sm-6 text-center text-sm-end">
                                Developed with love by <a href="#">DCS Student</a>
                                </br>
                                Keeping Knowledge Accessible for Everyone
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i class="bi bi-arrow-up"></i></a>
        </div> 

        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
        <!--        <script src="lib/easing/easing.min.js"></script>
                <script src="lib/waypoints/waypoints.min.js"></script>
                <script src="lib/owlcarousel/owl.carousel.min.js"></script>
                <script src="lib/tempusdominus/js/moment.min.js"></script>
                <script src="lib/tempusdominus/js/moment-timezone.min.js"></script>-->
        <script src="lib/tempusdominus/js/tempusdominus-bootstrap-4.min.js"></script>

        <script src="js/main.js"></script>

        <script>
            function updateUserFilterDisplay() {
                const params = new URLSearchParams(window.location.search);
                let filtersAreSet = false;

                const userName = params.get("name");
                const regNo = params.get("regNo");
                const email = params.get("email");
                const phone = params.get("phone");
                const userStatus = params.get("status");

                const filterNameContainer = document.getElementById("filterNameContainer");
                const filterRegNoContainer = document.getElementById("filterRegNoContainer");
                const filterEmailContainer = document.getElementById("filterEmailContainer");
                const filterPhoneContainer = document.getElementById("filterPhoneContainer");
                const filterUserStatusContainer = document.getElementById("filterUserStatusContainer");
                const noFiltersMessage = document.getElementById("noFiltersMessage");
                const userTableContainer = document.getElementById("userTableContainer");

                if (userName) {
                    document.getElementById("filterUserName").innerText = userName;
                    filterNameContainer.style.display = "flex";
                    filtersAreSet = true;
                } else {
                    filterNameContainer.style.display = "none";
                }

                if (regNo) {
                    document.getElementById("filterRegNo").innerText = regNo;
                    filterRegNoContainer.style.display = "flex";
                    filtersAreSet = true;
                } else {
                    filterRegNoContainer.style.display = "none";
                }

                if (email) {
                    document.getElementById("filterEmail").innerText = email;
                    filterEmailContainer.style.display = "flex";
                    filtersAreSet = true;
                } else {
                    filterEmailContainer.style.display = "none";
                }

                if (phone) {
                    document.getElementById("filterPhone").innerText = phone;
                    filterPhoneContainer.style.display = "flex";
                    filtersAreSet = true;
                } else {
                    filterPhoneContainer.style.display = "none";
                }

                if (userStatus) {
                    const statusLabel = userStatus.charAt(0).toUpperCase() + userStatus.slice(1);
                    document.getElementById("filterUserStatus").innerText = statusLabel;
                    filterUserStatusContainer.style.display = "flex";
                    filtersAreSet = true;
                } else {
                    filterUserStatusContainer.style.display = "none";
                }

                if (filtersAreSet) {
                    noFiltersMessage.style.display = "none";
                    userTableContainer.style.display = "block";
                } else {
                    noFiltersMessage.style.display = "block";
                    userTableContainer.style.display = "none";
                }
            }

            document.getElementById("userFilterForm").addEventListener("submit", function (e) {
                e.preventDefault();
                const params = new URLSearchParams();
                const userName = document.getElementById("userName").value.trim();
                const regNo = document.getElementById("regNo").value.trim();
                const email = document.getElementById("email").value.trim();
                const phone = document.getElementById("phone").value.trim();
                const userStatus = document.getElementById("userStatus").value;

                if (userName)
                    params.append("name", userName);
                if (regNo)
                    params.append("regNo", regNo);
                if (email)
                    params.append("email", email);
                if (phone)
                    params.append("phone", phone);
                if (userStatus)
                    params.append("status", userStatus);

                window.location.search = params.toString();
            });

            document.getElementById("clearFiltersButton").addEventListener("click", function () {
                document.getElementById("userFilterForm").reset();
                window.location.href = window.location.pathname;
            });

            window.addEventListener("DOMContentLoaded", updateUserFilterDisplay);
        </script>

    </body>
</html>