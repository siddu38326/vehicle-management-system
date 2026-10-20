<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="dashboard-sidebar shadow-sm mb-4">
    <div class="d-flex align-items-center gap-3 mb-4 pb-3 border-bottom">
        <div class="bg-warning bg-opacity-10 text-warning p-2 rounded-circle">
            <i class="bi bi-shield-lock-fill fs-3"></i>
        </div>
        <div>
            <h6 class="fw-bold mb-0">${sessionScope.currentUser.fullName}</h6>
            <span class="badge bg-danger">Administrator</span>
        </div>
    </div>

    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link ${param.active == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="bi bi-speedometer2"></i> Admin Dashboard
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.active == 'appointments' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/appointments">
                <i class="bi bi-calendar2-week"></i> Appointments
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.active == 'services' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/services">
                <i class="bi bi-tools"></i> Service Packages
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.active == 'vehicles' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/vehicles">
                <i class="bi bi-car-front"></i> All Vehicles
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.active == 'customers' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/customers">
                <i class="bi bi-people"></i> Customers
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.active == 'invoices' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/invoices">
                <i class="bi bi-receipt"></i> Invoices
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.active == 'payments' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/payments">
                <i class="bi bi-credit-card"></i> Payment Records
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.active == 'reports' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/reports">
                <i class="bi bi-graph-up"></i> Reports & Analytics
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.active == 'profile' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/profile">
                <i class="bi bi-person-gear"></i> Admin Profile
            </a>
        </li>
    </ul>
</div>
