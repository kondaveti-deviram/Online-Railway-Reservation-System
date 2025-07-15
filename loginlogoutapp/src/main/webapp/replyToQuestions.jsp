<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reply to Questions</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <h1>Railway Booking Platform</h1>
        <p>Answer Customer Questions</p>
    </header>
    <div class="container">
        <h1>Reply to Questions</h1>

        <%
            String username = (String) session.getAttribute("username");
            String role = (String) session.getAttribute("role");

            // Redirect non-representative users
            if (username == null || !"rep".equals(role)) {
                response.sendRedirect("login.jsp");
                return;
            }

            String dbURL = "jdbc:mysql://localhost:3306/user_db";
            String dbUser = "root";
            String dbPassword = "Munna@1999"; // Replace with your database credentials

            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                // Retrieve unanswered questions
                String fetchQuestionsSQL = "SELECT id, question_text FROM questions WHERE answer_text IS NULL";
                ps = conn.prepareStatement(fetchQuestionsSQL);
                rs = ps.executeQuery();
        %>

        <!-- Display Unanswered Questions -->
        <form method="post">
            <label for="questionId">Select a Question to Answer:</label>
            <select name="questionId" id="questionId" required>
                <option value="" disabled selected>Select a question</option>
                <%
                    while (rs.next()) {
                        int questionId = rs.getInt("id");
                        String questionText = rs.getString("question_text");
                        out.println("<option value='" + questionId + "'>" + questionText + "</option>");
                    }
                %>
            </select>

            <label for="answerText">Your Answer:</label>
            <textarea id="answerText" name="answerText" rows="4" required></textarea>

            <button type="submit">Submit Answer</button>
        </form>

        <%
                rs.close();
                ps.close();

                // Handle form submission
                if ("POST".equalsIgnoreCase(request.getMethod())) {
                    int questionId = Integer.parseInt(request.getParameter("questionId"));
                    String answerText = request.getParameter("answerText");

                    String updateAnswerSQL = "UPDATE questions SET answer_text = ? WHERE id = ?";
                    ps = conn.prepareStatement(updateAnswerSQL);
                    ps.setString(1, answerText);
                    ps.setInt(2, questionId);
                    ps.executeUpdate();

                    out.println("<p class='success'>Answer submitted successfully!</p>");
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
        %>

        <h3>Back to Dashboard</h3>
        <a href="repDashboard.jsp">
            <button class="action-button">Go to Dashboard</button>
        </a>
    </div>
</body>
</html>
