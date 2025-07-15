
CREATE DATABASE Railway_DB;
USE Railway_DB;


CREATE TABLE customers (
    ID INT PRIMARY KEY AUTO_INCREMENT,
	first_name VARCHAR(100) NOT NULL,
	last_name VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL,
	email VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE employees(
	ID INT PRIMARY KEY AUTO_INCREMENT,
    ssn VARCHAR(11) NOT NULL, 
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, 
    role ENUM('rep', 'admin') NOT NULL 
);

INSERT INTO employees(ssn, first_name, last_name, username, password, role) VALUES ('123456789', 'admin', 'k', 'admin_1', '1234', 'admin');

CREATE TABLE train_schedules (
    id INT PRIMARY KEY AUTO_INCREMENT,
    transit_line_name VARCHAR(100) NOT NULL,
    train VARCHAR(50) NOT NULL,
    origin VARCHAR(100) NOT NULL,
    destination VARCHAR(100) NOT NULL,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    travel_time TIME NOT NULL,
    total_fare DECIMAL(10, 2) NOT NULL,
    num_stops INT NOT NULL
);

CREATE TABLE train_stops (
    id INT PRIMARY KEY AUTO_INCREMENT,
    train_schedule_id INT NOT NULL,
    stop_name VARCHAR(100) NOT NULL,
    stop_order INT NOT NULL,
    arrival_time DATETIME NOT NULL,
    departure_time DATETIME NOT NULL,
    incremental_fare DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (train_schedule_id) REFERENCES train_schedules(id)
);



CREATE TABLE fare_discounts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    type VARCHAR(50) NOT NULL,
    discount_percentage DECIMAL(5, 2) NOT NULL
);

CREATE TABLE reservations (
    reservation_number INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    schedule_id INT NOT NULL,
    round_trip BOOLEAN NOT NULL,
    num_adults INT NOT NULL,
    num_children INT NOT NULL,
    num_seniors INT NOT NULL,
    num_disabled INT NOT NULL,
    total_fare DECIMAL(10, 2) NOT NULL,
    reservation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (schedule_id) REFERENCES train_schedules(id)
);


CREATE TABLE sales_reports (
    id INT AUTO_INCREMENT PRIMARY KEY,                     -- Unique identifier for the report
    report_month DATE NOT NULL,                            -- Month for which the report is generated
    transit_line_name VARCHAR(255) NOT NULL,               -- Name of the transit line
    adults INT DEFAULT 0,                                  -- Number of tickets sold to adults
    children INT DEFAULT 0,                                -- Number of tickets sold to children
    old INT DEFAULT 0,                                     -- Number of tickets sold to old passengers
    disabled INT DEFAULT 0,                                -- Number of tickets sold to disabled passengers
    total_tickets INT DEFAULT 0,                           -- Total tickets sold for the transit line
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP         -- Timestamp of when the report was generated
);


CREATE TABLE questions_answers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question VARCHAR(500) NOT NULL,
    answer VARCHAR(1000) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE customer_questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question TEXT NOT NULL,
    answer TEXT DEFAULT NULL,
    asked_by VARCHAR(255),
    answered_by VARCHAR(255) DEFAULT NULL,
    is_answered BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SAMPLE DATASET

INSERT INTO train_schedules 
(transit_line_name, train, origin, destination, departure_time, arrival_time, travel_time, total_fare, num_stops)
VALUES
('Northeast Corridor', '3806', 'Trenton', 'NY Penn', '2024-12-13 03:48:00', '2024-12-13 05:21:00', '01:33:00', 50.00, 10),
('Northeast Corridor', '3810', 'Trenton', 'NY Penn', '2024-12-13 06:30:00', '2024-12-13 08:03:00', '01:33:00', 50.00, 10),
('Coast Line', '7200', 'Long Branch', 'Hoboken', '2024-12-13 04:30:00', '2024-12-13 06:00:00', '01:30:00', 45.00, 8),
('Raritan Valley Line', '5308', 'Raritan', 'NY Penn', '2024-12-13 05:00:00', '2024-12-13 06:45:00', '01:45:00', 40.00, 7),
('Northeast Corridor', '3820', 'Trenton', 'NY Penn', '2024-12-13 07:00:00', '2024-12-13 08:35:00', '01:35:00', 50.00, 10),
('North Jersey Coast', '3210', 'Long Branch', 'Newark Penn', '2024-12-13 05:30:00', '2024-12-13 07:00:00', '01:30:00', 40.00, 8),
('Main/Bergen Line', '1102', 'Suffern', 'Hoboken', '2024-12-13 06:15:00', '2024-12-13 07:45:00', '01:30:00', 35.00, 6),
('Raritan Valley Line', '5312', 'Raritan', 'NY Penn', '2024-12-13 06:00:00', '2024-12-13 07:45:00', '01:45:00', 45.00, 7),
('Atlantic City Line', '4638', 'Atlantic City', 'Philadelphia 30th St', '2024-12-13 08:00:00', '2024-12-13 09:50:00', '01:50:00', 60.00, 5),
('Northeast Corridor', '3806', 'Trenton', 'NY Penn', '2024-12-14 03:48:00', '2024-12-14 05:21:00', '01:33:00', 50.00, 10),
('Northeast Corridor', '3810', 'Trenton', 'NY Penn', '2024-12-14 06:30:00', '2024-12-14 08:03:00', '01:33:00', 50.00, 10),
('Coast Line', '7200', 'Long Branch', 'Hoboken', '2024-12-14 04:30:00', '2024-12-14 06:00:00', '01:30:00', 45.00, 8),
('Raritan Valley Line', '5308', 'Raritan', 'NY Penn', '2024-12-14 05:00:00', '2024-12-14 06:45:00', '01:45:00', 40.00, 7),
('Northeast Corridor', '3820', 'Trenton', 'NY Penn', '2024-12-14 07:00:00', '2024-12-14 08:35:00', '01:35:00', 50.00, 10),
('North Jersey Coast', '3210', 'Long Branch', 'Newark Penn', '2024-12-14 05:30:00', '2024-12-14 07:00:00', '01:30:00', 40.00, 8),
('Main/Bergen Line', '1102', 'Suffern', 'Hoboken', '2024-12-14 06:15:00', '2024-12-14 07:45:00', '01:30:00', 35.00, 6),
('Raritan Valley Line', '5312', 'Raritan', 'NY Penn', '2024-12-14 06:00:00', '2024-12-14 07:45:00', '01:45:00', 45.00, 7),
('Atlantic City Line', '4638', 'Atlantic City', 'Philadelphia 30th St', '2024-12-14 08:00:00', '2024-12-14 09:50:00', '01:50:00', 60.00, 5),
('Northeast Corridor', '3807', 'Trenton', 'NY Penn', '2024-12-14 05:00:00', '2024-12-14 06:30:00', '01:30:00', 50.00, 10),
('Northeast Corridor', '3811', 'Trenton', 'NY Penn', '2024-12-14 07:30:00', '2024-12-14 09:00:00', '01:30:00', 50.00, 10),
('Coast Line', '7201', 'Long Branch', 'Hoboken', '2024-12-14 06:00:00', '2024-12-14 07:30:00', '01:30:00', 45.00, 8),
('Raritan Valley Line', '5309', 'Raritan', 'NY Penn', '2024-12-14 06:30:00', '2024-12-14 08:15:00', '01:45:00', 40.00, 7),
('Northeast Corridor', '3821', 'Trenton', 'NY Penn', '2024-12-14 08:00:00', '2024-12-14 09:35:00', '01:35:00', 50.00, 10),
('North Jersey Coast', '3211', 'Long Branch', 'Newark Penn', '2024-12-14 07:30:00', '2024-12-14 09:00:00', '01:30:00', 40.00, 8),
('Main/Bergen Line', '1103', 'Suffern', 'Hoboken', '2024-12-14 07:00:00', '2024-12-14 08:30:00', '01:30:00', 35.00, 6),
('Raritan Valley Line', '5313', 'Raritan', 'NY Penn', '2024-12-14 07:30:00', '2024-12-14 09:15:00', '01:45:00', 45.00, 7),
('Atlantic City Line', '4639', 'Atlantic City', 'Philadelphia 30th St', '2024-12-14 09:30:00', '2024-12-14 11:20:00', '01:50:00', 60.00, 5);

SELECT * FROM train_schedules;

INSERT INTO train_stops (train_schedule_id, stop_name, stop_order, arrival_time, departure_time, incremental_fare)
VALUES
(1, 'Princeton', 1, '2024-12-13 04:05:00', '2024-12-13 04:07:00', 5.00),
(1, 'New Brunswick', 2, '2024-12-13 04:25:00', '2024-12-13 04:27:00', 5.00),
(1, 'Edison', 3, '2024-12-13 04:40:00', '2024-12-13 04:42:00', 5.00),
(1, 'Metuchen', 4, '2024-12-13 04:50:00', '2024-12-13 04:52:00', 5.00),
(1, 'Rahway', 5, '2024-12-13 05:05:00', '2024-12-13 05:07:00', 5.00),
(1, 'Newark Penn', 6, '2024-12-13 05:15:00', '2024-12-13 05:17:00', 5.00),

(2, 'Princeton', 1, '2024-12-13 05:35:00', '2024-12-13 05:37:00', 5.00),
(2, 'New Brunswick', 2, '2024-12-13 05:55:00', '2024-12-13 05:57:00', 5.00),
(2, 'Edison', 3, '2024-12-13 06:10:00', '2024-12-13 06:12:00', 5.00),
(2, 'Metuchen', 4, '2024-12-13 06:20:00', '2024-12-13 06:22:00', 5.00),
(2, 'Rahway', 5, '2024-12-13 06:35:00', '2024-12-13 06:37:00', 5.00),
(2, 'Newark Penn', 6, '2024-12-13 06:45:00', '2024-12-13 06:47:00', 5.00),

(3, 'Long Branch', 1, '2024-12-13 04:45:00', '2024-12-13 04:47:00', 5.00),
(3, 'Hoboken', 2, '2024-12-13 05:30:00', '2024-12-13 05:32:00', 5.00),
(3, 'Newark Penn', 3, '2024-12-13 05:50:00', '2024-12-13 05:52:00', 5.00),

(4, 'Raritan', 1, '2024-12-13 05:15:00', '2024-12-13 05:17:00', 5.00),
(4, 'New York Penn', 2, '2024-12-13 06:15:00', '2024-12-13 06:17:00', 5.00),
(4, 'North Brunswick', 3, '2024-12-13 06:30:00', '2024-12-13 06:32:00', 5.00),

(5, 'Trenton', 1, '2024-12-13 06:15:00', '2024-12-13 06:17:00', 5.00),
(5, 'New York Penn', 2, '2024-12-13 07:00:00', '2024-12-13 07:02:00', 5.00),
(5, 'Rahway', 3, '2024-12-13 07:15:00', '2024-12-13 07:17:00', 5.00),

(6, 'Long Branch', 1, '2024-12-13 06:15:00', '2024-12-13 06:17:00', 5.00),
(6, 'Newark Penn', 2, '2024-12-13 06:45:00', '2024-12-13 06:47:00', 5.00),
(6, 'New York Penn', 3, '2024-12-13 07:00:00', '2024-12-13 07:02:00', 5.00),

(7, 'Main/Bergen Line', 1, '2024-12-13 06:30:00', '2024-12-13 06:32:00', 5.00),
(7, 'Hoboken', 2, '2024-12-13 07:00:00', '2024-12-13 07:02:00', 5.00),

(8, 'Suffern', 1, '2024-12-13 06:00:00', '2024-12-13 06:02:00', 5.00),
(8, 'Hoboken', 2, '2024-12-13 06:30:00', '2024-12-13 06:32:00', 5.00),

(9, 'Trenton', 1, '2024-12-13 05:30:00', '2024-12-13 05:32:00', 5.00),
(9, 'Philadelphia 30th St', 2, '2024-12-13 06:50:00', '2024-12-13 06:52:00', 5.00),

(10, 'Princeton', 1, '2024-12-13 05:05:00', '2024-12-13 05:07:00', 5.00),
(10, 'New Brunswick', 2, '2024-12-13 05:20:00', '2024-12-13 05:22:00', 5.00),
(10, 'Edison', 3, '2024-12-13 05:35:00', '2024-12-13 05:37:00', 5.00),
(10, 'Metuchen', 4, '2024-12-13 05:45:00', '2024-12-13 05:47:00', 5.00),
(10, 'Rahway', 5, '2024-12-13 06:00:00', '2024-12-13 06:02:00', 5.00),
(10, 'Newark Penn', 6, '2024-12-13 06:15:00', '2024-12-13 06:17:00', 5.00),

(11, 'Princeton', 1, '2024-12-13 07:15:00', '2024-12-13 07:17:00', 5.00),
(11, 'New Brunswick', 2, '2024-12-13 07:35:00', '2024-12-13 07:37:00', 5.00),
(11, 'Edison', 3, '2024-12-13 07:50:00', '2024-12-13 07:52:00', 5.00),

(12, 'Trenton', 1, '2024-12-13 08:00:00', '2024-12-13 08:02:00', 5.00),
(12, 'Philadelphia 30th St', 2, '2024-12-13 09:10:00', '2024-12-13 09:12:00', 5.00),

(13, 'Long Branch', 1, '2024-12-14 06:45:00', '2024-12-14 06:47:00', 5.00),
(13, 'Hoboken', 2, '2024-12-14 07:20:00', '2024-12-14 07:22:00', 5.00),
(13, 'Newark Penn', 3, '2024-12-14 07:40:00', '2024-12-14 07:42:00', 5.00),

(14, 'Raritan', 1, '2024-12-14 06:00:00', '2024-12-14 06:02:00', 5.00),
(14, 'New York Penn', 2, '2024-12-14 06:30:00', '2024-12-14 06:32:00', 5.00),
(14, 'North Brunswick', 3, '2024-12-14 06:45:00', '2024-12-14 06:47:00', 5.00),

(15, 'Trenton', 1, '2024-12-14 07:45:00', '2024-12-14 07:47:00', 5.00),
(15, 'New York Penn', 2, '2024-12-14 08:30:00', '2024-12-14 08:32:00', 5.00),

(16, 'Suffern', 1, '2024-12-14 07:00:00', '2024-12-14 07:02:00', 5.00),
(16, 'Hoboken', 2, '2024-12-14 07:30:00', '2024-12-14 07:32:00', 5.00),

(17, 'Main/Bergen Line', 1, '2024-12-14 06:15:00', '2024-12-14 06:17:00', 5.00),
(17, 'Hoboken', 2, '2024-12-14 06:45:00', '2024-12-14 06:47:00', 5.00),

(18, 'Long Branch', 1, '2024-12-14 07:05:00', '2024-12-14 07:07:00', 5.00),
(18, 'Hoboken', 2, '2024-12-14 07:30:00', '2024-12-14 07:32:00', 5.00),
(18, 'Newark Penn', 3, '2024-12-14 07:55:00', '2024-12-14 07:57:00', 5.00),

(19, 'Suffern', 1, '2024-12-14 06:50:00', '2024-12-14 06:52:00', 5.00),
(19, 'Hoboken', 2, '2024-12-14 07:15:00', '2024-12-14 07:17:00', 5.00),
(19, 'Newark Penn', 3, '2024-12-14 07:35:00', '2024-12-14 07:37:00', 5.00),

(20, 'Trenton', 1, '2024-12-14 05:25:00', '2024-12-14 05:27:00', 5.00),
(20, 'Philadelphia 30th St', 2, '2024-12-14 06:40:00', '2024-12-14 06:42:00', 5.00),
(20, 'New York Penn', 3, '2024-12-14 07:10:00', '2024-12-14 07:12:00', 5.00),

(21, 'Raritan', 1, '2024-12-14 07:45:00', '2024-12-14 07:47:00', 5.00),
(21, 'New York Penn', 2, '2024-12-14 08:15:00', '2024-12-14 08:17:00', 5.00),
(21, 'North Brunswick', 3, '2024-12-14 08:30:00', '2024-12-14 08:32:00', 5.00),

(22, 'Long Branch', 1, '2024-12-14 08:00:00', '2024-12-14 08:02:00', 5.00),
(22, 'Hoboken', 2, '2024-12-14 08:25:00', '2024-12-14 08:27:00', 5.00),
(22, 'Newark Penn', 3, '2024-12-14 08:40:00', '2024-12-14 08:42:00', 5.00),

(23, 'Main/Bergen Line', 1, '2024-12-14 08:05:00', '2024-12-14 08:07:00', 5.00),
(23, 'Hoboken', 2, '2024-12-14 08:30:00', '2024-12-14 08:32:00', 5.00),

(24, 'Raritan', 1, '2024-12-14 08:00:00', '2024-12-14 08:02:00', 5.00),
(24, 'New York Penn', 2, '2024-12-14 08:30:00', '2024-12-14 08:32:00', 5.00),

(25, 'Suffern', 1, '2024-12-14 09:00:00', '2024-12-14 09:02:00', 5.00),
(25, 'Hoboken', 2, '2024-12-14 09:30:00', '2024-12-14 09:32:00', 5.00),
(25, 'Newark Penn', 3, '2024-12-14 09:50:00', '2024-12-14 09:52:00', 5.00),

(26, 'Trenton', 1, '2024-12-14 09:05:00', '2024-12-14 09:07:00', 5.00),
(26, 'Philadelphia 30th St', 2, '2024-12-14 10:15:00', '2024-12-14 10:17:00', 5.00),

(27, 'Trenton', 1, '2024-12-14 07:30:00', '2024-12-14 07:32:00', 5.00),
(27, 'New York Penn', 2, '2024-12-14 08:15:00', '2024-12-14 08:17:00', 5.00);

INSERT INTO fare_discounts (type, discount_percentage)
VALUES
('Child', 25.00),
('Senior', 35.00),
('Disabled', 50.00),
('Round Trip', 0.00); -- Round trip fare calculation logic is handled by multiplying base fare by 2.

INSERT INTO questions_answers (question, answer) VALUES
('What is the refund policy for canceled tickets?', 'Refunds are processed within 7 business days.'),
('Are pets allowed on the train?', 'Pets are not allowed except for service animals.'),
('What are the available payment methods?', 'You can pay via credit card, debit card, or UPI.'),
('How can I check train availability?', 'Use the "Search Train Schedules" feature on our platform.'),
('Can I book multiple tickets in one transaction?', 'Yes, you can book up to 6 tickets at a time.'),
('What documents are required for senior citizen discount?', 'A valid government ID proving age is required.'),
('Can I change the date of my reservation?', 'No, you will need to cancel and rebook.'),
('How do I register on the platform?', 'Click on "Register" and fill in your details.'),
('Is there a discount for students?', 'Currently, we do not offer student discounts.'),
('What happens if the train is delayed?', 'We notify users via email or SMS in case of delays.'),
('Can I bring extra luggage?', 'Extra luggage is chargeable and needs to be pre-approved.'),
('Is Wi-Fi available on the train?', 'Wi-Fi is available only on select premium trains.'),
('What should I do if I lose my ticket?', 'You can retrieve your e-ticket using your account.'),
('Can I choose my seat while booking?', 'Seat selection is available during booking.'),
('Are food services available on the train?', 'Yes, food is available for purchase on most trains.'),
('What is the procedure for ticket cancellation?', 'Go to "Reservations" and select "Cancel Ticket".'),
('Do you offer group booking discounts?', 'Group discounts are available for more than 10 tickets.'),
('How do I provide feedback?', 'Use the "Feedback" section under "Help".'),
('Can I book tickets offline?', 'Yes, visit our nearest railway station for offline booking.'),
('What is the maximum luggage weight allowed?', 'Passengers are allowed up to 40kg luggage for free.');





