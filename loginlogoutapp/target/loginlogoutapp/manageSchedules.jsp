<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Train Schedules</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }

        table th {
            background-color: #003366; /* Table heading color */
            color: white;
            padding: 10px;
            text-align: center;
        }

        table th, table td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
        }

        .action-buttons form {
            display: inline-block;
        }

        .edit-button {
            background-color: #00509e; /* Green for Edit */
            color: white;
            border: none;
            padding: 5px 10px;
            cursor: pointer;
        }

        .delete-button {
            background-color: #c70039; /* Red for Delete */
            color: white;
            border: none;
            padding: 5px 10px;
            cursor: pointer;
        }

        .edit-button:hover {
            background-color: #45a049;
        }

        .delete-button:hover {
            background-color: #70092f; /* Slightly darker for hover */
        }
    </style>
</head>
<body>
    <header>
        <h1>Railway Booking Platform</h1>
    </header>
    <div class="container">
        <h1>Manage Train Schedules</h1>
        
        <%
            String username = (String) session.getAttribute("username");
            String role = (String) session.getAttribute("role");
            if (username == null || !"rep".equals(role)) {
                response.sendRedirect("login.jsp");
            }
            // Database connection details
            String dbURL = "jdbc:mysql://localhost:3306/Railway_DB"; // Update to the correct database
            String dbUser = "root";
            String dbPassword = "Munna@1999"; // Replace with your database password

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                // Query to retrieve all train schedules
                String sql = "SELECT * FROM train_schedules";
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery();

                out.println("<table><tr><th>Train</th><th>Origin</th><th>Destination</th><th>Departure Time</th><th>Arrival Time</th><th>Fare</th><th>Actions</th></tr>");

                while (rs.next()) {
                    String train = rs.getString("train");
                    String origin = rs.getString("origin");
                    String destination = rs.getString("destination");
                    String departureTime = rs.getString("departure_time");
                    String arrivalTime = rs.getString("arrival_time");
                    double fare = rs.getDouble("total_fare");
                    int scheduleId = rs.getInt("id");

                    out.println("<tr><td>" + train + "</td><td>" + origin + "</td><td>" + destination + "</td><td>" + departureTime + "</td><td>" + arrivalTime + "</td><td>$" + fare + "</td>");
                    out.println("<td class='action-buttons'>" +
                                "<form action='editSchedule.jsp' method='get'><button type='submit' class='edit-button' name='scheduleId' value='" + scheduleId + "'>Edit</button></form>" +
                                "<form action='deleteSchedule.jsp' method='get'><button type='submit' class='delete-button' name='scheduleId' value='" + scheduleId + "'>Delete</button></form>" +
                                "</td></tr>");
                }

                out.println("</table>");

                rs.close();
                ps.close();
                conn.close();
            } catch (Exception e) {
                out.println("<p style='color:red;'>Database error: " + e.getMessage() + "</p>");
            }
        %>
        <a href="repDashboard.jsp">
            <button class="action-button">Go to Customer Representative Dashboard</button>
        </a>
    </div>
</body>
</html>
