<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Dashboard</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>

    <header>
        <h1>Railway Booking Platform</h1>
    </header>
    <%
        String username = (String) session.getAttribute("username");
        String role = (String) session.getAttribute("role");
        if (username == null || !"customer".equals(role)) {
            response.sendRedirect("login.jsp");
        }
    %>
    <div class="container">
        
        <h1>Welcome, <%= username %>!</h1>
        <div class="dashboard-buttons">
            <!-- Search Train Schedules -->
            <a href="search.jsp">
                <button class="action-button">Search Train Schedules</button>
            </a>

            <!-- View Reservations -->
            <a href="viewReservations.jsp">
                <button class="action-button">Reservations</button>
            </a>

            <!-- Help Button -->
            <a href="help.jsp">
                <button class="action-button">Any Help?</button>
            </a>
        </div>

        <a href="logout.jsp">
            <button class="logout-button">Logout</button>
        </a>
    </div>
</body>
</html>
