<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement" %>
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
    <title>Create Customer Representative</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <h1>Railway Booking Platform</h1>
    </header>
    <div class="container">
        <h1>Create Customer Representative</h1>

        <form method="post">
            <label for="ssn">SSN:</label>
            <input type="text" name="ssn" required maxlength="11" placeholder="###-##-####">

            <label for="firstName">First Name:</label>
            <input type="text" name="firstName" required maxlength="100">

            <label for="lastName">Last Name:</label>
            <input type="text" name="lastName" required maxlength="100">

            <label for="repUsername">Username:</label>
            <input type="text" name="repUsername" required maxlength="50">

            <label for="repPassword">Password:</label>
            <input type="password" name="repPassword" required>

            <button type="submit">Create Customer Representative</button>
        </form>

        <%
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String ssn = request.getParameter("ssn");
                String firstName = request.getParameter("firstName");
                String lastName = request.getParameter("lastName");
                String repUsername = request.getParameter("repUsername");
                String repPassword = request.getParameter("repPassword");

                String dbURL = "jdbc:mysql://localhost:3306/Railway_DB";
                String dbUser = "root";
                String dbPassword = "Munna@1999"; // Replace with your database password

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                    // Insert a new Customer Representative into the employees table
                    String sql = "INSERT INTO employees (ssn, first_name, last_name, username, password, role) VALUES (?, ?, ?, ?, ?, 'rep')";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ps.setString(1, ssn);
                    ps.setString(2, firstName);
                    ps.setString(3, lastName);
                    ps.setString(4, repUsername);
                    ps.setString(5, repPassword); // Hash the password in a real-world scenario

                    int rows = ps.executeUpdate();
                    if (rows > 0) {
                        out.println("<p class='success'>Customer Representative created successfully!</p>");
                    }

                    ps.close();
                    conn.close();
                } catch (Exception e) {
                    out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
                }
            }
        %>

        <a href="adminDashboard.jsp">
            <button class="action-button">Go to Admin Dashboard</button>
        </a>
    </div>
</body>
</html>
