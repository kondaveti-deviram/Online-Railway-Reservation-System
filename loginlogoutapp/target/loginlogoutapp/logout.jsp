<%@ page session="true" %>
<%
    // Invalidate the session to destroy user data
    session.invalidate();

    // Redirect to the login page
    response.sendRedirect("login.jsp");
%>
