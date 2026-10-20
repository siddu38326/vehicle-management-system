# Vehicle Management and Service System (VMSS)

**A Complete Computer Science Engineering (CSE) Semester Mini-Project**  
Developed with **Java 17, Java Servlets (Jakarta EE 10), JSP, JDBC, Apache Tomcat 10.1, and MySQL 8.x**.

---

## 1. Project Overview & Introduction
The **Vehicle Management and Service System (VMSS)** is an enterprise-grade automotive service scheduling, garage fleet management, milestone tracking, and billing web application. It transitions traditional, manual, handwritten garage management systems into an end-to-end transparent digital workflow.

### User Roles
- **CUSTOMER**: Can register, log in, manage personal vehicles (Two-Wheelers, Four-Wheelers, etc.), browse dynamic service packages with prices loaded directly from MySQL, book service appointments with slot-capacity protection, track real-time workshop milestones, review historical repair records, and view/print itemized GST invoices with simulated digital payments.
- **ADMINISTRATOR**: Protected administrative console with system operational metrics (live KPI statistics, revenue calculations, booking distributions), customer directory management, fleet inspection, service package CRUD and activation toggling, booking confirmation/rejection, real-time workshop milestone logging, parts/labor cost recording, automated invoice generation, and financial ledger reporting.

---

## 2. Key Technology Stack
- **Backend Architecture**: Clean MVC (Model-View-Controller) with DAO and Service business layers.
- **Java Platform**: Java 17 / Java 23 compatible.
- **Web Technologies**: Java Servlets (`jakarta.servlet.*`), Jakarta Server Pages (JSP), JSP Expression Language (EL), Jakarta Standard Tag Library (JSTL).
- **Web Server / Servlet Container**: Apache Tomcat 10.1.
- **Database**: MySQL 8.x relational database (with automated zero-configuration H2 test/fallback engine for portable assessment).
- **Security & Integrity**: BCrypt 12-round password hashing (`at.favre.lib:bcrypt`), HTTP Session fixation rotation, Role-Based Access Control (RBAC), and CSRF synchronizer tokens on authenticated state-changing forms.
- **Frontend / UI**: Bootstrap 5, Bootstrap Icons, responsive CSS styling, and print-specific CSS media queries for tax invoices.
- **Financial Computation**: Java `BigDecimal` with `RoundingMode.HALF_UP` for exact subtotal, discount, GST tax (18%), and balance calculations.

---

## 3. Directory Structure
```
vehicle-management-system/
├── pom.xml
├── README.md
├── .gitignore
├── database/
│   ├── schema.sql
│   └── sample-data.sql
├── docs/
│   ├── abstract.md
│   ├── problem-statement.md
│   ├── objectives.md
│   ├── requirements.md
│   ├── architecture.md
│   ├── database-design.md
│   ├── test-cases.md
│   ├── viva-questions.md
│   └── future-enhancements.md
└── src/
    ├── main/
    │   ├── java/com/vmss/
    │   │   ├── controller/      # AuthServlet, CustomerServlet, AdminServlet, HomeServlet
    │   │   ├── dao/             # UserDAO, VehicleDAO, ServiceDAO, AppointmentDAO, etc.
    │   │   ├── filter/          # AuthenticationFilter (RBAC & CSRF Protection)
    │   │   ├── listener/        # AppContextListener (Database lifecycle management)
    │   │   ├── model/           # User, Vehicle, ServiceType, Appointment, Invoice, etc.
    │   │   ├── service/         # VehicleService (Business logic & transactions)
    │   │   └── util/            # DBConnection, SecurityUtil (BCrypt & Tokens)
    │   ├── resources/           # database.properties, schema-h2.sql, sample-data-h2.sql
    │   └── webapp/
    │       ├── assets/css/      # style.css (Automotive design system & print styles)
    │       ├── WEB-INF/
    │       │   ├── web.xml      # Jakarta EE 10 deployment descriptor
    │       │   └── views/
    │       │       ├── common/  # header.jsp, footer.jsp, home.jsp, services.jsp, error.jsp
    │       │       ├── auth/    # login.jsp, register.jsp
    │       │       ├── customer/# dashboard.jsp, vehicles.jsp, bookings.jsp, invoices.jsp
    │       │       └── admin/   # dashboard.jsp, appointments.jsp, services.jsp, reports.jsp
    │       └── index.jsp
    └── test/java/com/vmss/      # VmssComprehensiveTest (JUnit 5 test suite)
```

---

## 4. Setup & Running Instructions

### Prerequisites
- Java JDK 17 or higher
- Apache Maven 3.8+ (or using portable Maven included in `.tools/apache-maven-3.9.6`)
- MySQL 8.x Server (Service `MySQL80`)
- Apache Tomcat 10.1 (or using portable Tomcat included in `.tools/apache-tomcat-10.1.20`)

### Step 1: Database Initialization in MySQL
Log into your MySQL terminal or MySQL Workbench:
```sql
SOURCE c:/Users/Arun kumar/OneDrive/Desktop/sid/vehicle-management-system/database/schema.sql;
SOURCE c:/Users/Arun kumar/OneDrive/Desktop/sid/vehicle-management-system/database/sample-data.sql;
```
Configure your credentials in `src/main/resources/database.properties` or set environment variables:
```bash
set DB_URL=jdbc:mysql://localhost:3306/vehicle_management_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
set DB_USER=root
set DB_PASSWORD=your_mysql_password
```
*(Note: If MySQL is unavailable or offline, the application automatically boots an embedded H2 MySQL-compatible database with all seed data preloaded, allowing instant demonstration anywhere.)*

### Step 2: Build the WAR Package
Navigate to the project root and build:
```bash
mvn clean package
```
*(Or use the local Maven executable: `..\.tools\apache-maven-3.9.6\bin\mvn.cmd clean package`)*

### Step 3: Deploy to Apache Tomcat 10.1
1. Copy `target/vmss.war` to the Tomcat `webapps/` folder:
   ```powershell
   Copy-Item target\vmss.war -Destination <TOMCAT_HOME>\webapps\vmss.war
   ```
2. Start Apache Tomcat:
   ```powershell
   <TOMCAT_HOME>\bin\catalina.bat run
   ```
3. Open your browser and navigate to:
   ```
   http://localhost:8080/vmss/
   ```

---

## 5. Development Test Accounts

| Role | Email | Password | Preloaded Data |
| :--- | :--- | :--- | :--- |
| **Administrator** | `admin@vmss.com` | `Admin@123` | Full administrative controls, reports, bay progress management |
| **Customer 1** | `rahul@gmail.com` | `Customer@123` | 2 Registered Vehicles (Hyundai Creta & Honda Activa), Completed & Pending Bookings |
| **Customer 2** | `priya@gmail.com` | `Customer@123` | 1 Registered Vehicle (Tata Nexon EV), Confirmed Appointment |
| **Customer 3** | `amit@gmail.com` | `Customer@123` | 2 Registered Vehicles (Maruti Swift & Royal Enfield), In-Progress bay service |

---

## 6. Automated Testing Verification
The project includes a JUnit 5 test suite (`VmssComprehensiveTest.java`) verifying:
1. BCrypt password hashing and salt verification
2. Multi-role authentication and credential verification
3. Input validation, format checks, and duplicate registration blocking
4. Vehicle CRUD and validation (year ranges, non-negative odometer)
5. Authorization and ownership direct-object reference defense
6. Appointment booking, capacity checks, and slot collision prevention
7. Workshop timeline chronology and milestone logging
8. Financial itemized calculations, 18% GST calculation with `BigDecimal`, and payment simulation
9. Dynamic database queries computing admin dashboard KPIs

Run tests anytime with:
```bash
mvn test
```
**Observed Execution Result:**
```
[INFO] Tests run: 9, Failures: 0, Errors: 0, Skipped: 0
[INFO] BUILD SUCCESS
```
