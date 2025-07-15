<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Train Schedule Details</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <h1>Railway Booking Platform</h1>
    </header>
    <div class="container">
        <h1>Train Schedule Details</h1>
        <%
            String scheduleId = request.getParameter("scheduleId");

            // Database connection details
            String dbURL = "jdbc:mysql://localhost:3306/Railway_DB"; // Updated to Railway_DB
            String dbUser = "root";
            String dbPassword = "Munna@1999"; // Replace with your database password

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                // Query to get the train schedule by scheduleId
                String sql = "SELECT * FROM train_schedules WHERE id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(scheduleId));
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    String transitLineName = rs.getString("transit_line_name");
                    String train = rs.getString("train");
                    String origin = rs.getString("origin");
                    String destination = rs.getString("destination");
                    String departureTime = rs.getString("departure_time");
                    String arrivalTime = rs.getString("arrival_time");
                    String totalFare = rs.getString("total_fare");
                    String travelTime = rs.getString("travel_time");

                    out.println("<h2>Train: " + train + " - " + transitLineName + "</h2>");
                    out.println("<p><strong>Origin:</strong> " + origin + "</p>");
                    out.println("<p><strong>Destination:</strong> " + destination + "</p>");
                    out.println("<p><strong>Departure Time:</strong> " + departureTime + "</p>");
                    out.println("<p><strong>Arrival Time:</strong> " + arrivalTime + "</p>");
                    out.println("<p><strong>Travel Time:</strong> " + travelTime + "</p>");
                    out.println("<p><strong>Total Fare:</strong> $" + totalFare + "</p>");

                    // Get the stops for this train
                    String stopsSql = "SELECT * FROM train_stops WHERE train_schedule_id = ? ORDER BY stop_order";
                    PreparedStatement stopsPs = conn.prepareStatement(stopsSql);
                    stopsPs.setInt(1, Integer.parseInt(scheduleId));
                    ResultSet stopsRs = stopsPs.executeQuery();

                    out.println("<h3>Stops</h3>");
                    out.println("<table border='1'><tr><th>Stop Name</th><th>Arrival Time</th><th>Departure Time</th><th>Incremental Fare</th></tr>");

                    while (stopsRs.next()) {
                        String stopName = stopsRs.getString("stop_name");
                        String arrivalTimeStop = stopsRs.getString("arrival_time");
                        String departureTimeStop = stopsRs.getString("departure_time");
                        String incrementalFare = stopsRs.getString("incremental_fare");

                        out.println("<tr><td>" + stopName + "</td><td>" + arrivalTimeStop + "</td><td>" + departureTimeStop + "</td><td>$" + incrementalFare + "</td></tr>");
                    }

                    out.println("</table>");
                    stopsRs.close();
                    stopsPs.close();
                } else {
                    out.println("<p>Schedule not found.</p>");
                }

                rs.close();
                ps.close();
                conn.close();
            } catch (Exception e) {
                out.println("<p style='color:red;'>Database error: " + e.getMessage() + "</p>");
            }
        %>
    </div>
</body>
</html>
