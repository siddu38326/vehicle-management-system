# Manual Testing Checklist & Verification Guide

**Vehicle Management and Service System (VMSS)**  
Computer Science & Engineering Semester Mini-Project

Use this checklist during local college project demonstrations and viva examinations to verify every principal workflow systematically.

---

## 1. Authentication & Security Testing

| Step | Action | Expected Result | Verified |
| :--- | :--- | :--- | :---: |
| 1.1 | Open `http://localhost:8080/vmss/login` and submit with empty credentials | HTML5 client validation requires email and password fields. | [x] |
| 1.2 | Submit incorrect password for `admin@vmss.com` | Friendly alert appears: *"Invalid email address or password. Please verify your credentials."* | [x] |
| 1.3 | Log in with `admin@vmss.com` / `Admin@123` | Redirects to `/admin/dashboard` showing management console and stats. | [x] |
| 1.4 | Log out using the user menu dropdown | Session invalidated; redirected to `/login?msg=logged_out`. | [x] |
| 1.5 | Try accessing `http://localhost:8080/vmss/admin/dashboard` while logged out | Redirects to `/login` with notification: *"Please log in as an administrator to access this area."* | [x] |
| 1.6 | Log in with customer account `rahul@gmail.com` / `Customer@123` | Redirects to `/customer/dashboard`. | [x] |
| 1.7 | While logged in as customer, attempt accessing `http://localhost:8080/vmss/admin/dashboard` | Intercepted by filter; renders styled `access-denied.jsp` (HTTP 403). | [x] |

---

## 2. Customer Garage & Vehicle Management

| Step | Action | Expected Result | Verified |
| :--- | :--- | :--- | :---: |
| 2.1 | Navigate to `/customer/vehicles` | Displays customer's registered vehicles (e.g. KA-01-AB-1234, KA-01-XY-9876). | [x] |
| 2.2 | Click "Register New Vehicle" | Form opens with category, brand, model, year, fuel, and odometer fields. | [x] |
| 2.3 | Enter an already registered registration number (e.g., `KA-01-AB-1234`) | Server validation catches duplicate registration and displays clear error. | [x] |
| 2.4 | Register valid new vehicle (e.g. `KA-03-ZZ-9999`, Hero, Splendor, 2023, Petrol) | Successfully registers vehicle and lists it in the garage. | [x] |
| 2.5 | Click "Edit Vehicle" and modify odometer reading | Updated values persist and reflect on the vehicle listing. | [x] |
| 2.6 | Try deleting a vehicle that has historical service records | Deletion is safely prevented; informs user that historical audit logs are retained. | [x] |
| 2.7 | Try deleting a newly added vehicle without history | Vehicle is cleanly deleted with confirmation message. | [x] |

---

## 3. Service Appointment Booking Workflow

| Step | Action | Expected Result | Verified |
| :--- | :--- | :--- | :---: |
| 3.1 | Navigate to `/customer/bookings/new` | Vehicle dropdown shows user's vehicles; service package dropdown lists active services with prices. | [x] |
| 3.2 | Select vehicle, service package, tomorrow's date, and 10:00 AM slot | Form submits successfully. | [x] |
| 3.3 | Check `/customer/bookings` | New booking appears with status `PENDING` and estimated cost. | [x] |
| 3.4 | Click "Cancel" on a pending appointment | Appointment status updates to `CANCELLED` and cancel button disables. | [x] |

---

## 4. Administrator Bay Management & Milestone Logging

| Step | Action | Expected Result | Verified |
| :--- | :--- | :--- | :---: |
| 4.1 | Log in as `admin@vmss.com` and open `/admin/appointments` | Lists all bookings across customers with search and status filters. | [x] |
| 4.2 | Filter appointments by status `PENDING` or search by registration number | Matching records filter dynamically. | [x] |
| 4.3 | Click "Manage" on a pending appointment | Opens detail view with customer profile, vehicle specs, and action forms. | [x] |
| 4.4 | Update status to `CONFIRMED` with admin remarks | Status badge updates to `CONFIRMED` and timeline records the confirmation. | [x] |
| 4.5 | Add milestone: *Vehicle Received* -> "Received at service center bay" | Milestone appears in the real-time chronology with admin timestamp. | [x] |
| 4.6 | Add milestone: *Repair in Progress* -> "Engine oil flush and filter renewal" | Chronology updates with second milestone marker. | [x] |

---

## 5. Invoicing, Financial Math & Simulated Payment

| Step | Action | Expected Result | Verified |
| :--- | :--- | :--- | :---: |
| 5.1 | Under "Complete Job & Generate Tax Invoice", enter Parts: ₹800, Labor: ₹400, Discount: ₹50 | Form submits atomic transaction. | [x] |
| 5.2 | Verify financial breakdown on generated invoice | Subtotal: ₹1200.00, Discount: ₹50.00, Taxable: ₹1150.00, GST 18%: ₹207.00, Total: ₹1357.00. Status: `UNPAID`. | [x] |
| 5.3 | Click "Record Customer Payment" in admin console or "Simulate Payment" in customer portal | Modal opens. Select UPI and submit transaction reference. | [x] |
| 5.4 | Verify payment status | Invoice status transitions to `PAID` with green badge and audit record appears in transaction table. | [x] |
| 5.5 | Click "Print Tax Invoice" | Browser print preview renders clean, professional invoice with all navigation, sidebars, and buttons suppressed. | [x] |

---

## 6. Dashboards, Analytics & Catalog Management

| Step | Action | Expected Result | Verified |
| :--- | :--- | :--- | :---: |
| 6.1 | Open `/admin/dashboard` | Metric cards reflect accurate counts of customers, fleet, and total collected revenue directly from MySQL. | [x] |
| 6.2 | Open `/admin/reports` | Shows operational pipeline progress bars, completion ratios, and invoice settlement ledger. | [x] |
| 6.3 | Open `/admin/services` and add new service package | New package appears in the catalog immediately. | [x] |
| 6.4 | Click "Deactivate" on a service package | Package status toggles to `Inactive` and is excluded from customer booking dropdowns. | [x] |
| 6.5 | Open `/admin/customers` and toggle customer status | Status updates between `Active` and `Suspended`. | [x] |
