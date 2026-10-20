<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Appointment Details & Tracking" />
</jsp:include>

<div class="container py-4">
    <div class="row">
        <div class="col-lg-3">
            <jsp:include page="/WEB-INF/views/customer/sidebar.jsp">
                <jsp:param name="active" value="bookings" />
            </jsp:include>
        </div>

        <div class="col-lg-9">
            <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                <div>
                    <h4 class="fw-bold m-0 text-dark">
                        <i class="bi bi-clock-history text-warning me-2"></i> Service Tracking: #${appointment.appointmentId}
                    </h4>
                    <span class="badge ${appointment.badgeClass} mt-1">${appointment.status}</span>
                </div>
                <a href="${pageContext.request.contextPath}/customer/bookings" class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-arrow-left me-1"></i> Back to Appointments
                </a>
            </div>

            <div class="row g-4 mb-4">
                <!-- Appointment Info Card -->
                <div class="col-md-6">
                    <div class="card h-100 border-0 shadow-sm rounded-4 p-4">
                        <h6 class="fw-bold text-dark border-bottom pb-2 mb-3"><i class="bi bi-info-circle me-2 text-warning"></i>Booking Summary</h6>
                        <dl class="row small mb-0">
                            <dt class="col-sm-5 text-secondary">Service Package:</dt>
                            <dd class="col-sm-7 fw-semibold text-dark">${appointment.serviceName}</dd>

                            <dt class="col-sm-5 text-secondary">Scheduled Date:</dt>
                            <dd class="col-sm-7 text-dark">${appointment.appointmentDate}</dd>

                            <dt class="col-sm-5 text-secondary">Time Slot:</dt>
                            <dd class="col-sm-7 text-dark">${appointment.timeSlot}</dd>

                            <dt class="col-sm-5 text-secondary">Estimated Charge:</dt>
                            <dd class="col-sm-7 text-success fw-bold">₹${appointment.estimatedCost}</dd>

                            <dt class="col-sm-5 text-secondary">Issue Remarks:</dt>
                            <dd class="col-sm-7 text-dark">${not empty appointment.issueDescription ? appointment.issueDescription : 'Standard Periodic Service'}</dd>

                            <dt class="col-sm-5 text-secondary">Admin Remarks:</dt>
                            <dd class="col-sm-7 text-muted fst-italic">${not empty appointment.adminRemarks ? appointment.adminRemarks : 'No remarks yet.'}</dd>
                        </dl>
                    </div>
                </div>

                <!-- Vehicle Info Card -->
                <div class="col-md-6">
                    <div class="card h-100 border-0 shadow-sm rounded-4 p-4">
                        <h6 class="fw-bold text-dark border-bottom pb-2 mb-3"><i class="bi bi-car-front me-2 text-warning"></i>Vehicle Information</h6>
                        <dl class="row small mb-0">
                            <dt class="col-sm-5 text-secondary">Registration No:</dt>
                            <dd class="col-sm-7 fw-bold text-dark">${appointment.vehicleRegNo}</dd>

                            <dt class="col-sm-5 text-secondary">Make & Model:</dt>
                            <dd class="col-sm-7 text-dark">${appointment.vehicleBrand} ${appointment.vehicleModel}</dd>

                            <dt class="col-sm-5 text-secondary">Category:</dt>
                            <dd class="col-sm-7 text-dark">${appointment.vehicleType}</dd>
                        </dl>

                        <c:if test="${not empty serviceRecord}">
                            <div class="mt-4 pt-3 border-top">
                                <span class="badge bg-success mb-2">Invoice Generated</span>
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="small fw-semibold">Bill No: ${serviceRecord.invoiceNumber}</span>
                                    <a href="${pageContext.request.contextPath}/customer/invoices/details?id=${serviceRecord.invoiceId}" class="btn btn-sm btn-primary-vmss">
                                        View Bill <i class="bi bi-arrow-right"></i>
                                    </a>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Milestone Timeline Card -->
            <div class="card border-0 shadow-sm rounded-4 p-4">
                <h6 class="fw-bold text-dark border-bottom pb-2 mb-4"><i class="bi bi-signpost-split me-2 text-warning"></i>Real-Time Service Progress Timeline</h6>

                <c:choose>
                    <c:when test="${empty timeline}">
                        <div class="text-center py-4 text-muted">
                            <i class="bi bi-clock display-6 d-block mb-2 text-secondary opacity-50"></i>
                            <p class="small">The service bay has not recorded any progress milestones for this appointment yet.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <ul class="timeline">
                            <c:forEach var="t" items="${timeline}">
                                <li class="timeline-item">
                                    <span class="timeline-marker"></span>
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <h6 class="fw-bold text-dark m-0">${t.status}</h6>
                                        <span class="badge bg-light text-secondary border small">${t.createdAt}</span>
                                    </div>
                                    <p class="text-secondary small m-0">${t.description}</p>
                                    <span class="text-muted" style="font-size: 0.75rem;">Updated by: ${t.adminName}</span>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
