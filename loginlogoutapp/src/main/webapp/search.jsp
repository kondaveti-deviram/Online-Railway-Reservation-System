<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page session="true" %>
<%
String username = (String) session.getAttribute("username");
String role = (String) session.getAttribute("role");
if (username == null || !"customer".equals(role)) {
    response.sendRedirect("login.jsp");
}

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Search Train Schedules</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <h1>Railway Booking Platform</h1>
    </header>
       
    <div class="container">
        <h1>Search Train Schedules</h1>
        <!-- Search Form -->
        <form method="post">
            <label for="origin">Origin:</label>
            <select name="origin" required>
                <option value="" disabled selected>Select Origin</option>
                <%
                    // Database connection details
                    String dbURL = "jdbc:mysql://localhost:3306/Railway_DB"; // Changed to Railway_DB
                    String dbUser = "root";   // Replace with your database username
                    String dbPassword = "Munna@1999"; // Replace with your database password

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                        // Query to get unique origins
                        String sql = "SELECT DISTINCT origin FROM train_schedules";
                        PreparedStatement ps = conn.prepareStatement(sql);
                        ResultSet rs = ps.executeQuery();

                        // Populate dropdown options for origin
                        while (rs.next()) {
                            String origin = rs.getString("origin");
                            out.println("<option value='" + origin + "'>" + origin + "</option>");
                        }

                        rs.close();
                        ps.close();
                        conn.close();
                    } catch (Exception e) {
                        out.println("<option value=''>Error loading origins</option>");
                    }
                %>
            </select>
            
            <label for="destination">Destination:</label>
            <select name="destination" required>
                <option value="" disabled selected>Select Destination</option>
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                        // Query to get unique destinations
                        String sql = "SELECT DISTINCT destination FROM train_schedules";
                        PreparedStatement ps = conn.prepareStatement(sql);
                        ResultSet rs = ps.executeQuery();

                        // Populate dropdown options for destination
                        while (rs.next()) {
                            String destination = rs.getString("destination");
                            out.println("<option value='" + destination + "'>" + destination + "</option>");
                        }

                        rs.close();
                        ps.close();
                        conn.close();
                    } catch (Exception e) {
                        out.println("<option value=''>Error loading destinations</option>");
                    }
                %>
            </select>
            
            <label for="date">Date of Travel:</label>
            <input type="date" name="date" required>
            
            <label for="sort">Sort By:</label>
            <select name="sort" required>
                <option value="departure_time">Departure Time</option>
                <option value="arrival_time">Arrival Time</option>
                <option value="total_fare">Fare</option>
            </select>
            
            <button type="submit">Search</button>
        </form>

        <%
            if (request.getMethod().equalsIgnoreCase("POST")) {
                String origin = request.getParameter("origin");
                String destination = request.getParameter("destination");
                String travelDate = request.getParameter("date");
                String sortBy = request.getParameter("sort");

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                    // Query with sorting
                    String sql = "SELECT * FROM train_schedules WHERE origin = ? AND destination = ? AND DATE(departure_time) = ? ORDER BY " + sortBy;
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ps.setString(1, origin);
                    ps.setString(2, destination);
                    ps.setString(3, travelDate);

                    ResultSet rs = ps.executeQuery();

                    if (!rs.isBeforeFirst()) {
                        out.println("<p class='error'>No schedules found for the selected criteria.</p>");
                    } else {
                        // Display results in a table
                        out.println("<h2>Available Train Schedules</h2>");
                        out.println("<table border='1'><tr><th>Transit Line</th><th>Train</th><th>Origin</th><th>Destination</th><th>Departure Time</th><th>Arrival Time</th><th>Fare</th><th>Actions</th></tr>");

                        while (rs.next()) {
                            String transitLine = rs.getString("transit_line_name");
                            String trainNumber = rs.getString("train");
                            String departureTime = rs.getString("departure_time");
                            String arrivalTime = rs.getString("arrival_time");
                            String fare = rs.getString("total_fare");
                            int scheduleId = rs.getInt("id");

                            out.println("<tr><td>" + transitLine + "</td><td>" + trainNumber + "</td><td>" + origin + "</td><td>" + destination + "</td><td>" + departureTime + "</td><td>" + arrivalTime + "</td><td>" + fare + "</td>");
                            out.println("<td>");
                            out.println("<form action='makeReservation.jsp' method='get'>");
                            out.println("<button type='submit' name='scheduleId' value='" + scheduleId + "'>Make Reservation</button>");
                            out.println("<input type='hidden' name='origin' value='" + origin + "'>");
                            out.println("<input type='hidden' name='destination' value='" + destination + "'>");
                            out.println("<input type='hidden' name='date' value='" + travelDate + "'>");
                            out.println("</form>");
                            out.println("<form action='viewScheduleDetails.jsp' method='get'>");
                            out.println("<button type='submit' name='scheduleId' value='" + scheduleId + "'>View Stops</button>");
                            out.println("</form>");
                            out.println("</td></tr>");
                        }

                        out.println("</table>");
                    }

                    rs.close();
                    ps.close();
                    conn.close();
                } catch (Exception e) {
                    out.println("<p class='error'>Database error: " + e.getMessage() + "</p>");
                }
            }
        %>
        <a href="welcome.jsp">
            <button class="action-button">Go to Dashboard</button>
        </a>
    </div>
</body>
</html>
