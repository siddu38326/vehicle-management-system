<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Customer Dashboard" />
</jsp:include>

<div class="container py-4">
    <div class="row">
        <!-- Sidebar -->
        <div class="col-lg-3">
            <jsp:include page="/WEB-INF/views/customer/sidebar.jsp">
                <jsp:param name="active" value="dashboard" />
            </jsp:include>
        </div>

        <!-- Main Content -->
        <div class="col-lg-9">
            <!-- Welcome Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="fw-bold m-0">Customer Portal</h3>
                    <p class="text-muted small m-0">Monitor your vehicles, maintenance schedule, and invoices</p>
                </div>
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/customer/vehicles/add" class="btn btn-outline-dark btn-sm">
                        <i class="bi bi-car-front me-1"></i> Add Vehicle
                    </a>
                    <a href="${pageContext.request.contextPath}/customer/bookings/new" class="btn btn-primary-vmss btn-sm shadow-sm">
                        <i class="bi bi-calendar-plus me-1"></i> Book Appointment
                    </a>
                </div>
            </div>

            <!-- Summary KPI Cards -->
            <div class="row g-3 mb-4">
                <div class="col-md-3">
                    <div class="card card-stat border-0 p-3 bg-white">
                        <span class="text-secondary small fw-semibold">My Vehicles</span>
                        <h3 class="fw-bold text-dark mt-1 mb-0">${stats.totalVehicles}</h3>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card card-stat border-0 p-3 bg-white">
                        <span class="text-secondary small fw-semibold">Pending Review</span>
                        <h3 class="fw-bold text-warning mt-1 mb-0">${stats.pendingAppointments}</h3>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card card-stat border-0 p-3 bg-white">
                        <span class="text-secondary small fw-semibold">In Progress</span>
                        <h3 class="fw-bold text-info mt-1 mb-0">${stats.inProgressAppointments}</h3>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card card-stat border-0 p-3 bg-white">
                        <span class="text-secondary small fw-semibold">Completed</span>
                        <h3 class="fw-bold text-success mt-1 mb-0">${stats.completedAppointments}</h3>
                    </div>
                </div>
            </div>

            <!-- Registered Vehicles Quick View -->
            <div class="card border-0 shadow-sm rounded-3 mb-4">
                <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                    <h6 class="fw-bold m-0"><i class="bi bi-car-front text-warning me-2"></i>My Registered Vehicles</h6>
                    <a href="${pageContext.request.contextPath}/customer/vehicles" class="text-decoration-none small">Manage All</a>
                </div>
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty vehicles}">
                            <div class="text-center py-4 text-muted">
                                <i class="bi bi-car-front display-6 d-block mb-2 text-secondary opacity-50"></i>
                                <p class="small mb-2">No vehicles registered yet in your garage.</p>
                                <a href="${pageContext.request.contextPath}/customer/vehicles/add" class="btn btn-outline-warning btn-sm">Add First Vehicle</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light small">
                                        <tr>
                                            <th>Registration No</th>
                                            <th>Vehicle Type</th>
                                            <th>Brand & Model</th>
                                            <th>Fuel</th>
                                            <th>Odometer</th>
                                            <th class="text-end">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="v" items="${vehicles}">
                                            <tr>
                                                <td class="fw-bold text-dark">${v.registrationNo}</td>
                                                <td><span class="badge bg-light text-dark border">${v.vehicleType}</span></td>
                                                <td>${v.brand} ${v.model} (${v.manufacturingYear})</td>
                                                <td>${v.fuelType}</td>
                                                <td>${v.odometerReading} km</td>
                                                <td class="text-end">
                                                    <a href="${pageContext.request.contextPath}/customer/bookings/new?vehicleId=${v.vehicleId}" class="btn btn-sm btn-outline-success py-0 px-2">Book</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Recent Appointments -->
            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                    <h6 class="fw-bold m-0"><i class="bi bi-calendar-check text-warning me-2"></i>Recent Appointments & Tracking</h6>
                    <a href="${pageContext.request.contextPath}/customer/bookings" class="text-decoration-none small">View Full History</a>
                </div>
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty recentAppointments}">
                            <div class="text-center py-4 text-muted">
                                <i class="bi bi-calendar-x display-6 d-block mb-2 text-secondary opacity-50"></i>
                                <p class="small mb-2">You have not booked any service appointments yet.</p>
                                <a href="${pageContext.request.contextPath}/customer/bookings/new" class="btn btn-primary-vmss btn-sm">Book Service</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light small">
                                        <tr>
                                            <th>Appt ID</th>
                                            <th>Vehicle</th>
                                            <th>Service Package</th>
                                            <th>Date & Slot</th>
                                            <th>Status</th>
                                            <th class="text-end">Details</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="a" items="${recentAppointments}">
                                            <tr>
                                                <td class="fw-semibold">#${a.appointmentId}</td>
                                                <td>
                                                    <span class="fw-bold">${a.vehicleRegNo}</span>
                                                    <div class="text-muted small">${a.vehicleBrand} ${a.vehicleModel}</div>
                                                </td>
                                                <td>${a.serviceName}</td>
                                                <td>
                                                    <div>${a.appointmentDate}</div>
                                                    <span class="text-secondary small">${a.timeSlot}</span>
                                                </td>
                                                <td><span class="badge ${a.badgeClass}">${a.status}</span></td>
                                                <td class="text-end">
                                                    <a href="${pageContext.request.contextPath}/customer/bookings/details?id=${a.appointmentId}" class="btn btn-sm btn-outline-dark py-0 px-2">Track</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
