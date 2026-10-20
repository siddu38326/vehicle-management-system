<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="dashboard-sidebar shadow-sm mb-4">
    <div class="d-flex align-items-center gap-3 mb-4 pb-3 border-bottom">
        <div class="bg-primary bg-opacity-10 text-primary p-2 rounded-circle">
            <i class="bi bi-person-circle fs-3"></i>
        </div>
        <div>
            <h6 class="fw-bold mb-0">${sessionScope.currentUser.fullName}</h6>
            <span class="badge bg-light text-secondary border">Customer Account</span>
        </div>
    </div>

    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link ${param.active == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/customer/dashboard">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.active == 'vehicles' ? 'active' : ''}" href="${pageContext.request.contextPath}/customer/vehicles">
                <i class="bi bi-car-front"></i> My Vehicles
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.active == 'bookings' ? 'active' : ''}" href="${pageContext.request.contextPath}/customer/bookings">
                <i class="bi bi-calendar2-check"></i> My Appointments
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.active == 'history' ? 'active' : ''}" href="${pageContext.request.contextPath}/customer/service-history">
                <i class="bi bi-clock-history"></i> Service Records
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.active == 'invoices' ? 'active' : ''}" href="${pageContext.request.contextPath}/customer/invoices">
                <i class="bi bi-receipt"></i> Invoices & Billing
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${param.active == 'profile' ? 'active' : ''}" href="${pageContext.request.contextPath}/customer/profile">
                <i class="bi bi-person-gear"></i> Profile & Security
            </a>
        </li>
        <li class="nav-item mt-3 pt-3 border-top">
            <a class="nav-link text-warning fw-bold" href="${pageContext.request.contextPath}/customer/bookings/new">
                <i class="bi bi-plus-circle"></i> Book New Service
            </a>
        </li>
    </ul>
</div>
