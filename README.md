# Online Railway Reservation System

This project implements a full-stack web application for an **Online Railway Reservation System**. It enables customers to search train schedules, make one-way or round-trip reservations, and manage bookings. Admins and customer representatives can manage data, generate reports, and handle customer service operations.

---

## Tech Stack

- **Frontend**: HTML, JavaScript, JSP
- **Backend**: Java with JDBC
- **Database**: MySQL
- **Server**: Apache Tomcat (local deployment)

---

## System Roles & Capabilities

### 1. **Customer**
- Search for train schedules by origin, destination, and date
- Make one-way or round-trip reservations
- View current and past reservation history
- Cancel bookings
- Interact with customer service

### 2. **Customer Representative**
- Manage train schedules (edit/delete)
- Respond to customer queries
- Generate reports (e.g., all customers on a line/date, schedules per station)

### 3. **Manager/Admin**
- Manage customer representative records
- View sales and reservation analytics
- Generate revenue reports per customer or line
- Identify top-performing transit lines

---

## Database Schema

Core entities:
- **Trains**
- **Stations**
- **Train Schedules**
- **Reservations**
- **Customers**
- **Employees**

All tables include integrity constraints (e.g., referential integrity, primary/foreign keys).

---

## Features

- Support for **discounted fares** (children, seniors, disabled)
- Fare calculation per stop and round-trip pricing
- Forum-like Q&A between customers and support staff
- Secure login with access control by user role

---
