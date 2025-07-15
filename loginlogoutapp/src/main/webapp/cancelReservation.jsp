<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Cancel Reservation</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <h1>Railway Booking Platform</h1>
    </header>
    <div class="container">
        <h1>Cancel Reservation</h1>
        <%
            String username = (String) session.getAttribute("username");
            String role = (String) session.getAttribute("role");
            if (username == null || !"customer".equals(role)) {
                response.sendRedirect("login.jsp");
            }

            String reservationNumber = request.getParameter("reservationNumber");

            if (reservationNumber != null) {
                String dbURL = "jdbc:mysql://localhost:3306/Railway_DB";
                String dbUser = "root";
                String dbPassword = "Munna@1999"; // Replace with your database password

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                    // Check if the reservation is active
                    String checkSql = "SELECT status FROM reservations WHERE reservation_number = ? AND status = 'active'";
                    PreparedStatement checkPs = conn.prepareStatement(checkSql);
                    checkPs.setInt(1, Integer.parseInt(reservationNumber));
                    ResultSet checkRs = checkPs.executeQuery();

                    if (checkRs.next()) {
                        // Reservation is active, proceed to cancel
                        String sql = "UPDATE reservations SET status = 'canceled' WHERE reservation_number = ?";
                        PreparedStatement ps = conn.prepareStatement(sql);
                        ps.setInt(1, Integer.parseInt(reservationNumber));

                        int rowsUpdated = ps.executeUpdate();

                        if (rowsUpdated > 0) {
                            out.println("<p class='success'>Reservation canceled successfully!</p>");
                        } else {
                            out.println("<p class='error'>Failed to cancel the reservation.</p>");
                        }

                        ps.close();
                    } else {
                        // No active reservation found with the provided number
                        out.println("<p class='error'>No active reservation found to cancel. The reservation may already be canceled or does not exist.</p>");
                    }

                    checkRs.close();
                    checkPs.close();
                    conn.close();
                } catch (Exception e) {
                    out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
                }
            } else {
                // If no reservation number is provided, inform the user
                out.println("<p class='error'>No reservation number provided. Please ensure you're accessing the cancellation page correctly.</p>");
            }
        %>

        <h3>Back to Reservations</h3>
        <a href="viewReservations.jsp">
            <button class="action-button">View Reservations</button>
        </a>
    </div>
</body>
</html>
