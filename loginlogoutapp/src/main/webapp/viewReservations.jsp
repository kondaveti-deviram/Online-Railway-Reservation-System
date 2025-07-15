<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    int customerId = 0;

    // Check if the user is logged in and has the "customer" role
    if (username == null || !"customer".equals(role)) {
        response.sendRedirect("login.jsp"); // Redirect to login if not a customer
        return;
    }

    try {
        String dbURL = "jdbc:mysql://localhost:3306/Railway_DB"; // Database URL
        String dbUser = "root";  // Database user
        String dbPassword = "Munna@1999";  // Database password

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // Get customer ID from username
        String sql = "SELECT id FROM customers WHERE username = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            customerId = rs.getInt("id"); // Set customerId from database
        }

        rs.close();
        ps.close();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Reservations</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        /* Action button styling */
        .cancel-button {
            background-color: #c70039; /* Red color */
            color: white; /* Text color */
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            font-size: 16px;
            text-align: center;
            display: block;
            margin: 0 auto; /* This centers the button */
            width: 150px; /* Set width of the button */
            border-radius: 5px; /* Optional: rounded corners */
            text-decoration: none; /* Remove underline */
        }

        .cancel-button:hover {
            background-color: #a4002a; /* Slightly darker red when hovered */
        }
    </style>
</head>
<body>
    <header>
        <h1>Railway Booking Platform</h1>
    </header>
    <div class="container">
        <h1>Your Reservations</h1>

        <%
            // Fetch active reservations (status = 'active') for the logged-in customer
            String activeSql = "SELECT r.reservation_number, t.train, t.origin, t.destination, r.total_fare, r.reservation_date " +
                               "FROM reservations r " +
                               "JOIN train_schedules t ON r.schedule_id = t.id " +
                               "WHERE r.customer_id = ? AND r.status = 'active'";
            ps = conn.prepareStatement(activeSql);
            ps.setInt(1, customerId);
            rs = ps.executeQuery();

            if (!rs.isBeforeFirst()) {
                out.println("<p class='no-reservations'>No current reservations.</p>");
            } else {
                out.println("<h2>Current Reservations</h2>");
                out.println("<table border='1'><tr><th>Reservation No</th><th>Train</th><th>Origin</th><th>Destination</th><th>Fare</th><th>Date</th><th>Action</th></tr>");
                while (rs.next()) {
                    out.println("<tr><td>" + rs.getInt("reservation_number") + "</td><td>" + rs.getString("train") + "</td><td>" + rs.getString("origin") + "</td><td>" + rs.getString("destination") + "</td><td>$" + rs.getDouble("total_fare") + "</td><td>" + rs.getTimestamp("reservation_date") + "</td>");
                    out.println("<td style='text-align: center;'><a href='cancelReservation.jsp?reservationNumber=" + rs.getInt("reservation_number") + "'><button class='cancel-button'>Cancel</button></a></td></tr>");
                }
                out.println("</table>");
            }

            rs.close();
            ps.close();

            // Fetch past (canceled) reservations (status = 'canceled') for the logged-in customer
            String canceledSql = "SELECT r.reservation_number, t.train, t.origin, t.destination, r.total_fare, r.reservation_date " +
                                 "FROM reservations r " +
                                 "JOIN train_schedules t ON r.schedule_id = t.id " +
                                 "WHERE r.customer_id = ? AND r.status = 'canceled'";
            ps = conn.prepareStatement(canceledSql);
            ps.setInt(1, customerId);
            rs = ps.executeQuery();

            if (!rs.isBeforeFirst()) {
                out.println("<p class='no-reservations'>No past reservations.</p>");
            } else {
                out.println("<h2>Past Reservations</h2>");
                out.println("<table border='1'><tr><th>Reservation No</th><th>Train</th><th>Origin</th><th>Destination</th><th>Fare</th><th>Date</th></tr>");
                while (rs.next()) {
                    out.println("<tr><td>" + rs.getInt("reservation_number") + "</td><td>" + rs.getString("train") + "</td><td>" + rs.getString("origin") + "</td><td>" + rs.getString("destination") + "</td><td>$" + rs.getDouble("total_fare") + "</td><td>" + rs.getTimestamp("reservation_date") + "</td></tr>");
                }
                out.println("</table>");
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            out.println("<p class='error'>Database error: " + e.getMessage() + "</p>");
        }
        %>

        <a href="welcome.jsp">
            <button class="action-button">Go to Dashboard</button>
        </a>
    </div>
</body>
</html>
