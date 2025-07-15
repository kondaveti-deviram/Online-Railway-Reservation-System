<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    int repId = Integer.parseInt(request.getParameter("repId"));
    String dbURL = "jdbc:mysql://localhost:3306/Railway_DB";
    String dbUser = "root";
    String dbPassword = "Munna@1999"; // Replace with your database password

    String message = "";
    String messageClass = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // Delete customer representative
        String sql = "DELETE FROM employees WHERE id = ? AND role = 'rep'";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, repId);

        int rows = ps.executeUpdate();
        if (rows > 0) {
            message = "Customer Representative deleted successfully!";
            messageClass = "success";
        } else {
            message = "Error: Customer Representative not found or not a 'rep' role.";
            messageClass = "error";
        }

        ps.close();
        conn.close();
    } catch (Exception e) {
        message = "Error: " + e.getMessage();
        messageClass = "error";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Delete Representative</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        /* Success and Error Message Styling */
        .success {
            color: green;
            font-weight: bold;
            text-align: center;
            margin-top: 20px;
        }
        .error {
            color: red;
            font-weight: bold;
            text-align: center;
            margin-top: 20px;
        }
        /* Centered Button Styling */
        .action-button {
            display: block;
            margin: 20px auto;
            padding: 10px 20px;
            background-color: #00509e;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-align: center;
            font-size: 14px;
        }
        .action-button:hover {
            background-color: #003f7e;
        }
    </style>
    <script>
        // Redirect back to Admin Dashboard after 3 seconds
        setTimeout(function() {
            window.location.href = "adminDashboard.jsp";
        }, 3000);
    </script>
</head>
<body>
    <header>
        <h1>Railway Booking Platform</h1>
    </header>
    <div class="container">
        <p class="<%= messageClass %>"><%= message %></p>
        <a href="adminDashboard.jsp">
            <button class="action-button">Return to Admin Dashboard</button>
        </a>
    </div>
</body>
</html>
