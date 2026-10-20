<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Appointment Management" />
</jsp:include>

<div class="container py-4">
    <div class="row">
        <div class="col-lg-3">
            <jsp:include page="/WEB-INF/views/admin/sidebar.jsp">
                <jsp:param name="active" value="appointments" />
            </jsp:include>
        </div>

        <div class="col-lg-9">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="fw-bold m-0 text-dark">Appointment Management</h3>
                    <p class="text-muted small m-0">Filter, search, approve, and track repair orders</p>
                </div>
            </div>

            <!-- Search & Filter Controls -->
            <div class="card border-0 shadow-sm rounded-3 p-3 mb-4 bg-white">
                <form action="${pageContext.request.contextPath}/admin/appointments" method="GET" class="row g-2 align-items-center">
                    <div class="col-md-5">
                        <div class="input-group input-group-sm">
                            <span class="input-group-text bg-light"><i class="bi bi-search"></i></span>
                            <input type="text" name="q" class="form-control" placeholder="Search by customer, reg no, service..." value="${currentSearch}">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <select name="status" class="form-select form-select-sm" onchange="this.form.submit()">
                            <option value="ALL" ${currentStatus == 'ALL' ? 'selected' : ''}>-- All Statuses --</option>
                            <option value="PENDING" ${currentStatus == 'PENDING' ? 'selected' : ''}>PENDING</option>
                            <option value="CONFIRMED" ${currentStatus == 'CONFIRMED' ? 'selected' : ''}>CONFIRMED</option>
                            <option value="IN_PROGRESS" ${currentStatus == 'IN_PROGRESS' ? 'selected' : ''}>IN_PROGRESS</option>
                            <option value="COMPLETED" ${currentStatus == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                            <option value="CANCELLED" ${currentStatus == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                        </select>
                    </div>
                    <div class="col-md-3 d-flex gap-2">
                        <button type="submit" class="btn btn-navy btn-sm w-100">Filter</button>
                        <a href="${pageContext.request.contextPath}/admin/appointments" class="btn btn-light btn-sm">Reset</a>
                    </div>
                </form>
            </div>

            <!-- Table -->
            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty appointments}">
                            <div class="text-center py-5">
                                <i class="bi bi-calendar-x display-5 text-secondary opacity-50 mb-2 d-block"></i>
                                <h6 class="fw-bold">No Matching Appointments Found</h6>
                                <p class="text-muted small">Try modifying your filter or keyword search.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light small">
                                        <tr>
                                            <th>ID</th>
                                            <th>Customer Details</th>
                                            <th>Vehicle</th>
                                            <th>Service Package</th>
                                            <th>Date & Slot</th>
                                            <th>Status</th>
                                            <th class="text-end">Manage</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="a" items="${appointments}">
                                            <tr>
                                                <td class="fw-bold">#${a.appointmentId}</td>
                                                <td>
                                                    <div class="fw-semibold text-dark">${a.customerName}</div>
                                                    <div class="text-muted small">${a.customerPhone}</div>
                                                </td>
                                                <td>
                                                    <span class="fw-bold text-dark">${a.vehicleRegNo}</span>
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
                                                        <i class="bi bi-gear me-1"></i> Manage
                                                    </a>
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
