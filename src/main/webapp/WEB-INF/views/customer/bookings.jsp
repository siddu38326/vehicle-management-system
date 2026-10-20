<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="My Appointments" />
</jsp:include>

<div class="container py-4">
    <div class="row">
        <div class="col-lg-3">
            <jsp:include page="/WEB-INF/views/customer/sidebar.jsp">
                <jsp:param name="active" value="bookings" />
            </jsp:include>
        </div>

        <div class="col-lg-9">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="fw-bold m-0">My Appointments</h3>
                    <p class="text-muted small m-0">Review your past and upcoming service appointments</p>
                </div>
                <a href="${pageContext.request.contextPath}/customer/bookings/new" class="btn btn-primary-vmss btn-sm shadow-sm">
                    <i class="bi bi-plus-lg me-1"></i> Book New Service
                </a>
            </div>

            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty appointments}">
                            <div class="text-center py-5">
                                <i class="bi bi-calendar-x display-4 text-secondary opacity-50 mb-3 d-block"></i>
                                <h5 class="fw-bold">No Appointments Found</h5>
                                <p class="text-muted small mb-3">You do not have any scheduled appointments.</p>
                                <a href="${pageContext.request.contextPath}/customer/bookings/new" class="btn btn-primary-vmss btn-sm">Book an Appointment Now</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light small">
                                        <tr>
                                            <th>ID</th>
                                            <th>Vehicle</th>
                                            <th>Service Package</th>
                                            <th>Date & Slot</th>
                                            <th>Est. Cost</th>
                                            <th>Status</th>
                                            <th class="text-end">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="a" items="${appointments}">
                                            <tr>
                                                <td class="fw-bold">#${a.appointmentId}</td>
                                                <td>
                                                    <span class="fw-bold text-dark">${a.vehicleRegNo}</span>
                                                    <div class="text-muted small">${a.vehicleBrand} ${a.vehicleModel}</div>
                                                </td>
                                                <td>${a.serviceName}</td>
                                                <td>
                                                    <div>${a.appointmentDate}</div>
                                                    <span class="text-secondary small">${a.timeSlot}</span>
                                                </td>
                                                <td class="text-success fw-semibold">₹${a.estimatedCost}</td>
                                                <td><span class="badge ${a.badgeClass}">${a.status}</span></td>
                                                <td class="text-end">
                                                    <div class="btn-group btn-group-sm">
                                                        <a href="${pageContext.request.contextPath}/customer/bookings/details?id=${a.appointmentId}" class="btn btn-outline-dark" title="Track Progress & Details">
                                                            <i class="bi bi-eye"></i> Details
                                                        </a>
                                                        <c:if test="${a.cancellable}">
                                                            <form action="${pageContext.request.contextPath}/customer/bookings/cancel" method="POST" onsubmit="return confirm('Are you sure you want to cancel this booking?');" class="d-inline">
                                                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                                                <input type="hidden" name="appointmentId" value="${a.appointmentId}">
                                                                <button type="submit" class="btn btn-outline-danger" title="Cancel Appointment">
                                                                    <i class="bi bi-x-circle"></i>
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                    </div>
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
