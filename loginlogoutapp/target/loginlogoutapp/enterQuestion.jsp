<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Enter Your Question</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div class="container">
        <h1>Enter Your Question</h1>
        
        <%
            // Ensure user is logged in and is a customer
            String username = (String) session.getAttribute("username");
            String role = (String) session.getAttribute("role");
            if (username == null || !"customer".equals(role)) {
                response.sendRedirect("login.jsp");
                return; // Prevent further processing
            }

            // Handle form submission
            String questionText = request.getParameter("questionText");
            if ("POST".equalsIgnoreCase(request.getMethod()) && questionText != null) {
                String dbURL = "jdbc:mysql://localhost:3306/user_db";
                String dbUser = "root";
                String dbPassword = "Munna@1999"; // Replace with your database password

                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    // Connect to the database
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                    // Get the customer ID
                    String getCustomerIdSQL = "SELECT id FROM users WHERE username = ?";
                    ps = conn.prepareStatement(getCustomerIdSQL);
                    ps.setString(1, username);
                    rs = ps.executeQuery();

                    int customerId = 0;
                    if (rs.next()) {
                        customerId = rs.getInt("id");
                    }
                    rs.close();
                    ps.close();

                    // Insert the question into the database
                    String insertQuestionSQL = "INSERT INTO questions (customer_id, question_text) VALUES (?, ?)";
                    ps = conn.prepareStatement(insertQuestionSQL);
                    ps.setInt(1, customerId);
                    ps.setString(2, questionText);
                    ps.executeUpdate();

                    out.println("<p class='success'>Your question has been submitted successfully!</p>");
                } catch (Exception e) {
                    out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
                } finally {
                    // Always close resources
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

        <!-- Form to submit a question -->
        <form method="post">
            <label for="questionText">Enter Your Question:</label>
            <textarea id="questionText" name="questionText" rows="4" required></textarea>
            <button type="submit">Submit</button>
        </form>

        <h3>Back to Dashboard</h3>
        <a href="welcome.jsp">
            <button class="action-button">Go to Dashboard</button>
        </a>
    </div>
</body>
</html>
