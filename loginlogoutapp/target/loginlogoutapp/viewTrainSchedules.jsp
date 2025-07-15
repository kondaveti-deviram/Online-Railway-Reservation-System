<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Train Schedules</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <h1>Railway Booking Platform</h1>
    </header>
    <div class="container">
        <h1>View Train Schedules</h1>
        <form method="get">
            <label for="station">Select Station:</label>
            <select id="station" name="station" required>
                <option value="">--Select--</option>
                <% 
                    // Database connection details
                    String dbURL = "jdbc:mysql://localhost:3306/Railway_DB";
                    String dbUser = "root";
                    String dbPassword = "Munna@1999"; // Replace with your password
                    
                    try {
                        // Step 1: Establish the connection
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                        // Step 2: Query to get distinct stations (origins and destinations)
                        String stationQuery = "SELECT DISTINCT origin AS station FROM train_schedules " +
                                              "UNION " +
                                              "SELECT DISTINCT destination AS station FROM train_schedules";
                        PreparedStatement stationPs = conn.prepareStatement(stationQuery);
                        ResultSet stationRs = stationPs.executeQuery();

                        // Step 3: Populate the dropdown with station values
                        while (stationRs.next()) {
                            String stationName = stationRs.getString("station");
                            out.println("<option value='" + stationName + "'>" + stationName + "</option>");
                        }

                        // Close the result set and prepared statement
                        stationRs.close();
                        stationPs.close();
                        conn.close();
                    } catch (Exception e) {
                        out.println("<p style='color:red;'>Error fetching stations: " + e.getMessage() + "</p>");
                    }
                %>
            </select>
            <button type="submit">Search</button>
        </form>

        <% 
            // Handle station selection and query train schedules
            String selectedStation = request.getParameter("station");
            if (selectedStation != null && !selectedStation.isEmpty()) {
                try {
                    // Establish connection
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                    // Query to fetch train schedules for the selected station
                    String scheduleQuery = "SELECT transit_line_name, train, origin, destination, departure_time, arrival_time, total_fare " +
                                           "FROM train_schedules WHERE origin = ? OR destination = ?";
                    PreparedStatement ps = conn.prepareStatement(scheduleQuery);
                    ps.setString(1, selectedStation);
                    ps.setString(2, selectedStation);
                    ResultSet rs = ps.executeQuery();

                    // Output the schedules in a table
                    out.println("<h2>Train Schedules for Station: " + selectedStation + "</h2>");
                    out.println("<table border='1'>");
                    out.println("<tr><th>Transit Line</th><th>Train</th><th>Origin</th><th>Destination</th><th>Departure Time</th><th>Arrival Time</th><th>Total Fare</th></tr>");

                    while (rs.next()) {
                        out.println("<tr>");
                        out.println("<td>" + rs.getString("transit_line_name") + "</td>");
                        out.println("<td>" + rs.getString("train") + "</td>");
                        out.println("<td>" + rs.getString("origin") + "</td>");
                        out.println("<td>" + rs.getString("destination") + "</td>");
                        out.println("<td>" + rs.getTimestamp("departure_time") + "</td>");
                        out.println("<td>" + rs.getTimestamp("arrival_time") + "</td>");
                        out.println("<td>$" + rs.getBigDecimal("total_fare") + "</td>");
                        out.println("</tr>");
                    }

                    out.println("</table>");
                    
                    // Close resources
                    rs.close();
                    ps.close();
                    conn.close();
                } catch (Exception e) {
                    out.println("<p style='color:red;'>Error fetching schedules: " + e.getMessage() + "</p>");
                }
            }
        %>
        <a href="repDashboard.jsp">
            <button class="action-button">Go to Customer Representative Dashboard</button>
        </a>
    </div>
</body>
</html>
