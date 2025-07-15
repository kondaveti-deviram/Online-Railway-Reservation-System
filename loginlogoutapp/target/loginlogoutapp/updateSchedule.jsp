<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Update Train Schedule</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <h1>Railway Booking Platform</h1>
    </header>
    <div class="container">
        <h1>Update Train Schedule</h1>

        <%
            // Retrieve parameters from the request
            String scheduleId = request.getParameter("scheduleId");
            String departureTime = request.getParameter("departureTime");
            String arrivalTime = request.getParameter("arrivalTime");

            // Database connection details
            String dbURL = "jdbc:mysql://localhost:3306/Railway_DB"; 
            String dbUser = "root";
            String dbPassword = "Munna@1999"; // Replace with your database password

            // Check if the necessary fields are provided (departureTime and arrivalTime)
            if (scheduleId == null || scheduleId.trim().isEmpty() ||
                departureTime == null || departureTime.trim().isEmpty() ||
                arrivalTime == null || arrivalTime.trim().isEmpty()) {

                out.println("<p style='color:red;'>Schedule ID, Departure Time, and Arrival Time are required. Please fill out the form completely.</p>");
            } else {
                try {
                    // Load JDBC driver and establish a connection
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                    // Query to get the current schedule details (other fields remain unchanged)
                    String getScheduleSql = "SELECT origin, destination, total_fare FROM train_schedules WHERE id = ?";
                    PreparedStatement psGetSchedule = conn.prepareStatement(getScheduleSql);
                    psGetSchedule.setInt(1, Integer.parseInt(scheduleId));
                    ResultSet rs = psGetSchedule.executeQuery(); // Corrected comment syntax

                    if (rs.next()) {
                        // Get current values for origin, destination, and fare
                        String origin = rs.getString("origin");
                        String destination = rs.getString("destination");
                        double fare = rs.getDouble("total_fare");

                        // Query to update the schedule details
                        String updateSql = "UPDATE train_schedules SET departure_time = ?, arrival_time = ? WHERE id = ?";
                        PreparedStatement psUpdate = conn.prepareStatement(updateSql);
                        psUpdate.setString(1, departureTime.trim());
                        psUpdate.setString(2, arrivalTime.trim());
                        psUpdate.setInt(3, Integer.parseInt(scheduleId));

                        int rowsUpdated = psUpdate.executeUpdate();
                        if (rowsUpdated > 0) {
                            out.println("<p style='color:green;'>Schedule updated successfully!</p>");
                            response.sendRedirect("repDashboard.jsp"); // Redirect to repDashboard.jsp
                        } else {
                            out.println("<p style='color:red;'>Error updating schedule. Please check the data and try again.</p>");
                        }

                        // Close resources
                        psUpdate.close();
                        psGetSchedule.close();
                        rs.close();
                    } else {
                        out.println("<p style='color:red;'>Schedule not found for the given ID.</p>");
                    }

                    conn.close();
                } catch (Exception e) {
                    out.println("<p style='color:red;'>Database error: " + e.getMessage() + "</p>");
                }
            }
        %>
    </div>
</body>
</html>
