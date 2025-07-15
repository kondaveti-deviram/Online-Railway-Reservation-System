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
    String dbURL = "jdbc:mysql://localhost:3306/user_db";
    String dbUser = "root";
    String dbPassword = "Munna@1999"; // Replace with your database password

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        String sql = "SELECT username FROM users WHERE id = ? AND role = 'rep'";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, repId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            repUsername = rs.getString("username");
        }

        rs.close();
        ps.close();
        conn.close();
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error fetching rep: " + e.getMessage() + "</p>");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Customer Representative</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <h1>Railway Booking Platform</h1>
    </header>
    <div class="container">
        <h1>Edit Customer Representative</h1>
        <form method="post" action="updateRepServlet">
            <input type="hidden" name="repId" value="<%= repId %>">
            <label for="repUsername">Username:</label>
            <input type="text" name="repUsername" value="<%= repUsername %>" required>

            <label for="repPassword">Password:</label>
            <input type="password" name="repPassword" required>

            <button type="submit">Update Representative</button>
        </form>
    </div>
</body>
</html>
