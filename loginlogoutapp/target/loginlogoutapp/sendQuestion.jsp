<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Send a Question</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div class="container">
        <h1>Send a Question</h1>
        <form method="post">
            <label for="questionText">Your Question:</label>
            <textarea id="questionText" name="questionText" rows="4" required></textarea>
            <button type="submit">Submit</button>
        </form>

        <%
            String username = (String) session.getAttribute("username");
            String role = (String) session.getAttribute("role");
            if (username == null || !"customer".equals(role)) {
                response.sendRedirect("login.jsp");
            }

            String questionText = request.getParameter("questionText");
            if (questionText != null) {
                String dbURL = "jdbc:mysql://localhost:3306/user_db";
                String dbUser = "root";
                String dbPassword = "Munna@1999"; // Replace with your database password

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                    // Get the customer ID
                    String getCustomerIdSQL = "SELECT id FROM users WHERE username = ?";
                    PreparedStatement ps = conn.prepareStatement(getCustomerIdSQL);
                    ps.setString(1, username);
                    ResultSet rs = ps.executeQuery();

                    int customerId = 0;
                    if (rs.next()) {
                        customerId = rs.getInt("id");
                    }
                    rs.close();
                    ps.close();

                    // Insert the question
                    String insertQuestionSQL = "INSERT INTO questions (customer_id, question_text) VALUES (?, ?)";
                    ps = conn.prepareStatement(insertQuestionSQL);
                    ps.setInt(1, customerId);
                    ps.setString(2, questionText);
                    ps.executeUpdate();

                    out.println("<p class='success'>Your question has been submitted!</p>");
                    ps.close();
                    conn.close();
                } catch (Exception e) {
                    out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
                }
            }
        %>
    </div>
</body>
</html>
