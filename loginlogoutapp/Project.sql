
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

SELECT * FROM customers;

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
SELECT * FROM employees;



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

DESCRIBE train_schedules;
INSERT INTO train_schedules 
(transit_line_name, train, origin, destination, departure_time, arrival_time, travel_time, total_fare, num_stops)
VALUES
('Northeast Corridor', '3806', 'Trenton', 'NY Penn', '2024-12-10 03:48:00', '2024-12-10 05:21:00', '01:33:00', 50.00, 10),
('Northeast Corridor', '3810', 'Trenton', 'NY Penn', '2024-12-10 06:30:00', '2024-12-10 08:03:00', '01:33:00', 50.00, 10),
('Coast Line', '7200', 'Long Branch', 'Hoboken', '2024-12-10 04:30:00', '2024-12-10 06:00:00', '01:30:00', 45.00, 8),
('Raritan Valley Line', '5308', 'Raritan', 'NY Penn', '2024-12-10 05:00:00', '2024-12-10 06:45:00', '01:45:00', 40.00, 7),
('Northeast Corridor', '3820', 'Trenton', 'NY Penn', '2024-12-10 07:00:00', '2024-12-10 08:35:00', '01:35:00', 50.00, 10),
('North Jersey Coast', '3210', 'Long Branch', 'Newark Penn', '2024-12-10 05:30:00', '2024-12-10 07:00:00', '01:30:00', 40.00, 8),
('Main/Bergen Line', '1102', 'Suffern', 'Hoboken', '2024-12-10 06:15:00', '2024-12-10 07:45:00', '01:30:00', 35.00, 6),
('Raritan Valley Line', '5312', 'Raritan', 'NY Penn', '2024-12-10 06:00:00', '2024-12-10 07:45:00', '01:45:00', 45.00, 7),
('Atlantic City Line', '4638', 'Atlantic City', 'Philadelphia 30th St', '2024-12-10 08:00:00', '2024-12-10 09:50:00', '01:50:00', 60.00, 5);



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

INSERT INTO train_stops 
(train_schedule_id, stop_name, stop_order, arrival_time, departure_time, incremental_fare)
VALUES
(1, 'Princeton', 1, '2024-12-10 04:05:00', '2024-12-10 04:07:00', 5.00),
(1, 'New Brunswick', 2, '2024-12-10 04:25:00', '2024-12-10 04:27:00', 5.00),
(1, 'Edison', 3, '2024-12-10 04:40:00', '2024-12-10 04:42:00', 5.00),
(1, 'Metuchen', 4, '2024-12-10 04:50:00', '2024-12-10 04:52:00', 5.00),
(1, 'Rahway', 5, '2024-12-10 05:05:00', '2024-12-10 05:07:00', 5.00),
(1, 'Newark Penn', 6, '2024-12-10 05:15:00', '2024-12-10 05:17:00', 5.00);



-- Train: Northeast Corridor, #3810
INSERT INTO train_stops 
(train_schedule_id, stop_name, stop_order, arrival_time, departure_time, incremental_fare)
VALUES
(2, 'Princeton', 1, '2024-12-10 06:40:00', '2024-12-10 06:42:00', 5.00),
(2, 'New Brunswick', 2, '2024-12-10 06:55:00', '2024-12-10 06:57:00', 5.00),
(2, 'Edison', 3, '2024-12-10 07:10:00', '2024-12-10 07:12:00', 5.00),
(2, 'Metuchen', 4, '2024-12-10 07:20:00', '2024-12-10 07:22:00', 5.00),
(2, 'Newark Penn', 5, '2024-12-10 07:35:00', '2024-12-10 07:37:00', 5.00),
(2, 'Secaucus Junction', 6, '2024-12-10 07:45:00', '2024-12-10 07:47:00', 5.00),
(2, 'Hoboken', 7, '2024-12-10 07:55:00', '2024-12-10 07:57:00', 5.00),
(2, 'Jersey City', 8, '2024-12-10 08:00:00', '2024-12-10 08:02:00', 5.00),
(2, 'NY Penn', 9, '2024-12-10 08:03:00', '2024-12-10 08:05:00', 5.00);

-- Train: Coast Line, #7200
INSERT INTO train_stops 
(train_schedule_id, stop_name, stop_order, arrival_time, departure_time, incremental_fare)
VALUES
(3, 'Asbury Park', 1, '2024-12-10 04:40:00', '2024-12-10 04:42:00', 5.63),
(3, 'Red Bank', 2, '2024-12-10 04:55:00', '2024-12-10 04:57:00', 5.63),
(3, 'Hazlet', 3, '2024-12-10 05:10:00', '2024-12-10 05:12:00', 5.63),
(3, 'Rahway', 4, '2024-12-10 05:40:00', '2024-12-10 05:42:00', 5.63),
(3, 'Newark Penn', 5, '2024-12-10 05:55:00', '2024-12-10 05:57:00', 5.63),
(3, 'Secaucus Junction', 6, '2024-12-10 06:05:00', '2024-12-10 06:07:00', 5.63),
(3, 'Hoboken', 7, '2024-12-10 06:15:00', '2024-12-10 06:17:00', 5.63);

-- Train: Raritan Valley Line, #5308
INSERT INTO train_stops 
(train_schedule_id, stop_name, stop_order, arrival_time, departure_time, incremental_fare)
VALUES
(4, 'Bound Brook', 1, '2024-12-10 05:10:00', '2024-12-10 05:12:00', 5.71),
(4, 'Plainfield', 2, '2024-12-10 05:30:00', '2024-12-10 05:32:00', 5.71),
(4, 'Dunellen', 3, '2024-12-10 05:50:00', '2024-12-10 05:52:00', 5.71),
(4, 'Westfield', 4, '2024-12-10 06:10:00', '2024-12-10 06:12:00', 5.71),
(4, 'Cranford', 5, '2024-12-10 06:25:00', '2024-12-10 06:27:00', 5.71),
(4, 'Roselle Park', 6, '2024-12-10 06:35:00', '2024-12-10 06:37:00', 5.71),
(4, 'NY Penn', 7, '2024-12-10 06:45:00', '2024-12-10 06:47:00', 5.71);


-- Train: Northeast Corridor, #3820
INSERT INTO train_stops 
(train_schedule_id, stop_name, stop_order, arrival_time, departure_time, incremental_fare)
VALUES
(5, 'Princeton', 1, '2024-12-10 07:10:00', '2024-12-10 07:12:00', 5.00),
(5, 'New Brunswick', 2, '2024-12-10 07:25:00', '2024-12-10 07:27:00', 5.00),
(5, 'Edison', 3, '2024-12-10 07:40:00', '2024-12-10 07:42:00', 5.00),
(5, 'Newark Penn', 4, '2024-12-10 08:15:00', '2024-12-10 08:17:00', 5.00);

-- Train: North Jersey Coast, #3210
INSERT INTO train_stops 
(train_schedule_id, stop_name, stop_order, arrival_time, departure_time, incremental_fare)
VALUES
(6, 'Asbury Park', 1, '2024-12-10 05:40:00', '2024-12-10 05:42:00', 5.00),
(6, 'Red Bank', 2, '2024-12-10 05:55:00', '2024-12-10 05:57:00', 5.00),
(6, 'Hazlet', 3, '2024-12-10 06:15:00', '2024-12-10 06:17:00', 5.00),
(6, 'Rahway', 4, '2024-12-10 06:50:00', '2024-12-10 06:52:00', 5.00);

-- Train: Main/Bergen Line, #1102
INSERT INTO train_stops 
(train_schedule_id, stop_name, stop_order, arrival_time, departure_time, incremental_fare)
VALUES
(7, 'Ramsey Route 17', 1, '2024-12-10 06:20:00', '2024-12-10 06:22:00', 5.83),
(7, 'Ridgewood', 2, '2024-12-10 06:35:00', '2024-12-10 06:37:00', 5.83),
(7, 'Secaucus Junction', 3, '2024-12-10 07:15:00', '2024-12-10 07:17:00', 5.83);

-- Train: Raritan Valley Line, #5312
INSERT INTO train_stops 
(train_schedule_id, stop_name, stop_order, arrival_time, departure_time, incremental_fare)
VALUES
(8, 'Somerville', 1, '2024-12-10 06:15:00', '2024-12-10 06:17:00', 6.43),
(8, 'Bound Brook', 2, '2024-12-10 06:30:00', '2024-12-10 06:32:00', 6.43),
(8, 'Plainfield', 3, '2024-12-10 06:50:00', '2024-12-10 06:52:00', 6.43);

-- Train: Atlantic City Line, #4638
INSERT INTO train_stops 
(train_schedule_id, stop_name, stop_order, arrival_time, departure_time, incremental_fare)
VALUES
(9, 'Egg Harbor City', 1, '2024-12-10 08:15:00', '2024-12-10 08:17:00', 12.00),
(9, 'Lindenwold', 2, '2024-12-10 08:35:00', '2024-12-10 08:37:00', 12.00),
(9, 'Cherry Hill', 3, '2024-12-10 08:55:00', '2024-12-10 08:57:00', 12.00);

CREATE TABLE fare_discounts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    type VARCHAR(50) NOT NULL,
    discount_percentage DECIMAL(5, 2) NOT NULL
);

INSERT INTO fare_discounts (type, discount_percentage)
VALUES
('Child', 25.00),
('Senior', 35.00),
('Disabled', 50.00),
('Round Trip', 0.00); -- Round trip fare calculation logic is handled by multiplying base fare by 2.

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


select * from train_schedules;



