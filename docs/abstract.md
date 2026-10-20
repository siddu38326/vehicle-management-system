# Project Abstract

**Project Title:** Vehicle Management and Service System (VMSS)  
**Academic Degree:** Bachelor of Engineering / Technology in Computer Science & Engineering (CSE)  
**Domain:** Enterprise Web Applications, Relational Database Engineering & Information Security  

---

### Abstract
In the contemporary automotive service sector, small-to-medium automotive service centers and multi-brand workshops continue to depend on manual paperwork, physical ledger books, and verbal customer updates. This legacy approach is prone to clerical errors, misplaced vehicle records, scheduling collisions, untracked parts billing, and customer dissatisfaction resulting from opaque service progress.

The **Vehicle Management and Service System (VMSS)** addresses these inefficiencies by establishing an end-to-end, digital web platform that automates vehicle profile management, maintenance scheduling, live bay progression tracking, and transactional invoicing. Built on standard Java enterprise technologies—specifically **Java 17, Java Servlets (Jakarta EE 10), JSP, JDBC, and a normalized MySQL 8.x relational database**—the system strictly enforces the **Model-View-Controller (MVC)** architectural paradigm and the **Data Access Object (DAO)** pattern.

The platform provides dedicated, role-based workflows for two primary actors:
1. **Customers**, who can register multi-vehicle fleets (two-wheelers, four-wheelers, electric vehicles), browse dynamic catalog packages loaded directly from the database, book appointments with automated slot-capacity constraints, monitor milestone progression, view past maintenance histories, and access printable GST tax invoices with simulated instant payments.
2. **Administrators**, who oversee workshop bays, inspect vehicle fleets, manage catalog prices, assign technicians, log milestone events, input replacement parts and labor charges, and generate itemized bills.

Security is achieved through 12-round BCrypt password hashing, session rotation, synchronizer CSRF tokens on state-changing requests, and strict server-side ownership authorization to eliminate Insecure Direct Object References (IDOR). All financial calculations leverage `BigDecimal` to ensure decimal precision without floating-point inaccuracies. Experimental validation via JUnit 5 automated test suites demonstrates that VMSS delivers high reliability, robust data integrity, and a responsive user experience suitable for real-world deployment and academic demonstration.
