<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Top 5 Active Transit Lines</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <h1>Railway Booking Platform</h1>
    </header>
    <div class="container">
        <h1>Top 5 Most Active Transit Lines</h1>
        <%
            String dbURL = "jdbc:mysql://localhost:3306/Railway_DB";
            String dbUser = "root";
            String dbPassword = "Munna@1999";

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                // Query to fetch top 5 most active transit lines
                String sql = "SELECT ts.transit_line_name, COUNT(r.reservation_number) AS reservation_count " +
                             "FROM reservations r " +
                             "JOIN train_schedules ts ON r.schedule_id = ts.id " +
                             "WHERE r.status = 'active' " +
                             "GROUP BY ts.transit_line_name " +
                             "ORDER BY reservation_count DESC " +
                             "LIMIT 5";
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery();

                out.println("<table border='1'><tr><th>Transit Line</th><th>Number of Reservations</th></tr>");
                while (rs.next()) {
                    String transitLine = rs.getString("transit_line_name");
                    int reservationCount = rs.getInt("reservation_count");
                    out.println("<tr>");
                    out.println("<td>" + transitLine + "</td>");
                    out.println("<td>" + reservationCount + "</td>");
                    out.println("</tr>");
                }
                out.println("</table>");

                // Close resources
                rs.close();
                ps.close();
                conn.close();
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            }
        %>
        <a href="adminDashboard.jsp">
            <button class="action-button">Back to Dashboard</button>
        </a>
    </div>
</body>
</html>
