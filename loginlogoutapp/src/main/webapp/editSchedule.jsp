<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Train Schedule</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <h1>Railway Booking Platform</h1>
    </header>
    <div class="container">
        <h1>Edit Train Schedule</h1>
        
        <%
            String scheduleId = request.getParameter("scheduleId");

            // Database connection details
            String dbURL = "jdbc:mysql://localhost:3306/Railway_DB"; // Updated to correct database
            String dbUser = "root";
            String dbPassword = "Munna@1999"; // Replace with your database password

            // Variable to store success message
            String successMessage = "";

            // Handle form submission
            String updatedScheduleId = request.getParameter("scheduleId");
            String updatedDepartureTime = request.getParameter("departureTime");
            String updatedArrivalTime = request.getParameter("arrivalTime");

            if (updatedScheduleId != null && !updatedScheduleId.trim().isEmpty() && 
                updatedDepartureTime != null && !updatedDepartureTime.trim().isEmpty() && 
                updatedArrivalTime != null && !updatedArrivalTime.trim().isEmpty()) {
                // Update the schedule in the database
                try {
                    Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                    String updateSql = "UPDATE train_schedules SET departure_time = ?, arrival_time = ? WHERE id = ?";
                    PreparedStatement psUpdate = conn.prepareStatement(updateSql);
                    psUpdate.setString(1, updatedDepartureTime);
                    psUpdate.setString(2, updatedArrivalTime);
                    psUpdate.setInt(3, Integer.parseInt(updatedScheduleId));

                    int rowsUpdated = psUpdate.executeUpdate();

                    if (rowsUpdated > 0) {
                        // Schedule updated successfully, show success message
                        successMessage = "Updated the schedule successfully!";
                    } else {
                        // Error updating schedule
                        successMessage = "Error updating schedule. Please try again.";
                    }

                    psUpdate.close();
                    conn.close();
                } catch (Exception e) {
                    successMessage = "Database error: " + e.getMessage();
                }
            }

            // Query to retrieve the schedule details if not updated yet
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                // Query to retrieve the schedule details by scheduleId
                String sql = "SELECT * FROM train_schedules WHERE id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(scheduleId));
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    String train = rs.getString("train");
                    String origin = rs.getString("origin");
                    String destination = rs.getString("destination");
                    String departureTime = rs.getString("departure_time");
                    String arrivalTime = rs.getString("arrival_time");

                    // Display the existing details in the form fields
                    out.println("<form method='post' action='updateSchedule.jsp'>");
                    out.println("<input type='hidden' name='scheduleId' value='" + scheduleId + "'>");
                    out.println("<label for='train'>Train:</label><input type='text' name='train' value='" + train + "' readonly><br>");
                    out.println("<label for='origin'>Origin:</label><input type='text' name='origin' value='" + origin + "' readonly><br>");
                    out.println("<label for='destination'>Destination:</label><input type='text' name='destination' value='" + destination + "' readonly><br>");
                    out.println("<label for='departureTime'>Departure Time:</label><input type='datetime-local' name='departureTime' value='" + departureTime + "' required><br>");
                    out.println("<label for='arrivalTime'>Arrival Time:</label><input type='datetime-local' name='arrivalTime' value='" + arrivalTime + "' required><br>");
                    out.println("<button type='submit'>Update Schedule</button>");
                    out.println("</form>");
                } else {
                    out.println("<p>Schedule not found.</p>");
                }

                rs.close();
                ps.close();
                conn.close();
            } catch (Exception e) {
                out.println("<p style='color:red;'>Database error: " + e.getMessage() + "</p>");
            }

            // Display the success or error message
            if (!successMessage.isEmpty()) {
                out.println("<p style='color:green;'>" + successMessage + "</p>");
            }
        %>

        <a href="repDashboard.jsp">
            <button class="action-button">Go to Customer Representative Dashboard</button>
        </a>
    </div>
</body>
</html>
