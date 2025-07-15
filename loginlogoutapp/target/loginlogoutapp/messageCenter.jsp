<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || !"rep".equals(role)) {
        response.sendRedirect("login.jsp");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Message Center</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <h1>Railway Booking Platform</h1>
    </header>
    <div class="container">
        <h1>Message Center</h1>

        <div class="dashboard-buttons">
        <!-- Frequently Asked Questions Button -->
        <form action="browseQuestionsAndReplies.jsp" method="get">
            <button type="submit" class="button">Frequently Asked Questions</button>
        </form>

        <form action="customerQuestions.jsp" method="get">
            <button type="submit" class="button">Customer Questions</button>
        </form>
        </div>

        <!-- Return to Dashboard -->
        <a href="welcome.jsp">
            <button class="action-button">Go to Dashboard</button>
        </a>
    </div>
</body>
</html>
