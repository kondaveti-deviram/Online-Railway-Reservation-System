<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Frequently Asked Questions</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <h1>Railway Booking Platform</h1>
    </header>
    <div class="container">
        <h1>Questions and Replies</h1>

        <!-- Search Bar -->
        <form method="get" action="browseQuestionsAndReplies.jsp">
            <label for="keyword">Search Questions:</label>
            <input type="text" id="keyword" name="keyword" placeholder="Enter keyword..." required>
            <button type="submit">Search</button>
        </form>

        <%
            String keyword = request.getParameter("keyword"); // Get keyword from search
            String dbURL = "jdbc:mysql://localhost:3306/Railway_DB";
            String dbUser = "root";
            String dbPassword = "Munna@1999";
            Connection connection = null;
            PreparedStatement preparedStatement = null;
            ResultSet resultSet = null;

            try {
                // Load the MySQL JDBC Driver
                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                String query;
                if (keyword != null && !keyword.isEmpty()) {
                    // Search query if keyword is provided
                    query = "SELECT question, answer FROM questions_answers WHERE question LIKE ?";
                    preparedStatement = connection.prepareStatement(query);
                    preparedStatement.setString(1, "%" + keyword + "%"); // Search for keyword in questions
                } else {
                    // Default query to load all questions and answers
                    query = "SELECT question, answer FROM questions_answers";
                    preparedStatement = connection.prepareStatement(query);
                }

                resultSet = preparedStatement.executeQuery();

                // Display questions and answers
                if (!resultSet.isBeforeFirst()) {
                    out.println("<p>No questions found.</p>");
                } else {
                    out.println("<table border='1'>");
                    out.println("<thead>");
                    out.println("<tr>");
                    out.println("<th>Question</th>");
                    out.println("<th>Answer</th>");
                    out.println("</tr>");
                    out.println("</thead>");
                    out.println("<tbody>");

                    while (resultSet.next()) {
                        String question = resultSet.getString("question");
                        String answer = resultSet.getString("answer");

                        out.println("<tr>");
                        out.println("<td>" + question + "</td>");
                        out.println("<td>" + answer + "</td>");
                        out.println("</tr>");
                    }

                    out.println("</tbody>");
                    out.println("</table>");
                }
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
                e.printStackTrace();
            } finally {
                // Close database resources
                if (resultSet != null) try { resultSet.close(); } catch (Exception e) {}
                if (preparedStatement != null) try { preparedStatement.close(); } catch (Exception e) {}
                if (connection != null) try { connection.close(); } catch (Exception e) {}
            }
        %>
        <a href="welcome.jsp">
            <button class="action-button">Go to Dashboard</button>
        </a>
    </div>
</body>
</html>
