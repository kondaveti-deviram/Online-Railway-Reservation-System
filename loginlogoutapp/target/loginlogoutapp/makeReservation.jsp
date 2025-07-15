<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    int customerId = 0;

    // Check if the user is logged in and has the "customer" role
    if (username == null || !"customer".equals(role)) {
        response.sendRedirect("login.jsp"); // Redirect to login if not a customer
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        // Get the customer ID from the username
        String dbURL = "jdbc:mysql://localhost:3306/Railway_DB";
        String dbUser = "root";
        String dbPassword = "Munna@1999";

        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        String sql = "SELECT id FROM customers WHERE username = ?";
        ps = conn.prepareStatement(sql);
        ps.setString(1, username);
        rs = ps.executeQuery();

        if (rs.next()) {
            customerId = rs.getInt("id"); // Set customerId from the database
        }
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error processing reservation: " + e.getMessage() + "</p>");
    } finally {
        // Ensure that the connection resources are closed
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error closing resources: " + e.getMessage() + "</p>");
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Make Reservation</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <h1>Railway Booking Platform</h1>
    </header>
    <div class="container">
        <h1>Make a Reservation</h1>

        <%
            // Get parameters from the request
            String origin = request.getParameter("origin");
            String destination = request.getParameter("destination");
            String travelDate = request.getParameter("date");

            // Print the selected details for debugging (optional)
            out.println("<p><strong>Origin:</strong>" + origin + "</p>");
            out.println("<p><strong>Destination:</strong>" + destination + "</p>");
            out.println("<p><strong>Date of Travel:</strong>" + travelDate + "</p>");
        %>

        <form method="post">
            <label for="roundTrip">Trip Type:</label>
            <select name="roundTrip" required>
                <option value="0">One Way</option>
                <option value="1">Round Trip</option>
            </select>

            <label for="numAdults">Number of Adults:</label>
            <input type="number" name="numAdults" value="1" min="1" required>

            <label for="numChildren">Number of Children:</label>
            <input type="number" name="numChildren" value="0" min="0">

            <label for="numSeniors">Number of Seniors:</label>
            <input type="number" name="numSeniors" value="0" min="0">

            <label for="numDisabled">Number of Disabled Passengers:</label>
            <input type="number" name="numDisabled" value="0" min="0">

            <button type="submit">Make Reservation</button>
        </form>

        <%
            // Handle form submission
            if (request.getMethod().equalsIgnoreCase("POST")) {
                boolean roundTrip = "1".equals(request.getParameter("roundTrip"));
                int numAdults = Integer.parseInt(request.getParameter("numAdults"));
                int numChildren = Integer.parseInt(request.getParameter("numChildren"));
                int numSeniors = Integer.parseInt(request.getParameter("numSeniors"));
                int numDisabled = Integer.parseInt(request.getParameter("numDisabled"));

                double fare = 0;
                double totalFare = 0;

                // Open a new connection for the form submission
                try (Connection conn2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/Railway_DB", "root", "Munna@1999")) {

                    // Fetch the base fare and schedule for the selected origin, destination, and travel date
                    String scheduleSql = "SELECT * FROM train_schedules WHERE origin = ? AND destination = ? AND DATE(departure_time) = ?";
                    ps = conn2.prepareStatement(scheduleSql);
                    ps.setString(1, origin);
                    ps.setString(2, destination);
                    ps.setString(3, travelDate);
                    rs = ps.executeQuery();

                    boolean scheduleAvailable = false;
                    int scheduleId = -1; // Initialize scheduleId

                    while (rs.next()) {
                        scheduleAvailable = true;
                        scheduleId = rs.getInt("id");

                        // Fetch the fare for the train
                        fare = rs.getDouble("total_fare");
                    }

                    if (!scheduleAvailable) {
                        out.println("<p>No available trains found for the selected route and date.</p>");
                        return; // Exit if no trains are available
                    }

                    // Calculate total fare with discounts (add logic for discounts)
                    double discount = 0;

                    // Apply child discount (25%)
                    String discountSql = "SELECT * FROM fare_discounts WHERE type = ?";
                    PreparedStatement discountPs = conn2.prepareStatement(discountSql);

                    // Child discount
                    discountPs.setString(1, "Child");
                    ResultSet discountRs = discountPs.executeQuery();
                    if (discountRs.next()) {
                        discount += numChildren * (fare * discountRs.getDouble("discount_percentage") / 100);
                    }

                    // Senior discount
                    discountPs.setString(1, "Senior");
                    discountRs = discountPs.executeQuery();
                    if (discountRs.next()) {
                        discount += numSeniors * (fare * discountRs.getDouble("discount_percentage") / 100);
                    }

                    // Disabled discount
                    discountPs.setString(1, "Disabled");
                    discountRs = discountPs.executeQuery();
                    if (discountRs.next()) {
                        discount += numDisabled * (fare * discountRs.getDouble("discount_percentage") / 100);
                    }

                    // Round trip discount
                    if (roundTrip) {
                        discountPs.setString(1, "Round Trip");
                        discountRs = discountPs.executeQuery();
                        if (discountRs.next()) {
                            discount += (fare * discountRs.getDouble("discount_percentage") / 100) * 2;
                        }
                    }

                    // Ensure that the totalFare is calculated correctly
                    totalFare = (fare * (numAdults + numChildren + numSeniors + numDisabled)) - discount;

                    // Ensure that if only 1 adult, the total fare is not zero
                    if (numAdults == 1 && totalFare == 0) {
                        totalFare = fare;  // Set totalFare to the base fare if it's calculated as zero
                    }

                    // If round trip, double the fare
                    if (roundTrip) totalFare *= 2;

                    // Insert the reservation into the database with the correct customerId
                    String insertSql = "INSERT INTO reservations (customer_id, schedule_id, round_trip, num_adults, num_children, num_seniors, num_disabled, total_fare) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                    ps = conn2.prepareStatement(insertSql);
                    ps.setInt(1, customerId); // Use the customerId from the session
                    ps.setInt(2, scheduleId); // Use the schedule_id from the selected schedule
                    ps.setBoolean(3, roundTrip);
                    ps.setInt(4, numAdults);
                    ps.setInt(5, numChildren);
                    ps.setInt(6, numSeniors);
                    ps.setInt(7, numDisabled);
                    ps.setDouble(8, totalFare);

                    int rows = ps.executeUpdate();
                    if (rows > 0) {
                        out.println("<p class='success'>Reservation made successfully! Total Fare: $" + totalFare + "</p>");
                    }

                    discountPs.close();
                    discountRs.close(); // Close the result set for discount
                    ps.close();

                } catch (Exception e) {
                    out.println("<p style='color:red;'>Error processing reservation: " + e.getMessage() + "</p>");
                }
            }
        %>

        <a href="viewReservations.jsp">
            <button class="action-button">View Reservations</button>
        </a>
    </div>
</body>
</html>
