<%@ page session="true" import="java.sql.*" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || !"customer".equals(role)) {
        response.sendRedirect("login.jsp");
    }
 
    // Database connection variables
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // Database connection details
    String jdbcURL = "jdbc:mysql://localhost:3306/Railway_DB";
    String dbUsername = "root";
    String dbPassword = "Munna@1999";

    // Handle new question submission
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String newQuestion = request.getParameter("question");

        if (newQuestion != null && !newQuestion.trim().isEmpty()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(jdbcURL, dbUsername, dbPassword);

                // Insert the new question into the database
                String insertQuery = "INSERT INTO customer_questions (question, asked_by) VALUES (?, ?)";
                ps = conn.prepareStatement(insertQuery);
                ps.setString(1, newQuestion);
                ps.setString(2, username); // Use the username as asked_by
                ps.executeUpdate();
            } catch (SQLException | ClassNotFoundException e) {
                out.println("<p>Error: Unable to save your question. Please try again later.</p>");
                e.printStackTrace();
            } finally {
                try {
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    // Fetch questions and replies
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcURL, dbUsername, dbPassword);

        // Fetch user's questions and corresponding replies
        String fetchQuery = "SELECT question, answer, is_answered FROM customer_questions WHERE asked_by = ?";
        ps = conn.prepareStatement(fetchQuery);
        ps.setString(1, username);
        rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Contact Customer Representative</title>
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
        <h1>Contact Customer Representative</h1>

        <!-- Form to Ask a Question -->
        <form method="post">
            <textarea name="question" rows="5" cols="50" placeholder="Type your question here..." required></textarea><br><br>
            <button type="submit" class="action-button">Ask Question</button>
        </form>

        <!-- Display Questions and Replies in a Table -->
        <h2>Your Questions and Replies</h2>
        <table>
            <thead>
                <tr>
                    <th>Question</th>
                    <th>Reply</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    while (rs.next()) {
                        String question = rs.getString("question");
                        String answer = rs.getString("answer");
                        boolean isAnswered = rs.getBoolean("is_answered");
                %>
                <tr>
                    <td><%= question %></td>
                    <td><%= (answer != null && !answer.isEmpty()) ? answer : "No reply yet" %></td>
                    <td><%= isAnswered ? "Answered" : "Pending" %></td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>

        <!-- Return to Dashboard -->
        <a href="welcome.jsp">
            <button class="action-button">Go to Dashboard</button>
        </a>
    </div>
</body>
</html>
<%
    } catch (SQLException | ClassNotFoundException e) {
        out.println("<p>Error: Unable to fetch your questions. Please try again later.</p>");
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
