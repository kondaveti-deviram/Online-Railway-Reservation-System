<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || !"rep".equals(role)) {
        response.sendRedirect("login.jsp");
    }

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Representative Dashboard</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <h1>Railway Booking Platform</h1>
    </header>
    <div class="container">
        <h1>Customer Representative Dashboard</h1>

        <div class="dashboard-buttons">
            <!-- Manage Train Schedules -->
            <form action="manageSchedules.jsp" method="get">
                <button type="submit" class="button">Edit/Delete Train Schedules</button>
            </form>
            <form action="viewTrainSchedules.jsp" method="get">
                <button type="submit" class="button">View Train Schedules by Station</button>
            </form>

            <!-- View Reservations -->
            <form action="viewCustomerReservations.jsp" method="get">
                <button type="submit" class="button">View Reservations by Transit Line and Date</button>
            </form>

             <!-- Message Center -->
             <form action="messageCenter.jsp" method="get">
                <button type="submit" class="button">Message Center</button>
            </form>
        </div>

        <!-- Logout -->
        <a href="logout.jsp">
            <button class="logout-button">Logout</button>
        </a>
    </div>
</body>
</html>
