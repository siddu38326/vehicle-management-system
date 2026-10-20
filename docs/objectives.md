# Project Objectives

**Vehicle Management and Service System (VMSS)**  
Computer Science & Engineering Semester Mini-Project

---

## 1. Primary Project Aim
The overarching goal of the **Vehicle Management and Service System (VMSS)** is to develop an enterprise-ready, reliable, and secure web application that modernizes automotive garage operations. The system eliminates handwritten job cards, telephone scheduling confusion, opaque repair progress, and inaccurate manual billing by providing an integrated, role-based platform for both vehicle owners and service managers.

---

## 2. Specific Technical & Operational Objectives

### Objective 1: Digitize Multi-Category Vehicle Profiles
- Enable vehicle owners to establish a permanent digital garage containing multiple vehicles (Two-Wheelers, Four-Wheelers, Electric Vehicles, and Commercial).
- Record and validate critical vehicle identifiers including unique State Registration Numbers, vehicle manufacturer brand, model, manufacturing year, fuel type, chassis/VIN numbers, and current odometer logs.
- Protect historical vehicle data by preventing premature deletion of vehicles with associated service records.

### Objective 2: Automated Service Catalog & Transparent Pricing
- Transition service offerings from printed menus to a dynamic, database-driven catalog managed directly by administrators.
- Establish vehicle-category compatibility filters ensuring customers only view and book services tailored to their specific vehicle type (e.g., EV diagnostics vs. conventional IC engine oil changes).
- Maintain dynamic base rates retrieved in real time from MySQL, eliminating hardcoded prices.

### Objective 3: Capacity-Constrained Appointment Scheduling
- Provide an intuitive date and time-window scheduling engine that prevents workshop congestion.
- Enforce server-side slot availability and capacity validation to eliminate double-booking or over-allocation of diagnostic bays.
- Allow customers to record symptom descriptions and request appointment cancellations for eligible pending or confirmed bookings.

### Objective 4: Real-Time Milestone Tracking & Bay Visibility
- Provide workshop technicians and administrators with a progress logging console to record sequential milestones (*Vehicle Received*, *Inspection Started*, *Repair in Progress*, *Work Completed*, *Ready for Collection*).
- Display a real-time, chronological milestone timeline to customers, establishing operational transparency and eliminating repetitive status inquiry calls.

### Objective 5: Transactional Invoicing & High-Precision Billing
- Enforce multi-step ACID transactions across database tables upon service completion, automatically linking appointment status updates, permanent work logs, itemized parts costs, labor rates, and tax calculations.
- Eliminate binary floating-point roundoff errors by executing all currency math using Java `BigDecimal` (`RoundingMode.HALF_UP`).
- Generate formal, printable GST-compliant tax invoices with custom CSS media queries hiding UI elements during printing.
- Provide a simulated digital payment gateway (UPI, Credit/Debit Card, Net Banking, Cash) allowing instantaneous invoice settlement during project evaluation.

### Objective 6: Decision Support & Administrative Analytics
- Aggregate live relational queries to populate executive dashboards with key performance indicators: customer growth, fleet count, appointment conversion rate, workflow pipeline distribution, and total settled revenue.
- Provide administrators with structured search, filtering, and customer account management tools.

### Objective 7: Enterprise-Grade Application Security
- Protect user authentication credentials using the BCrypt adaptive hashing algorithm with a work factor of 12.
- Implement session rotation upon authentication to defend against session fixation attacks.
- Enforce server-side Role-Based Access Control (RBAC) across all administrative and customer routes.
- Defend against Insecure Direct Object References (IDOR) by systematically validating object ownership on every server request.
- Defend against Cross-Site Request Forgery (CSRF) via synchronizer token validation on all authenticated state-changing forms.
- Defend against SQL Injection by utilizing parameterized queries (`PreparedStatement`) exclusively throughout the Data Access layer.
