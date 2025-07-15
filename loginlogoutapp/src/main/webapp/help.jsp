<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page session="true" %>
<%
String username = (String) session.getAttribute("username");
String role = (String) session.getAttribute("role");
if (username == null || !"customer".equals(role)) {
    response.sendRedirect("login.jsp");
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Help Center</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <h1>Railway Booking Platform</h1>
        <h2>Help Center</h1>
    </header>
    <div class="container">
        <h2>How can we assist you?</h2>
        <div class="dashboard-buttons">
            <!-- Browse Questions and Answers -->
            <a href="browseQuestionsAndReplies.jsp">
                <button class="action-button">FAQS</button>
            </a>

            <!-- Contact Customer Representative -->
            <a href="contactRepresentative.jsp">
                <button class="action-button">Contact Customer Representative</button>
            </a>
        </div>
        <br>
        <br>
        <a href="welcome.jsp">
            <button class="action-button">Go to Dashboard</button>
        </a>
    </div>
</body>
</html>
