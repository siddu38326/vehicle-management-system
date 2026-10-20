# Viva Voce Questions & Answers

**Vehicle Management and Service System (VMSS)**  
Comprehensive technical guide for project demonstration and external viva defense.

---

### 1. What is the architecture of VMSS?
**Answer:** VMSS follows the classic **Model-View-Controller (MVC)** architectural pattern combined with the **Data Access Object (DAO)** pattern:
- **Model:** Java entities representing real-world automotive records (`User`, `Vehicle`, `Appointment`, `Invoice`, etc.).
- **View:** JavaServer Pages (JSP), JSP Expression Language (EL), and JSTL generating dynamic HTML with Bootstrap 5.
- **Controller:** Java Servlets (`AuthServlet`, `CustomerServlet`, `AdminServlet`, `HomeServlet`) intercepting HTTP requests, checking authorization, and directing flow.
- **DAO & Service:** Encapsulates business logic, transactional writes, slot capacity algorithms, and JDBC operations.

---

### 2. Why use Jakarta Servlet API (`jakarta.servlet.*`) instead of `javax.servlet.*`?
**Answer:** Apache Tomcat 10.1 implements the **Jakarta EE 10** specification. In Jakarta EE 9 and 10, the namespace transitioned from legacy `javax.*` to `jakarta.*`. Mixing `javax.servlet` with Tomcat 10.x leads to `ClassNotFoundException` or deployment failures. VMSS uses native `jakarta.servlet` dependencies to ensure 100% compatibility.

---

### 3. How are passwords secured in the database?
**Answer:** Passwords are never stored in plaintext. VMSS uses the **BCrypt adaptive hashing algorithm** with a work factor (cost) of 12 via `at.favre.lib:bcrypt`. BCrypt automatically generates a cryptographic 128-bit salt and incorporates key stretching, making rainbow table attacks and GPU-accelerated brute forcing computationally infeasible.

---

### 4. How does the system defend against SQL Injection?
**Answer:** Every database interaction across all DAO classes utilizes **parameterized SQL queries via `PreparedStatement`**. User-supplied inputs are bound using typed setters (e.g. `ps.setString(1, val)`, `ps.setInt(2, id)`) rather than string concatenation. The database engine precompiles the SQL command, treating input strictly as data and never as executable SQL code.

---

### 5. What is Insecure Direct Object Reference (IDOR) and how does VMSS prevent it?
**Answer:** IDOR occurs when an application exposes a reference to an internal object (such as `/customer/vehicles/edit?id=2`) without verifying whether the requesting user owns that object. A malicious customer could change the ID in the URL to view or delete another customer's vehicle.  
In VMSS, **every data mutation and lookup verifies ownership on the server**:
```java
Vehicle existing = vehicleDAO.findById(vehicleId);
if (existing == null || existing.getUserId() != currentUser.getUserId()) {
    throw new SecurityException("Unauthorized access to vehicle record.");
}
```

---

### 6. How does the appointment booking system handle concurrency and prevent overbooking?
**Answer:** 
1. **Server-side slot capacity verification:** `appointmentDAO.isSlotBooked(date, timeSlot)` verifies that the total non-cancelled appointments for a chosen date and time window do not exceed bay capacity.
2. **Database unique constraints:** The relational schema includes `CONSTRAINT uq_vehicle_date_slot UNIQUE (vehicle_id, appointment_date, time_slot)` to prevent duplicate active bookings for the same vehicle at the database engine level.

---

### 7. Why use Java `BigDecimal` for invoicing rather than `double` or `float`?
**Answer:** `float` and `double` are binary floating-point representations that can produce rounding inaccuracies (e.g., `0.1 + 0.2 = 0.30000000000000004`). In financial billing and GST calculations, precision errors are unacceptable. `BigDecimal` provides arbitrary-precision signed decimal arithmetic with explicit rounding modes (`RoundingMode.HALF_UP`).

---

### 8. How does the application maintain transaction atomicity during service completion?
**Answer:** When an administrator marks a service as completed, four related database writes must occur:
1. Update appointment status to `COMPLETED`
2. Insert a new `service_records` entry
3. Calculate and insert a new `invoices` entry
4. Log a `service_progress` milestone

VMSS wraps these steps inside a JDBC transaction:
```java
conn.setAutoCommit(false);
try {
    // 4 write operations
    conn.commit();
} catch (Exception ex) {
    conn.rollback();
    throw ex;
} finally {
    conn.setAutoCommit(true);
}
```
If any step fails, all intermediate writes are rolled back, guaranteeing complete consistency (ACID compliance).

---

### 9. How is Cross-Site Request Forgery (CSRF) prevented?
**Answer:** `AuthenticationFilter` generates a cryptographically secure random token upon session creation (`sessionScope.csrfToken`). Every state-changing HTML form (POST) submits this token in a hidden input field. The server filter validates that the submitted token matches the session token before processing the request.

---

### 10. How does the system handle database connectivity in different environments?
**Answer:** `DBConnection` reads configuration from `database.properties` and checks environment variables (`DB_URL`, `DB_USER`, `DB_PASSWORD`). If MySQL is offline or not installed on a presentation machine, it automatically engages an embedded **in-memory H2 database engine** configured in MySQL compatibility mode (`MODE=MySQL`), executing schema creation and seed scripts automatically. This ensures the application can be demonstrated seamlessly in any viva environment.
