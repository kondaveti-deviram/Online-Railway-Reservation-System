<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    // Ensure only representatives access this page
    if (username == null || !"rep".equals(role)) {
        response.sendRedirect("login.jsp");
    }

    // Handle form submission for replies
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        int questionId = Integer.parseInt(request.getParameter("questionId"));
        String reply = request.getParameter("reply");

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/Railway_DB", "root", "Munna@1999");

            // Update the question with the reply and set it as answered
            String updateQuery = "UPDATE customer_questions SET answer = ?, answered_by = ?, is_answered = TRUE WHERE id = ?";
            ps = conn.prepareStatement(updateQuery);
            ps.setString(1, reply);
            ps.setString(2, username);
            ps.setInt(3, questionId);
            ps.executeUpdate();

        } catch (Exception e) {
            out.println("<p style='color:red;'>Error: Unable to save the reply. Please try again later.</p>");
            e.printStackTrace();
        } finally {
            if (ps != null) try { ps.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Questions</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid black;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <header>
        <h1>Railway Booking Platform</h1>
    </header>
    <div class="container">
        <h1>Customer Questions</h1>
        <h2>All Customer Questions</h2>
        <%
            Connection connection = null;
            PreparedStatement preparedStatement = null;
            ResultSet resultSet = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/Railway_DB", "root", "Munna@1999");

                // Retrieve all questions
                String query = "SELECT id, question, answer, is_answered FROM customer_questions ORDER BY created_at DESC";
                preparedStatement = connection.prepareStatement(query);
                resultSet = preparedStatement.executeQuery();

                out.println("<table>");
                out.println("<thead>");
                out.println("<tr>");
                out.println("<th>ID</th>");
                out.println("<th>Question</th>");
                out.println("<th>Answer</th>");
                out.println("<th>Status</th>");
                out.println("<th>Action</th>");
                out.println("</tr>");
                out.println("</thead>");
                out.println("<tbody>");

                while (resultSet.next()) {
                    int id = resultSet.getInt("id");
                    String question = resultSet.getString("question");
                    String answer = resultSet.getString("answer");
                    boolean isAnswered = resultSet.getBoolean("is_answered");

                    out.println("<tr>");
                    out.println("<td>" + id + "</td>");
                    out.println("<td>" + question + "</td>");
                    out.println("<td>" + (answer != null ? answer : "Not answered yet") + "</td>");
                    out.println("<td>" + (isAnswered ? "Answered" : "Pending") + "</td>");
                    out.println("<td>");
                    if (!isAnswered) {
                        out.println("<form method='post'>");
                        out.println("<input type='hidden' name='questionId' value='" + id + "'>");
                        out.println("<textarea name='reply' required placeholder='Write your reply here...'></textarea>");
                        out.println("<button type='submit'>Submit Reply</button>");
                        out.println("</form>");
                    } else {
                        out.println("Task Completed");
                    }
                    out.println("</td>");
                    out.println("</tr>");
                }

                out.println("</tbody>");
                out.println("</table>");

            } catch (Exception e) {
                out.println("<p style='color:red;'>Error: Unable to fetch questions. Please try again later.</p>");
                e.printStackTrace();
            } finally {
                if (resultSet != null) try { resultSet.close(); } catch (Exception e) {}
                if (preparedStatement != null) try { preparedStatement.close(); } catch (Exception e) {}
                if (connection != null) try { connection.close(); } catch (Exception e) {}
            }
        %>
        <a href="repDashboard.jsp">
            <button class="action-button">Go to Dashboard</button>
        </a>
    </div>
</body>
</html>
