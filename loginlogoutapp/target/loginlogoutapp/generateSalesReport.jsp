<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page session="true" %>
<%
    // Check for valid session and role
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Generate Sales Report</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <h1>Railway Booking Platform</h1>
    </header>
    <div class="container">
        <h1>Sales Report</h1>
        <form method="post">
            <label for="month">Select Month:</label>
            <input type="month" id="month" name="month" required>
            <button type="submit">Generate Report</button>
        </form>

        <%
            // Get selected month from the form
            String month = request.getParameter("month");

            // Process only if the form was submitted
            if ("POST".equalsIgnoreCase(request.getMethod()) && month != null && !month.isEmpty()) {
                String dbURL = "jdbc:mysql://localhost:3306/Railway_DB";
                String dbUser = "root";
                String dbPassword = "Munna@1999"; // Replace with your database password

                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                ResultSet discountRs = null;

                try {
                    // Connect to the database
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                    // Fetch discount percentages
                    String discountSql = "SELECT * FROM fare_discounts";
                    PreparedStatement discountPs = conn.prepareStatement(discountSql);
                    discountRs = discountPs.executeQuery();

                    float childDiscount = 0.25f; // Default discount
                    float seniorDiscount = 0.35f; // Default discount
                    float disabledDiscount = 0.50f; // Default discount

                    while (discountRs.next()) {
                        String discountType = discountRs.getString("type");
                        float discountPercentage = discountRs.getFloat("discount_percentage") / 100;
                        switch (discountType) {
                            case "Child":
                                childDiscount = discountPercentage;
                                break;
                            case "Senior":
                                seniorDiscount = discountPercentage;
                                break;
                            case "Disabled":
                                disabledDiscount = discountPercentage;
                                break;
                        }
                    }

                    // Aggregate total tickets and revenue (only for active reservations)
                    String sql = "SELECT " +
                                 "    SUM(r.num_adults) AS total_adults, " +
                                 "    SUM(r.num_children) AS total_children, " +
                                 "    SUM(r.num_seniors) AS total_seniors, " +
                                 "    SUM(r.num_disabled) AS total_disabled, " +
                                 "    SUM(r.num_adults + r.num_children + r.num_seniors + r.num_disabled) AS total_tickets, " +
                                 "    SUM(r.num_adults * ts.total_fare + " +
                                 "        r.num_children * ts.total_fare * (1 - ?) + " +
                                 "        r.num_seniors * ts.total_fare * (1 - ?) + " +
                                 "        r.num_disabled * ts.total_fare * (1 - ?)) AS total_revenue " +
                                 "FROM reservations r " +
                                 "JOIN train_schedules ts ON r.schedule_id = ts.id " +
                                 "WHERE DATE_FORMAT(r.reservation_date, '%Y-%m') = ? " +
                                 "AND r.status = 'active'";

                    ps = conn.prepareStatement(sql);

                    // Set discount values and the month in the query
                    ps.setFloat(1, childDiscount);
                    ps.setFloat(2, seniorDiscount);
                    ps.setFloat(3, disabledDiscount);
                    ps.setString(4, month);

                    rs = ps.executeQuery();

                    // Generate the report
                    out.println("<h2>Sales Report for " + month + "</h2>");
                    out.println("<table border='1'>");
                    out.println("<tr><th>Total Tickets</th><th>Adults</th><th>Children</th><th>Seniors</th><th>Disabled</th><th>Total Revenue</th></tr>");

                    if (rs.next()) {
                        int totalTickets = rs.getInt("total_tickets");
                        int totalAdults = rs.getInt("total_adults");
                        int totalChildren = rs.getInt("total_children");
                        int totalSeniors = rs.getInt("total_seniors");
                        int totalDisabled = rs.getInt("total_disabled");
                        float totalRevenue = rs.getFloat("total_revenue");

                        out.println("<tr>");
                        out.println("<td>" + totalTickets + "</td>");
                        out.println("<td>" + totalAdults + "</td>");
                        out.println("<td>" + totalChildren + "</td>");
                        out.println("<td>" + totalSeniors + "</td>");
                        out.println("<td>" + totalDisabled + "</td>");
                        out.println("<td>$" + String.format("%.2f", totalRevenue) + "</td>");
                        out.println("</tr>");
                    } else {
                        out.println("<tr><td colspan='6'>No data available for the selected month.</td></tr>");
                    }

                    out.println("</table>");

                } catch (Exception e) {
                    out.println("<p class='error'>Error generating sales report: " + e.getMessage() + "</p>");
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (discountRs != null) discountRs.close();
                        if (ps != null) ps.close();
                        if (conn != null) conn.close();
                    } catch (Exception e) {
                        out.println("<p class='error'>Error closing resources: " + e.getMessage() + "</p>");
                    }
                }
            }
        %>

        <a href="adminDashboard.jsp">
            <button class="action-button">Go to Admin Dashboard</button>
        </a>
    </div>
</body>
</html>
