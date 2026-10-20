# System Requirements Specification (SRS)

**Vehicle Management and Service System (VMSS)**  
Computer Science & Engineering Semester Mini-Project

---

## 1. Existing System & Limitations

### 1.1 Existing Manual System
Most independent automotive garages and multi-brand workshops still rely heavily on:
1. Physical paper ledgers and duplicate carbon-copy job sheets.
2. In-person or telephonic booking schedules recorded on whiteboards or desk diaries.
3. Hand-calculated invoices where parts costs, mechanics' labor hours, discounts, and taxes are computed on pocket calculators.
4. Verbal communication of repair status when vehicle owners call or visit the garage bay.

### 1.2 Limitations of Existing System
- **High Risk of Record Loss:** Paper records are vulnerable to physical damage, misplacement, and ink fading, erasing vital maintenance and warranty history.
- **Scheduling Collisions:** Double-booking service slots causes severe workshop bay bottlenecks, extended customer wait times, and idling labor.
- **Billing Inaccuracies & Disputes:** Handwritten math errors in tax and discount computations lead to customer friction and delayed payments.
- **Zero Transparency:** Customers are unable to verify the real-time stage of repair, which damages trust.
- **Lack of Centralized Metrics:** Business owners cannot track monthly revenue, technician productivity, or service conversion trends.

---

## 2. Proposed System Overview
The **Vehicle Management and Service System (VMSS)** provides a centralized web platform that completely digitizes garage workflows. It introduces strict role separation, automated availability scheduling, live milestone updates, and transactional financial accounting, ensuring 100% data integrity and transparency.

---

## 3. Hardware & Software Requirements

### 3.1 Software Requirements
- **Operating System:** Windows 10/11, Linux (Ubuntu/Debian/CentOS), or macOS
- **Java Development Kit (JDK):** Java 17 LTS or higher (tested with Java SE 23)
- **Web Server / Servlet Container:** Apache Tomcat 10.1.x (Jakarta EE 10 compliant)
- **Build & Dependency Management:** Apache Maven 3.8+ (or bundled portable Maven 3.9.6)
- **Database Engine:** MySQL Server 8.0 / 8.3 (with automated H2 in-memory fallback for portable demonstration)
- **Database Driver:** MySQL Connector/J 8.3.0
- **Security Library:** `at.favre.lib:bcrypt` 0.10.2
- **Testing Framework:** JUnit 5.10.2 (Jupiter Engine)
- **Web Browser:** Google Chrome, Mozilla Firefox, Microsoft Edge, or Safari with JavaScript enabled

### 3.2 Hardware Requirements
- **Processor:** Intel Core i3 / AMD Ryzen 3 or higher (2.0 GHz minimum)
- **RAM:** Minimum 4 GB RAM (8 GB recommended for simultaneous IDE, Tomcat, and MySQL execution)
- **Hard Disk Space:** Minimum 500 MB free disk space for application WAR, dependencies, and database storage
- **Display Resolution:** 1280 x 720 minimum (optimized for full-HD 1920 x 1080 and responsive mobile viewports)

---

## 4. Functional Requirements

### 4.1 Module 1: Authentication & User Accounts
- **FR-1.1:** System shall allow public visitors to register as customers with name, email, 10-digit phone, and password (minimum 6 characters).
- **FR-1.2:** System shall reject duplicate email addresses with clear validation messages.
- **FR-1.3:** System shall verify credentials against BCrypt hashes and rotate session IDs upon successful login.
- **FR-1.4:** System shall support role-based redirect (Admin to `/admin/dashboard`, Customer to `/customer/dashboard`).
- **FR-1.5:** System shall invalidate sessions upon logout and flush security tokens.
- **FR-1.6:** System shall permit authenticated users to update their name, phone number, and change their password.

### 4.2 Module 2: Vehicle Fleet Management
- **FR-2.1:** Customers shall be able to register two-wheelers, four-wheelers, and commercial vehicles.
- **FR-2.2:** System shall enforce unique vehicle registration numbers across the database.
- **FR-2.3:** System shall validate manufacturing years (between 1980 and current year + 1) and reject negative odometer readings.
- **FR-2.4:** Customers shall be able to edit and delete only their own vehicles.
- **FR-2.5:** System shall prohibit the deletion of vehicles that possess historical service records.
- **FR-2.6:** Administrators shall be able to inspect the entire fleet and view individual vehicle maintenance records.

### 4.3 Module 3: Service Catalog & Package Management
- **FR-3.1:** System shall store and retrieve service packages from MySQL with name, description, vehicle category, base rate, and estimated duration.
- **FR-3.2:** Administrators shall be able to add new packages, edit existing parameters, and toggle active/inactive status.
- **FR-3.3:** Customers shall view active services filtered by compatibility with their selected vehicle category.

### 4.4 Module 4: Appointment Scheduling Engine
- **FR-4.1:** Customers shall select a registered vehicle, compatible service, future date, and time slot.
- **FR-4.2:** System shall prevent appointment booking on past dates.
- **FR-4.3:** System shall verify that the selected date and time slot has remaining capacity before confirming the booking.
- **FR-4.4:** System shall assign initial status `PENDING` with estimated base cost.
- **FR-4.5:** Customers shall be permitted to cancel bookings only while in `PENDING` or `CONFIRMED` states.

### 4.5 Module 5: Workshop Progress Tracking
- **FR-5.1:** Administrators shall confirm, reject, or update appointment statuses.
- **FR-5.2:** Administrators shall record chronological milestone logs (*Vehicle Received*, *Inspection Started*, *Repair in Progress*, *Work Completed*, *Ready for Collection*).
- **FR-5.3:** System shall display a visual, chronological timeline of recorded milestones to the vehicle owner.

### 4.6 Module 6: Invoicing & Billing
- **FR-6.1:** Upon marking a job as completed, the system shall record replacement parts cost, labor cost, and discount in a single transaction.
- **FR-6.2:** System shall calculate taxable subtotal, 18% GST, and final total using `BigDecimal`.
- **FR-6.3:** System shall generate a unique invoice number (`INV-YYYYMM-XXXX`).
- **FR-6.4:** System shall render a printable tax invoice complying with print CSS standards.
- **FR-6.5:** System shall permit recording of simulated payments (UPI, Card, Cash) and transition invoice status to `PAID`.

### 4.7 Module 7: Analytics & Dashboards
- **FR-7.1:** Administrator dashboard shall display live counts of customers, registered vehicles, appointments by status, and total collected revenue.
- **FR-7.2:** Customer dashboard shall present quick metrics, registered vehicles, and active appointment statuses.
- **FR-7.3:** Reports page shall calculate operational conversion rates and financial summaries.

---

## 5. Non-Functional Requirements

- **NFR-1 (Security):** All passwords must be salted and hashed with BCrypt. State-changing requests must validate synchronizer CSRF tokens. Sensitive routes must verify roles in Java filters.
- **NFR-2 (Data Integrity):** Relational tables must enforce foreign keys (`ON DELETE RESTRICT`) and unique indexes. Multi-table writes must run in atomic transactions.
- **NFR-3 (Performance):** Page rendering and servlet database queries must complete within 500ms under standard local workloads.
- **NFR-4 (Usability):** Layout must be fully responsive across mobile (360px+), tablet (768px+), and desktop (1024px+) using Bootstrap 5.
- **NFR-5 (Maintainability):** Code must follow strict MVC separation: Servlets handle control flow, DAOs handle JDBC queries, Services enforce business logic, and JSPs handle views.
