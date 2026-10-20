<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="About VMSS" />
</jsp:include>

<div class="container py-5">
    <div class="row align-items-center g-5">
        <div class="col-lg-6">
            <span class="badge bg-warning text-dark px-3 py-2 rounded-pill fw-bold mb-3">Academic Mini-Project</span>
            <h2 class="display-6 fw-bold mb-3">Vehicle Management and Service System (VMSS)</h2>
            <p class="text-secondary">
                VMSS is a comprehensive, production-grade automotive service scheduling and digital garage platform developed for a Computer Science Engineering semester project.
            </p>
            <p class="text-secondary">
                Designed to eliminate handwritten garage job sheets, manual invoice calculation errors, and opaque repair updates, VMSS enables direct interaction between vehicle owners and garage administrators.
            </p>

            <div class="card bg-light border-0 p-3 rounded-3 mt-4">
                <h6 class="fw-bold text-dark mb-2"><i class="bi bi-stack me-2 text-warning"></i> Architecture & Technology Stack:</h6>
                <ul class="list-unstyled small text-secondary mb-0">
                    <li><strong class="text-dark">Backend:</strong> Java 17, Java Servlets (Jakarta EE 10), JDBC, Apache Tomcat 10.1</li>
                    <li><strong class="text-dark">Frontend:</strong> JavaServer Pages (JSP), JSTL, Bootstrap 5, Bootstrap Icons</li>
                    <li><strong class="text-dark">Database:</strong> MySQL 8.x Normalized Relational Database with PreparedStatement & Transactions</li>
                    <li><strong class="text-dark">Security:</strong> BCrypt 12-round password hashing, Role-Based Access Control, Session rotation, CSRF protection</li>
                </ul>
            </div>
        </div>

        <div class="col-lg-6">
            <div class="card shadow-sm border p-4 rounded-4">
                <h5 class="fw-bold mb-3"><i class="bi bi-check-circle-fill text-success me-2"></i> Core Modules Implemented</h5>
                <div class="d-flex flex-column gap-3">
                    <div class="d-flex gap-3">
                        <i class="bi bi-shield-lock-fill text-primary fs-4"></i>
                        <div>
                            <h6 class="fw-bold mb-1">Dual-Role Authentication</h6>
                            <p class="text-muted small m-0">Strict separation between CUSTOMER and ADMIN roles with session security.</p>
                        </div>
                    </div>
                    <div class="d-flex gap-3">
                        <i class="bi bi-car-front-fill text-warning fs-4"></i>
                        <div>
                            <h6 class="fw-bold mb-1">Vehicle Garage Registry</h6>
                            <p class="text-muted small m-0">Customers manage multi-vehicle profiles with unique registration validation.</p>
                        </div>
                    </div>
                    <div class="d-flex gap-3">
                        <i class="bi bi-calendar2-range-fill text-info fs-4"></i>
                        <div>
                            <h6 class="fw-bold mb-1">Appointment Slot Engine</h6>
                            <p class="text-muted small m-0">Server-side capacity protection prevents overbooking and slot conflicts.</p>
                        </div>
                    </div>
                    <div class="d-flex gap-3">
                        <i class="bi bi-receipt-cutoff text-success fs-4"></i>
                        <div>
                            <h6 class="fw-bold mb-1">Transactional Invoicing</h6>
                            <p class="text-muted small m-0">Automatic calculation of parts, labor, discounts, and GST using BigDecimal with printable layout.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
