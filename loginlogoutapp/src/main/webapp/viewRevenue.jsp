<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page session="true" %>
<%
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
    <title>View Revenue</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <h1>Railway Booking Platform</h1>
    </header>
    <div class="container">
        <h1>Revenue Report</h1>
        <form method="get">
            <label for="groupBy">Group By:</label>
            <select id="groupBy" name="groupBy" required onchange="this.form.submit()">
                <option value="">Select Group By</option>
                <option value="transit_line" <% if ("transit_line".equals(request.getParameter("groupBy"))) { %> selected <% } %>>Transit Line</option>
                <option value="customer_name" <% if ("customer_name".equals(request.getParameter("groupBy"))) { %> selected <% } %>>Customer Name</option>
            </select>

            <% 
                String groupBy = request.getParameter("groupBy");
                String dbURL = "jdbc:mysql://localhost:3306/Railway_DB";
                String dbUser = "root";
                String dbPassword = "Munna@1999"; // Replace with your database password

                if ("transit_line".equals(groupBy)) {
            %>
                <label for="transitLine">Select Transit Line:</label>
                <select id="transitLine" name="transitLine" required>
                    <option value="">Select Transit Line</option>
                    <%
                        try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                             PreparedStatement ps = conn.prepareStatement("SELECT DISTINCT transit_line_name FROM train_schedules");
                             ResultSet rs = ps.executeQuery()) {
                            while (rs.next()) {
                                String transitLine = rs.getString("transit_line_name");
                    %>
                        <option value="<%= transitLine %>" <% if (transitLine.equals(request.getParameter("transitLine"))) { %> selected <% } %>><%= transitLine %></option>
                    <% 
                            }
                        } catch (Exception e) {
                            out.println("<p class='error'>Error loading transit lines: " + e.getMessage() + "</p>");
                        }
                    %>
                </select>
                <button type="submit">Generate Report</button>
            <% } else if ("customer_name".equals(groupBy)) { %>
                <label for="customerName">Select Customer Name:</label>
                <select id="customerName" name="customerName" required>
                    <option value="">Select Customer Name</option>
                    <%
                        try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                             PreparedStatement ps = conn.prepareStatement("SELECT DISTINCT username FROM customers");
                             ResultSet rs = ps.executeQuery()) {
                            while (rs.next()) {
                                String customerName = rs.getString("username");
                    %>
                        <option value="<%= customerName %>" <% if (customerName.equals(request.getParameter("customerName"))) { %> selected <% } %>><%= customerName %></option>
                    <% 
                            }
                        } catch (Exception e) {
                            out.println("<p class='error'>Error loading customer names: " + e.getMessage() + "</p>");
                        }
                    %>
                </select>
                <button type="submit">Generate Report</button>
            <% } %>
        </form>

        <% 
            if (groupBy != null) {
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                    String sql = "";
                    if ("transit_line".equals(groupBy) && request.getParameter("transitLine") != null) {
                        sql = "SELECT ts.transit_line_name, SUM(r.total_fare) AS total_revenue " +
                              "FROM reservations r " +
                              "JOIN train_schedules ts ON r.schedule_id = ts.id " +
                              "WHERE ts.transit_line_name = ? AND r.status = 'active' " +
                              "GROUP BY ts.transit_line_name";
                        ps = conn.prepareStatement(sql);
                        ps.setString(1, request.getParameter("transitLine"));
                    } else if ("customer_name".equals(groupBy) && request.getParameter("customerName") != null) {
                        sql = "SELECT c.username, SUM(r.total_fare) AS total_revenue " +
                              "FROM reservations r " +
                              "JOIN customers c ON r.customer_id = c.id " +
                              "WHERE c.username = ? AND r.status = 'active' " +
                              "GROUP BY c.username";
                        ps = conn.prepareStatement(sql);
                        ps.setString(1, request.getParameter("customerName"));
                    }

                    if (ps != null) {
                        rs = ps.executeQuery();

                        out.println("<h2>Revenue Report</h2>");
                        out.println("<table border='1'>");
                        if ("transit_line".equals(groupBy)) {
                            out.println("<tr><th>Transit Line</th><th>Total Revenue</th></tr>");
                        } else {
                            out.println("<tr><th>Customer Name</th><th>Total Revenue</th></tr>");
                        }

                        while (rs.next()) {
                            out.println("<tr>");
                            if ("transit_line".equals(groupBy)) {
                                out.println("<td>" + rs.getString("transit_line_name") + "</td>");
                            } else {
                                out.println("<td>" + rs.getString("username") + "</td>");
                            }
                            out.println("<td>$" + rs.getDouble("total_revenue") + "</td>");
                            out.println("</tr>");
                        }
                        out.println("</table>");
                    }
                } catch (Exception e) {
                    out.println("<p class='error'>Error generating report: " + e.getMessage() + "</p>");
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
        <a href="adminDashboard.jsp">
            <button class="action-button">Go to Admin Dashboard</button>
        </a>
    </div>
</body>
</html>
