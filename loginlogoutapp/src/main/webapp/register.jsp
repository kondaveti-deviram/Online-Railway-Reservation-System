<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement" %>
<%@ page session="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <h1>Railway Booking Platform</h1>
    </header>
    <div class="container">
        <h1>Register</h1>
        <form method="post">
            <input type="text" name="first_name" placeholder="First Name" required>
            <input type="text" name="last_name" placeholder="Last Name" required>
            <input type="email" name="email" placeholder="E-mail Address" required>
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Register</button>
        </form>

        <%
            if (request.getMethod().equalsIgnoreCase("POST")) {
                String firstName = request.getParameter("first_name");
                String lastName = request.getParameter("last_name");
                String email = request.getParameter("email");
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String role = "customer"; // Automatically set to "customer"

                String dbURL = "jdbc:mysql://localhost:3306/Railway_DB"; // Changed to Railway_DB
                String dbUser = "root";    // Replace with your database username
                String dbPassword = "Munna@1999"; // Replace with your database password

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                    // Update SQL to insert into 'customers' table
                    String sql = "INSERT INTO customers (first_name, last_name, email, username, password) VALUES (?, ?, ?, ?, ?)";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ps.setString(1, firstName);
                    ps.setString(2, lastName);
                    ps.setString(3, email);
                    ps.setString(4, username);
                    ps.setString(5, password); // Storing plain text password (consider hashing in production)

                    int rows = ps.executeUpdate();
                    
                    if (rows > 0) {
                        // Success message
                        out.println("<p style='color:green;'>Registration successful! You will be redirected to the login page shortly...</p>");
                        
                        // Redirect to login after 3 seconds
                        out.println("<script>setTimeout(function(){window.location.href = 'login.jsp';}, 3000);</script>");
                    }

                    ps.close();
                    conn.close();
                } catch (Exception e) {
                    out.println("<p style='color:red;'>Database error: " + e.getMessage() + "</p>");
                }
            }
        %>
    </div>
</body>
</html>
