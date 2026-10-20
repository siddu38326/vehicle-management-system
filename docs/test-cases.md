# Test Cases & Execution Report

**Project:** Vehicle Management and Service System (VMSS)  
**Execution Environment:** Java 23 / 17, Apache Maven 3.9.6, JUnit 5.10.2  

---

### Automated JUnit 5 Test Execution Summary

| Test ID | Test Description | Input Conditions | Expected Outcome | Execution Result |
| :--- | :--- | :--- | :--- | :--- |
| **TC-01** | BCrypt Password Hashing & Salt Verification | Plaintext `"TestPassword@123"` | Cryptographic hash with prefix `$2a$`, verified against plaintext; rejected on incorrect password | **PASSED** |
| **TC-02** | Role-Based User Authentication | Email `admin@vmss.com`, Password `Admin@123` | Valid `User` returned with `role='ADMIN'`, `isAdmin()=true` | **PASSED** |
| **TC-03** | Customer Registration & Duplicate Email Defense | Duplicate email attempt for existing user | System raises `IllegalArgumentException("An account with this email address already exists.")` | **PASSED** |
| **TC-04** | Vehicle Manufacturing Year & Odometer Validation | Year `1970` or negative odometer `-50` | Rejection with `IllegalArgumentException` | **PASSED** |
| **TC-05** | Insecure Direct Object Reference (IDOR) Protection | Customer 1 editing Customer 2's vehicle ID | Server throws `SecurityException("Unauthorized access to vehicle record.")` | **PASSED** |
| **TC-06** | Appointment Past Date Validation | Booking scheduled on yesterday's date | Rejection with `IllegalArgumentException("Appointment date cannot be in the past.")` | **PASSED** |
| **TC-07** | Workshop Timeline Chronology | Admin logging `Inspection Started` milestone | Milestone logged and retrieved in chronological order | **PASSED** |
| **TC-08** | Invoicing Financial Math & Payment Recording | Parts ₹1000.00, Labor ₹500.00, Discount ₹100.00 | Subtotal ₹1500.00, Tax (18%) ₹252.00, Total ₹1652.00; payment recorded and status transitioned to `PAID` | **PASSED** |
| **TC-09** | Live Dashboard Database Queries | Admin dashboard statistics call | Non-zero counts returned for customers, vehicles, appointments, and revenue | **PASSED** |

**Total Tests Executed:** 9  
**Failures:** 0  
**Errors:** 0  
**Skipped:** 0  
**Status:** **BUILD SUCCESS**
