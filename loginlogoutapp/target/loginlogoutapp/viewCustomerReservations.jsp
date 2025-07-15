<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Customer Reservations</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <h1>Railway Booking Platform</h1>
    </header>
    <div class="container">
        <h1>View Customer Reservations</h1>
        <form method="get">
            <label for="transitLine">Transit Line:</label>
            <select id="transitLine" name="transitLine" required>
                <option value="">--Select Transit Line--</option>
                <% 
                    // Database connection details
                    String dbURL = "jdbc:mysql://localhost:3306/Railway_DB";
                    String dbUser  = "root";
                    String dbPassword = "Munna@1999"; // Replace with your database password

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection(dbURL, dbUser , dbPassword);

                        // Fetch distinct transit line names
                        String lineQuery = "SELECT DISTINCT transit_line_name FROM train_schedules";
                        PreparedStatement linePs = conn.prepareStatement(lineQuery);
                        ResultSet lineRs = linePs.executeQuery();

                        // Populate the dropdown
                        while (lineRs.next()) {
                            String lineName = lineRs.getString("transit_line_name");
                            out.println("<option value='" + lineName + "'>" + lineName + "</option>");
                        }

                        // Close resources
                        lineRs.close();
                        linePs.close();
                        conn.close();
                    } catch (Exception e) {
                        out.println("<option value='' disabled>Error fetching transit lines</option>");
                    }
                %>
            </select>

            <label for="departureDate">Departure Date:</label>
            <input type="date" id="departureDate" name="departureDate" required>

            <button type="submit">Search</button>
        </form>

        <% 
            String transitLine = request.getParameter("transitLine");
            String departureDate = request.getParameter("departureDate");

            if (transitLine != null && !transitLine.isEmpty() && departureDate != null && !departureDate.isEmpty()) {
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(dbURL, dbUser , dbPassword);

                    // Modified query to fetch only active reservations
                    String sql = "SELECT c.username AS customer_name, ts.transit_line_name, r.total_fare, ts.departure_time " +
                                 "FROM reservations r " +
                                 "JOIN customers c ON r.customer_id = c.id " +
                                 "JOIN train_schedules ts ON r.schedule_id = ts.id " +
                                 "WHERE ts.transit_line_name = ? AND DATE(ts.departure_time) = ? AND r.status = 'active'";
                    ps = conn.prepareStatement(sql);
                    ps.setString(1, transitLine);
                    ps.setString(2, departureDate);
                    rs = ps.executeQuery();

                    out.println("<h2>Customer Reservations for Transit Line: " + transitLine + " on " + departureDate + "</h2>");
                    out.println("<table border='1'><tr><th>Customer Name</th><th>Transit Line</th><th>Total Fare</th><th>Departure Time</th></tr>");
                    while (rs.next()) {
                        out.println("<tr>");
                        out.println("<td>" + rs.getString("customer_name") + "</td>");
                        out.println("<td>" + rs.getString("transit_line_name") + "</td>");
                        out.println("<td>$" + rs.getDouble("total_fare") + "</td>");
                        out.println("<td>" + rs.getTimestamp("departure_time") + "</td>");
                        out.println("</tr>");
                    }
                    out.println("</table>");
                } catch (Exception e) {
                    out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                        if (conn != null) conn.close();
                    } catch (Exception e) {
                        out.println("<p class='error'>Error closing resources: " + e.getMessage() + "</p>");
                    }
                }
            }
        %>
        <a href="repDashboard.jsp">
            <button class="action-button">Go to Customer Representative Dashboard</button>
        </a>
    </div>
</body>
</html>
