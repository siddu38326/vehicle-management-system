<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Admin Dashboard" />
</jsp:include>

<div class="container py-4">
    <div class="row">
        <!-- Sidebar -->
        <div class="col-lg-3">
            <jsp:include page="/WEB-INF/views/admin/sidebar.jsp">
                <jsp:param name="active" value="dashboard" />
            </jsp:include>
        </div>

        <!-- Main Content Area -->
        <div class="col-lg-9">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="fw-bold m-0 text-dark">Management Console</h3>
                    <p class="text-muted small m-0">Live operations, servicing bays, and metrics</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-navy btn-sm">
                    <i class="bi bi-file-earmark-bar-graph me-1"></i> Full Report
                </a>
            </div>

            <!-- KPI Metric Cards Grid -->
            <div class="row g-3 mb-4">
                <div class="col-md-3">
                    <div class="card card-stat border-0 p-3 bg-white">
                        <span class="text-secondary small fw-semibold">Customers</span>
                        <h3 class="fw-bold text-dark mt-1 mb-0">${stats.totalCustomers}</h3>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card card-stat border-0 p-3 bg-white">
                        <span class="text-secondary small fw-semibold">Vehicles Reg.</span>
                        <h3 class="fw-bold text-dark mt-1 mb-0">${stats.totalVehicles}</h3>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card card-stat border-0 p-3 bg-white">
                        <span class="text-secondary small fw-semibold">Total Bookings</span>
                        <h3 class="fw-bold text-primary mt-1 mb-0">${stats.totalAppointments}</h3>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card card-stat border-0 p-3 bg-white">
                        <span class="text-secondary small fw-semibold">Collected Revenue</span>
                        <h3 class="fw-bold text-success mt-1 mb-0">₹${stats.totalRevenue}</h3>
                    </div>
                </div>
            </div>

            <!-- Status Breakdown Badges -->
            <div class="card border-0 shadow-sm rounded-3 mb-4 p-3 bg-white">
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-2">
                    <span class="small fw-semibold text-secondary">Service Pipeline Status:</span>
                    <span class="badge bg-warning text-dark px-3 py-2">Pending: ${stats.pendingAppointments}</span>
                    <span class="badge bg-primary px-3 py-2">Confirmed: ${stats.confirmedAppointments}</span>
                    <span class="badge bg-info text-dark px-3 py-2">In Bay: ${stats.inProgressAppointments}</span>
                    <span class="badge bg-success px-3 py-2">Completed: ${stats.completedAppointments}</span>
                    <span class="badge bg-secondary px-3 py-2">Cancelled: ${stats.cancelledAppointments}</span>
                </div>
            </div>

            <!-- Recent Appointments Table -->
            <div class="card border-0 shadow-sm rounded-3 mb-4">
                <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                    <h6 class="fw-bold m-0"><i class="bi bi-clock-history text-warning me-2"></i>Incoming & Active Appointments</h6>
                    <a href="${pageContext.request.contextPath}/admin/appointments" class="text-decoration-none small">View All Bookings</a>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light small">
                                <tr>
                                    <th>ID</th>
                                    <th>Customer</th>
                                    <th>Vehicle</th>
                                    <th>Service</th>
                                    <th>Date & Slot</th>
                                    <th>Status</th>
                                    <th class="text-end">Manage</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="a" items="${recentAppointments}">
                                    <tr>
                                        <td class="fw-bold">#${a.appointmentId}</td>
                                        <td>
                                            <div class="fw-semibold text-dark">${a.customerName}</div>
                                            <div class="text-muted small">${a.customerPhone}</div>
                                        </td>
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
                                            <a href="${pageContext.request.contextPath}/admin/appointments/details?id=${a.appointmentId}" class="btn btn-sm btn-outline-dark">
                                                Manage
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Service Packages Quick Overview -->
            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                    <h6 class="fw-bold m-0"><i class="bi bi-tools text-warning me-2"></i>Active Service Packages</h6>
                    <a href="${pageContext.request.contextPath}/admin/services" class="text-decoration-none small">Configure Packages</a>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-sm table-hover align-middle mb-0">
                            <thead class="table-light small">
                                <tr>
                                    <th>Package Name</th>
                                    <th>Vehicle Type</th>
                                    <th>Base Price</th>
                                    <th>Duration</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="s" items="${services}">
                                    <tr>
                                        <td class="fw-semibold text-dark">${s.serviceName}</td>
                                        <td><span class="badge bg-light text-dark border">${s.vehicleType}</span></td>
                                        <td class="fw-bold text-success">₹${s.basePrice}</td>
                                        <td class="text-secondary small">${s.estimatedDuration}</td>
                                        <td>
                                            <span class="badge ${s.active ? 'bg-success' : 'bg-secondary'}">${s.active ? 'Active' : 'Inactive'}</span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
