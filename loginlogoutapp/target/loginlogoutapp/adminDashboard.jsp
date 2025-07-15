<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page session="true" %>
<%
    // Session handling
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    // Redirect if not logged in or not an admin
    if (username == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return; // Stop further processing
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        /* Styling for larger buttons and centered alignment */
        .action-buttons {
            display: flex;
            justify-content: center; /* Center the buttons horizontally */
            align-items: center; /* Center the buttons vertically */
            gap: 10px;
        }

        .edit-button,
        .delete-button {
            padding: 10px 20px; /* Larger padding for bigger buttons */
            font-size: 14px; /* Larger font size for better visibility */
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .edit-button {
            background-color: #00509e;
            color: white;
        }

        .delete-button {
            background-color: #c70039; /* Red */
            color: white;
        }

        .edit-button:hover {
            background-color: #00509e;
        }

        .delete-button:hover {
            background-color: #c70039;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 15px;
            text-align: center; /* Center align all table content */
        }

        th {
            background-color: #f2f2f2;
        }

        td {
            vertical-align: middle; /* Vertically center content */
        }
    </style>
</head>
<body>
    <header>
        <h1>Railway Booking Platform</h1>
    </header>
    <div class="container">
        <h1>Welcome, Admin!</h1>
        <div class="dashboard-buttons">
            <!-- Button to Create New Customer Representative -->
            <a href="createRep.jsp">
                <button class="action-button">Create New Representative</button>
            </a>

            <!-- Button to Generate Sales Report -->
            <a href="generateSalesReport.jsp">
                <button class="action-button">Generate Sales Report</button>
            </a>

            <!-- Button to View Reservations by Filters -->
            <a href="viewReservationsByFilters.jsp">
                <button class="action-button">View Reservations by Filters</button>
            </a>

            <!-- Button to View Revenue -->
            <a href="viewRevenue.jsp">
                <button class="action-button">View Revenue</button>
            </a>

            <a href="bestCustomer.jsp">
                <button class="action-button">Best Customer</button>
            </a>
        
            <a href="topActiveTransitLines.jsp">
                <button class="action-button">Top 5 Active Transit Lines</button>
            </a>
        </div>

        <!-- List of Existing Customer Representatives -->
        <h2>Customer Representatives</h2>

        <%
            // Database credentials
            String dbURL = "jdbc:mysql://localhost:3306/Railway_DB";
            String dbUser = "root";
            String dbPassword = "Munna@1999";

            try {
                // Load JDBC driver and establish a connection
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                // Query to fetch all customer representatives
                String sql = "SELECT id, username FROM employees WHERE role = 'rep'";
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery();

                // Generate table to display representatives
                out.println("<table border='1'><tr><th>Rep Username</th><th>Actions</th></tr>");
                while (rs.next()) {
                    String repUsername = rs.getString("username");
                    int repId = rs.getInt("id");

                    out.println("<tr>");
                    out.println("<td>" + repUsername + "</td>");
                    out.println("<td class='action-buttons'>");
                    out.println("<form action='updateRep.jsp' method='get' style='display:inline;'>");
                    out.println("<input type='hidden' name='repId' value='" + repId + "'>");
                    out.println("<button type='submit' class='edit-button'>Edit</button>");
                    out.println("</form>");

                    out.println("<form action='deleteRep.jsp' method='get' style='display:inline;'>");
                    out.println("<input type='hidden' name='repId' value='" + repId + "'>");
                    out.println("<button type='submit' class='delete-button'>Delete</button>");
                    out.println("</form>");
                    out.println("</td>");
                    out.println("</tr>");
                }
                out.println("</table>");

                // Close resources
                rs.close();
                ps.close();
                conn.close();
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error fetching reps: " + e.getMessage() + "</p>");
            }
        %>

        <a href="logout.jsp">
            <button class="logout-button">Logout</button>
        </a>
    </div>
</body>
</html>
