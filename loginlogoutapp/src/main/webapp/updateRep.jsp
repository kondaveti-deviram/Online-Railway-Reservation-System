<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
    }

    int repId = Integer.parseInt(request.getParameter("repId"));
    String repUsername = "";
    String dbURL = "jdbc:mysql://localhost:3306/Railway_DB";
    String dbUser = "root";
    String dbPassword = "Munna@1999"; // Replace with your database password

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // Fetch representative's current data
        String sql = "SELECT username FROM employees WHERE id = ? AND role = 'rep'";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, repId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            repUsername = rs.getString("username");
        } else {
            out.println("<p class='error'>Error: Representative not found or invalid role.</p>");
        }

        rs.close();
        ps.close();
        conn.close();
    } catch (Exception e) {
        out.println("<p class='error'>Error fetching representative data: " + e.getMessage() + "</p>");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Update Customer Representative</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <h1>Railway Booking Platform</h1>
    </header>
    <div class="container">
        <h1>Update Customer Representative</h1>
        <form method="post">
            <input type="hidden" name="repId" value="<%= repId %>">
            <label for="repUsername">Username:</label>
            <input type="text" name="repUsername" value="<%= repUsername %>" required>

            <label for="repPassword">Password:</label>
            <input type="password" name="repPassword" required>

            <button type="submit">Update Representative</button>
        </form>

        <%
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String newUsername = request.getParameter("repUsername");
                String newPassword = request.getParameter("repPassword");

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                    // Update representative data in the employees table
                    String updateSql = "UPDATE employees SET username = ?, password = ? WHERE id = ? AND role = 'rep'";
                    PreparedStatement updatePs = conn.prepareStatement(updateSql);
                    updatePs.setString(1, newUsername);
                    updatePs.setString(2, newPassword); // You should hash the password in a real-world scenario
                    updatePs.setInt(3, repId);

                    int rows = updatePs.executeUpdate();
                    if (rows > 0) {
                        out.println("<p class='success'>Customer Representative updated successfully!</p>");
                    } else {
                        out.println("<p class='error'>Failed to update Customer Representative.</p>");
                    }

                    updatePs.close();
                    conn.close();
                } catch (Exception e) {
                    out.println("<p class='error'>Error updating representative: " + e.getMessage() + "</p>");
                }
            }
        %>

        <a href="adminDashboard.jsp">
            <button class="action-button">Go to Admin Dashboard</button>
        </a>
    </div>
</body>
</html>
