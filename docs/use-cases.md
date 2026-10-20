# Use Case Descriptions

**Vehicle Management and Service System (VMSS)**  
Computer Science & Engineering Semester Mini-Project

---

## 1. Actor Identification
1. **Customer (Vehicle Owner):** An external user who creates an account, registers their personal vehicles, books maintenance appointments, tracks repair stages, and pays/prints invoices.
2. **Administrator (Workshop / Garage Manager):** An internal privileged user who accepts bookings, configures service packages, manages customer accounts, logs repair milestones, records parts/labor costs, and views financial reports.

---

## 2. Key Use Case Specifications

### Use Case UC-01: Customer Registration
- **Primary Actor:** Customer (Visitor)
- **Preconditions:** Customer possesses a valid email address and 10-digit mobile number.
- **Main Flow:**
  1. Customer navigates to `/register`.
  2. Customer enters full name, email, phone number, password, and confirmation password.
  3. System validates input formats, password match, and queries database for duplicate email.
  4. System hashes password using BCrypt (12 rounds) and creates record in `users` table with `role='CUSTOMER'`.
  5. System redirects customer to login page with a success message.
- **Exceptions:**
  - Email already exists -> System displays "An account with this email address already exists."
  - Passwords do not match -> System flags error and retains valid form inputs.

---

### Use Case UC-02: Register New Vehicle
- **Primary Actor:** Customer
- **Preconditions:** Customer is authenticated with role `CUSTOMER`.
- **Main Flow:**
  1. Customer navigates to `/customer/vehicles/add`.
  2. Customer inputs registration number, vehicle category (Two-Wheeler/Four-Wheeler/Other), brand, model, manufacturing year, fuel type, optional chassis/VIN, and odometer reading.
  3. System validates year (1980 to current+1), non-negative odometer, and checks that the registration number does not already exist in the database.
  4. System links vehicle to authenticated customer's `user_id` and saves it in `vehicles`.
  5. System redirects to `/customer/vehicles` with success message.
- **Exceptions:**
  - Duplicate registration number -> System alerts: "Vehicle with registration number [REG] is already registered."

---

### Use Case UC-03: Book Service Appointment
- **Primary Actor:** Customer
- **Preconditions:** Customer has registered at least one vehicle.
- **Main Flow:**
  1. Customer navigates to `/customer/bookings/new`.
  2. Customer selects a registered vehicle from their garage.
  3. System loads active services compatible with the selected vehicle's category.
  4. Customer chooses service package, selects future date, and picks an available time slot.
  5. Customer inputs symptom/issue description and submits form.
  6. Server checks that date is in the future and slot capacity has not been exceeded.
  7. Server inserts appointment record with status `PENDING`.
  8. Customer is redirected to `/customer/bookings` with a booking confirmation.
- **Exceptions:**
  - Selected slot is fully booked -> System alerts: "The selected time slot is fully booked for this date. Please choose another slot."
  - Past date selected -> System rejects booking with validation error.

---

### Use Case UC-04: Update Service Milestone
- **Primary Actor:** Administrator
- **Preconditions:** Administrator is logged in and appointment is in active status.
- **Main Flow:**
  1. Administrator views appointment details at `/admin/appointments/details?id=X`.
  2. Administrator selects progress milestone (e.g., *Inspection Started*, *Repair in Progress*, *Work Completed*).
  3. Administrator inputs detailed technical observations and clicks "Add Milestone".
  4. System records entry in `service_progress` linking appointment ID and admin ID.
  5. If stage is *Work Completed*, appointment status automatically transitions to `COMPLETED`.
  6. System refreshes appointment view and customer immediately sees the update in their tracking timeline.

---

### Use Case UC-05: Complete Service & Generate Tax Invoice
- **Primary Actor:** Administrator
- **Preconditions:** Repair work has finished.
- **Main Flow:**
  1. Administrator expands "Complete Job & Generate Tax Invoice" section on appointment details page.
  2. Administrator enters itemized parts cost, labor charges, applicable discount, and final technician remarks.
  3. Server begins a JDBC transaction (`conn.setAutoCommit(false)`).
  4. Server updates appointment status to `COMPLETED`.
  5. Server saves maintenance description into `service_records`.
  6. Server computes subtotal, taxable balance, 18% GST tax, and total amount using `BigDecimal`.
  7. Server creates new invoice record with formatted number `INV-YYYYMM-XXXX`.
  8. Server commits transaction.
  9. Administrator is redirected to the generated invoice details page.

---

### Use Case UC-06: Simulate Digital Invoice Payment
- **Primary Actor:** Customer or Administrator
- **Preconditions:** Invoice has been generated with status `UNPAID`.
- **Main Flow:**
  1. User clicks "Simulate Payment" / "Record Customer Payment" on the invoice view.
  2. Modal opens displaying total amount due. User selects payment mode (UPI / Card Swipe / Cash) and enters reference code.
  3. Server records payment entry in `payment_records` and updates invoice status to `PAID`.
  4. Invoice badge turns green (`PAID`) and payment history log updates with reference code and timestamp.
  5. User can click "Print Tax Invoice" to generate an official printout or PDF.
