# Problem Statement, Objectives & Requirements

### 1. Problem Statement
Automotive service workshops and customer fleet operations frequently grapple with:
1. **Manual Record Keeping:** Vehicle maintenance registers are maintained in paper journals or non-networked spreadsheets, leading to lost service history, missing part warranties, and inaccurate odometer tracking.
2. **Scheduling Collisions:** Telephone and walk-in bookings without capacity checks result in workshop congestion, underutilized diagnostic bays, and excessive customer waiting times.
3. **Lack of Repair Transparency:** Customers remain uninformed regarding real-time vehicle repair stages, generating frequent follow-up phone calls.
4. **Clerical Invoicing Inaccuracies:** Manual calculation of labor charges, parts costs, discounts, and GST often causes billing disputes and delayed payments.

---

### 2. Objectives
1. **Digitize Multi-Vehicle Fleet Profiles:** Enable customers to register two-wheelers, four-wheelers, and electric vehicles with registration numbers, fuel types, and odometer logs.
2. **Automate Service Scheduling:** Provide a slot-capacity engine that prevents overbooking and verifies date availability.
3. **Establish Real-Time Workshop Tracking:** Allow workshop administrators to record milestone updates (e.g. *Vehicle Received*, *Inspection Started*, *Repair in Progress*, *Work Completed*) visible to customers in real time.
4. **Implement Accurate Itemized Billing:** Calculate parts costs, labor rates, promotional discounts, and 18% GST with arbitrary decimal precision (`BigDecimal`), generating printable invoices and logging payment transactions.
5. **Provide Decision Support via Dashboards:** Equip administrators with live KPIs, status pipelines, and revenue analytics queried directly from MySQL.

---

### 3. Requirements Specification

#### 3.1 Functional Requirements
- **FR-01 (Authentication & RBAC):** Secure login, registration, session rotation, and separate customer/admin access controls.
- **FR-02 (Vehicle Management):** Complete CRUD for customer vehicles with validation on unique registration number, fuel type, and manufacturing year.
- **FR-03 (Service Catalog):** Database-driven catalog with vehicle-type compatibility and active/inactive status toggle.
- **FR-04 (Appointment Booking):** Interactive date and time slot selection, issue description logging, and cancellation rules.
- **FR-05 (Milestone Tracking):** Chronological logging of repair stages by administrators and timeline visualization for customers.
- **FR-06 (Transactional Invoicing):** Atomic generation of service records and tax invoices upon service completion.
- **FR-07 (Simulated Payments):** Recording of digital payment references (UPI, Card, Cash) and transition of invoice status to `PAID`.
- **FR-08 (Reporting & Dashboards):** Live database aggregation for operational metrics and financial summaries.

#### 3.2 Non-Functional Requirements
- **NFR-01 (Security):** BCrypt password hashing (Cost 12), parameterized SQL queries via `PreparedStatement`, CSRF synchronizer tokens, and HTTP security headers.
- **NFR-02 (Reliability & ACID Compliance):** JDBC transactions ensure that multi-table operations commit or rollback atomically.
- **NFR-03 (Usability & Responsiveness):** Clean Bootstrap 5 automotive design system responsive across mobile, tablet, and desktop screens.
- **NFR-04 (Portability):** Zero-configuration embedded fallback mechanism guarantees immediate demonstration even if MySQL is not configured on the evaluation machine.
