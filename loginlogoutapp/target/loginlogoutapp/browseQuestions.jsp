<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Browse Questions</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div class="container">
        <h1>Browse Questions</h1>
        <form method="get">
            <label for="keyword">Search by Keyword:</label>
            <input type="text" id="keyword" name="keyword" placeholder="Enter keyword">
            <button type="submit">Search</button>
        </form>

        <%
            String keyword = request.getParameter("keyword");
            String dbURL = "jdbc:mysql://localhost:3306/user_db";
            String dbUser = "root";
            String dbPassword = "Munna@1999"; // Replace with your database password

            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                String sql = "SELECT q.id, u.username, q.question_text, q.reply_text, q.created_at " +
                             "FROM questions q JOIN users u ON q.customer_id = u.id";

                if (keyword != null && !keyword.isEmpty()) {
                    sql += " WHERE q.question_text LIKE ?";
                }

                ps = conn.prepareStatement(sql);
                if (keyword != null && !keyword.isEmpty()) {
                    ps.setString(1, "%" + keyword + "%");
                }

                rs = ps.executeQuery();

                out.println("<table border='1'><tr><th>Customer</th><th>Question</th><th>Reply</th><th>Date</th></tr>");
                while (rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getString("username") + "</td>");
                    out.println("<td>" + rs.getString("question_text") + "</td>");
                    out.println("<td>" + (rs.getString("reply_text") != null ? rs.getString("reply_text") : "Pending") + "</td>");
                    out.println("<td>" + rs.getTimestamp("created_at") + "</td>");
                    out.println("</tr>");
                }
                out.println("</table>");
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
    </div>
</body>
</html>
