<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <h1>Railway Booking Platform</h1>
    </header>
    <div class="container">
        <h1>Login</h1>
        <form method="post">
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Login</button>
        </form>

        <%
            String loginErrorMessage = null;

            if (request.getMethod().equalsIgnoreCase("POST")) {
                String username = request.getParameter("username");
                String password = request.getParameter("password");

                String dbURL = "jdbc:mysql://localhost:3306/Railway_DB";
                String dbUser = "root";
                String dbPassword = "Munna@1999";

                boolean isLoggedIn = false;
                String role = "";

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                    // Check the customers table first
                    String customerQuery = "SELECT username, password FROM customers WHERE username = ?";
                    PreparedStatement ps = conn.prepareStatement(customerQuery);
                    ps.setString(1, username);
                    ResultSet rs = ps.executeQuery();

                    if (rs.next()) {
                        String storedPassword = rs.getString("password");
                        if (storedPassword.equals(password)) {
                            session.setAttribute("username", username);
                            session.setAttribute("role", "customer");
                            response.sendRedirect("welcome.jsp");
                            isLoggedIn = true;
                        }
                    }

                    rs.close();
                    ps.close();

                    // If not found in customers, check employees table
                    if (!isLoggedIn) {
                        String employeeQuery = "SELECT username, password, role FROM employees WHERE username = ?";
                        ps = conn.prepareStatement(employeeQuery);
                        ps.setString(1, username);
                        rs = ps.executeQuery();

                        if (rs.next()) {
                            String storedPassword = rs.getString("password");
                            String employeeRole = rs.getString("role");

                            if (storedPassword.equals(password)) {
                                session.setAttribute("username", username);
                                session.setAttribute("role", employeeRole);

                                if ("admin".equals(employeeRole)) {
                                    response.sendRedirect("adminDashboard.jsp");
                                } else if ("rep".equals(employeeRole)) {
                                    response.sendRedirect("repDashboard.jsp");
                                }

                                isLoggedIn = true;
                            }
                        }

                        rs.close();
                        ps.close();
                    }

                    if (!isLoggedIn) {
                        loginErrorMessage = "Invalid username or password.";
                    }

                    conn.close();
                } catch (Exception e) {
                    out.println("<p style='color:red;'>Database connection error: " + e.getMessage() + "</p>");
                }
            }
        %>

        <%-- Display error message if any --%>
        <p style="color:red;"><%= loginErrorMessage != null ? loginErrorMessage : "" %></p>

        <p>Don't have an account?</p>
        <a href="register.jsp" class="register-button">Register</a>
    </div>
</body>
</html>
