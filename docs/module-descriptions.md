# Detailed Module Descriptions

**Vehicle Management and Service System (VMSS)**  
Computer Science & Engineering Semester Mini-Project

---

## 1. Authentication & Security Module
- **Purpose:** Manages user identity verification, credential hashing, session lifecycles, and access authorization.
- **Java Classes Involved:**
  - `com.vmss.model.User`
  - `com.vmss.controller.AuthServlet`
  - `com.vmss.dao.UserDAO`
  - `com.vmss.util.SecurityUtil`
  - `com.vmss.filter.AuthenticationFilter`
- **Key Operations:**
  - `registerCustomer()`: Validates name, unique email, phone, and hashes password using BCrypt (12 rounds).
  - `authenticate()`: Verifies submitted plaintext password against stored cryptographic hash.
  - Session Fixation Defense: Invalidates existing session upon successful login and generates a fresh session identifier with a unique CSRF token.
  - `AuthenticationFilter`: Intercepts every incoming HTTP request, ensuring `/admin/*` is restricted strictly to administrators and `/customer/*` is restricted strictly to logged-in customers. Rejects state-changing POST requests if CSRF tokens do not match.

---

## 2. Vehicle Fleet Management Module
- **Purpose:** Maintains the digital garage inventory for customers and enables workshop-wide fleet inspection for administrators.
- **Java Classes Involved:**
  - `com.vmss.model.Vehicle`
  - `com.vmss.dao.VehicleDAO`
  - `com.vmss.controller.CustomerServlet`
  - `com.vmss.controller.AdminServlet`
  - `com.vmss.service.VehicleService`
- **Key Operations:**
  - `addVehicle()`: Enforces registration number uniqueness, vehicle category checks, valid manufacturing year limits, and non-negative odometer readings.
  - `updateVehicle()`: Verifies that the authenticated customer actually owns the vehicle before persisting changes (IDOR protection).
  - `deleteVehicle()`: Queries `appointmentDAO.hasAssociatedRecords(vehicleId)`. If past services or active bookings exist, deletion is blocked to preserve auditing history.
  - `getAllVehicles()` & `getVehicleServiceHistory()`: Allows administrators to inspect all vehicles across all registered customers and view complete maintenance logs.

---

## 3. Service Catalog & Package Management Module
- **Purpose:** Centralizes database-driven maintenance offerings, base prices, vehicle applicability, and active statuses.
- **Java Classes Involved:**
  - `com.vmss.model.ServiceType`
  - `com.vmss.dao.ServiceDAO`
  - `com.vmss.service.VehicleService`
  - `com.vmss.controller.AdminServlet`
  - `com.vmss.controller.HomeServlet`
- **Key Operations:**
  - `createService()`: Adds new maintenance packages with name, description, vehicle category (`All`, `Four-Wheeler`, `Two-Wheeler`), base price, and duration.
  - `updateService()`: Updates package rates and descriptions.
  - `toggleServiceStatus()`: Deactivates discontinued packages without deleting past service associations.
  - Dynamic Pricing: All service fees are fetched directly from MySQL; templates never hardcode prices.

---

## 4. Appointment Booking & Capacity Engine Module
- **Purpose:** Handles the end-to-end service appointment scheduling, conflict prevention, and status lifecycle.
- **Java Classes Involved:**
  - `com.vmss.model.Appointment`
  - `com.vmss.dao.AppointmentDAO`
  - `com.vmss.service.VehicleService`
  - `com.vmss.controller.CustomerServlet`
  - `com.vmss.controller.AdminServlet`
- **Key Operations:**
  - `bookAppointment()`: Validates that the appointment date is not in the past, ensures the customer owns the selected vehicle, checks active service status, and verifies bay slot capacity (`isSlotBooked()`).
  - `cancelAppointmentByCustomer()`: Validates that only `PENDING` or `CONFIRMED` future appointments can be cancelled by their owner.
  - `updateAppointmentStatus()`: Enables administrators to review, approve (`CONFIRMED`), reject (`REJECTED`), or move appointments to `IN_PROGRESS`.

---

## 5. Service Progress & Milestone Tracking Module
- **Purpose:** Provides workshop administrators with real-time bay progress recording and offers customers a live status timeline.
- **Java Classes Involved:**
  - `com.vmss.model.ServiceProgress`
  - `com.vmss.dao.ServiceProgressDAO`
  - `com.vmss.service.VehicleService`
- **Key Operations:**
  - `addServiceProgress()`: Records milestone stages (*Vehicle Received*, *Inspection Started*, *Repair in Progress*, *Work Completed*, *Ready for Collection*) along with descriptive remarks, the administrator's ID, and an automated timestamp.
  - Automatic Transition: Moving milestone to *Work Completed* automatically synchronizes the appointment status to `COMPLETED`.
  - Customer Timeline View: Chronologically renders milestone markers in a styled vertical timeline.

---

## 6. Billing, Invoicing & Payment Simulation Module
- **Purpose:** Automatically compiles itemized parts and labor charges into a GST tax invoice and records payment settlements.
- **Java Classes Involved:**
  - `com.vmss.model.Invoice`
  - `com.vmss.model.PaymentRecord`
  - `com.vmss.model.ServiceRecord`
  - `com.vmss.dao.InvoiceDAO`
  - `com.vmss.dao.PaymentDAO`
  - `com.vmss.dao.ServiceRecordDAO`
  - `com.vmss.service.VehicleService`
- **Key Operations:**
  - `completeServiceAndGenerateInvoice()`: Executes an atomic multi-table JDBC transaction:
    1. Sets appointment status to `COMPLETED`.
    2. Inserts technician work descriptions into `service_records`.
    3. Calculates subtotal, promotional discount, 18% GST, and final total using `BigDecimal`.
    4. Inserts formal record into `invoices` with unique number `INV-YYYYMM-XXXX`.
    5. Commits transaction or rolls back on any exception.
  - `recordPayment()`: Logs simulated payments (UPI, Card, Cash) and transitions invoice status to `PAID`.
  - Print Invoice View: Dedicated CSS `@media print` rules ensure only the invoice card prints, suppressing headers, sidebars, and buttons.

---

## 7. Reports & Analytics Module
- **Purpose:** Aggregates live operational and financial figures for administrative decision-making.
- **Java Classes Involved:**
  - `com.vmss.controller.AdminServlet`
  - `com.vmss.service.VehicleService`
  - `com.vmss.dao.UserDAO`, `VehicleDAO`, `AppointmentDAO`, `InvoiceDAO`
- **Key Operations:**
  - `getAdminDashboardStats()`: Aggregates total customer count, vehicle count, appointment status breakdown, and settled revenue sum.
  - Pipeline Analytics: Computes conversion percentage and operational ratios.
  - Audit Ledger: Displays complete history of invoices and transactions.
