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
    <title>View Reservations</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <h1>Railway Booking Platform</h1>
    </header>
    <div class="container">
        <h1>View Reservations</h1>
        <form method="get">
            <label for="filterType">Filter By:</label>
            <select id="filterType" name="filterType" required onchange="this.form.submit()">
                <option value="">Select Filter</option>
                <option value="transit_line" <% if ("transit_line".equals(request.getParameter("filterType"))) { %> selected <% } %>>Transit Line</option>
                <option value="customer_name" <% if ("customer_name".equals(request.getParameter("filterType"))) { %> selected <% } %>>Customer Name</option>
            </select>

            <% 
                String dbURL = "jdbc:mysql://localhost:3306/Railway_DB";
                String dbUser = "root";
                String dbPassword = "Munna@1999"; // Replace with your database password
                String filterType = request.getParameter("filterType");

                // Display dropdown based on the filter type selected
                if ("transit_line".equals(filterType)) {
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
            <% } else if ("customer_name".equals(filterType)) { %>
                <label for="customerName">Select Customer Name:</label>
                <select id="customerName" name="customerName" required>
                    <option value="">Select Customer Name</option>
                    <%
                        try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                             PreparedStatement ps = conn.prepareStatement("SELECT DISTINCT CONCAT(first_name, ' ', last_name) AS full_name FROM customers");
                             ResultSet rs = ps.executeQuery()) {
                            while (rs.next()) {
                                String customerName = rs.getString("full_name");
                    %>
                        <option value="<%= customerName %>" <% if (customerName.equals(request.getParameter("customerName"))) { %> selected <% } %>><%= customerName %></option>
                    <% 
                            }
                        } catch (Exception e) {
                            out.println("<p class='error'>Error loading customer names: " + e.getMessage() + "</p>");
                        }
                    %>
                </select>
            <% } %>

            <button type="submit">Filter</button>
        </form>

        <%
            // Only proceed if filterType is selected and a filter value is entered
            String filterValue = null;
            String sql = "";
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            
            if (filterType != null && !filterType.isEmpty()) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                    if ("transit_line".equals(filterType)) {
                        filterValue = request.getParameter("transitLine");
                        if (filterValue != null && !filterValue.isEmpty()) {
                            sql = "SELECT r.reservation_number, ts.transit_line_name, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, r.total_fare, r.reservation_date " +
                                  "FROM reservations r " +
                                  "JOIN train_schedules ts ON r.schedule_id = ts.id " +
                                  "JOIN customers c ON r.customer_id = c.id " +
                                  "WHERE ts.transit_line_name LIKE ? AND r.status = 'active'";
                            ps = conn.prepareStatement(sql);
                            ps.setString(1, "%" + filterValue + "%");
                        }
                    } else if ("customer_name".equals(filterType)) {
                        filterValue = request.getParameter("customerName");
                        if (filterValue != null && !filterValue.isEmpty()) {
                            sql = "SELECT r.reservation_number, ts.transit_line_name, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, r.total_fare, r.reservation_date " +
                                  "FROM reservations r " +
                                  "JOIN train_schedules ts ON r.schedule_id = ts.id " +
                                  "JOIN customers c ON r.customer_id = c.id " +
                                  "WHERE CONCAT(c.first_name, ' ', c.last_name) LIKE ? AND r.status = 'active'";
                            ps = conn.prepareStatement(sql);
                            ps.setString(1, "%" + filterValue + "%");
                        }
                    }

                    // Check if SQL query is valid and execute it
                    if (ps != null) {
                        rs = ps.executeQuery();

                        out.println("<h2>Reservations</h2>");
                        out.println("<table border='1'><tr><th>Reservation Number</th><th>Transit Line</th><th>Customer Name</th><th>Total Fare</th><th>Reservation Date</th></tr>");
                        boolean dataFound = false;
                        while (rs.next()) {
                            dataFound = true;
                            out.println("<tr><td>" + rs.getInt("reservation_number") + "</td>");
                            out.println("<td>" + rs.getString("transit_line_name") + "</td>");
                            out.println("<td>" + rs.getString("customer_name") + "</td>");
                            out.println("<td>$" + rs.getDouble("total_fare") + "</td>");
                            out.println("<td>" + rs.getDate("reservation_date") + "</td></tr>");
                        }
                        out.println("</table>");
                        
                        if (!dataFound) {
                            out.println("<p class='error'>No matching reservations found.</p>");
                        }
                    }
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
        <a href="adminDashboard.jsp">
            <button class="action-button">Go to Admin Dashboard</button>
        </a>
    </div>
</body>
</html>
