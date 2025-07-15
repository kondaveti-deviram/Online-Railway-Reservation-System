<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Best Customer</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <h1>Railway Booking Platform</h1>
    </header>
    <div class="container">
        <h1>Best Customer</h1>
        <%
            String dbURL = "jdbc:mysql://localhost:3306/Railway_DB";
            String dbUser = "root";
            String dbPassword = "Munna@1999";

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                // Query to fetch the best customer
                String sql = "SELECT c.username, SUM(r.total_fare) AS total_spent " +
                             "FROM reservations r " +
                             "JOIN customers c ON r.customer_id = c.id " +
                             "WHERE r.status = 'active' " +
                             "GROUP BY c.username " +
                             "ORDER BY total_spent DESC " +
                             "LIMIT 1";
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    String customerUsername = rs.getString("username");
                    double totalSpent = rs.getDouble("total_spent");
                    out.println("<p><strong>Best Customer: </strong>" + customerUsername + "</p>");
                    out.println("<p><strong>Total Spent: $ </strong>"+ totalSpent + "</p>");
                } else {
                    out.println("<p>No active customers found.</p>");
                }

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
