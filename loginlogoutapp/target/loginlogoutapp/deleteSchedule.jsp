<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Delete Train Schedule</title>
    <link rel="stylesheet" href="styles.css">
    <script>
        // Redirect to manageSchedules.jsp after 5 seconds
        setTimeout(function () {
            window.location.href = "manageSchedules.jsp";
        }, 5000);
    </script>
</head>
<body>
    <header>
        <h1>Railway Booking Platform</h1>
    </header>
    <div class="container">
        <h1>Delete Train Schedule</h1>

        <%

            String username = (String) session.getAttribute("username");
            String role = (String) session.getAttribute("role");
            if (username == null || !"rep".equals(role)) {
                response.sendRedirect("login.jsp");
            }
            String scheduleId = request.getParameter("scheduleId");

            // Database connection details
            String dbURL = "jdbc:mysql://localhost:3306/Railway_DB"; // Updated to correct database
            String dbUser = "root";
            String dbPassword = "Munna@1999"; // Replace with your database password

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                // Step 1: Delete related records from train_stops table
                String deleteStopsSql = "DELETE FROM train_stops WHERE train_schedule_id = ?";
                PreparedStatement psDeleteStops = conn.prepareStatement(deleteStopsSql);
                psDeleteStops.setInt(1, Integer.parseInt(scheduleId));
                psDeleteStops.executeUpdate();
                psDeleteStops.close();

                // Step 2: Delete related records from reservations table
                String deleteReservationsSql = "DELETE FROM reservations WHERE schedule_id = ?";
                PreparedStatement psDeleteReservations = conn.prepareStatement(deleteReservationsSql);
                psDeleteReservations.setInt(1, Integer.parseInt(scheduleId));
                psDeleteReservations.executeUpdate();
                psDeleteReservations.close();

                // Step 3: Delete the schedule itself
                String deleteScheduleSql = "DELETE FROM train_schedules WHERE id = ?";
                PreparedStatement psDeleteSchedule = conn.prepareStatement(deleteScheduleSql);
                psDeleteSchedule.setInt(1, Integer.parseInt(scheduleId));

                int rowsDeleted = psDeleteSchedule.executeUpdate();
                if (rowsDeleted > 0) {
                    out.println("<p style='color:green;'>Schedule deleted successfully! Redirecting to manage schedules page</p>");
                } else {
                    out.println("<p style='color:red;'>Error deleting schedule. Schedule not found. Redirecting to manage schedules...</p>");
                }

                psDeleteSchedule.close();
                conn.close();
            } catch (Exception e) {
                out.println("<p style='color:red;'>Database error: " + e.getMessage() + "</p>");
            }
        %>
    </div>
</body>
</html>
