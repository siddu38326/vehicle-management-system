<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Manage Appointment #${appointment.appointmentId}" />
</jsp:include>

<div class="container py-4">
    <div class="row">
        <div class="col-lg-3">
            <jsp:include page="/WEB-INF/views/admin/sidebar.jsp">
                <jsp:param name="active" value="appointments" />
            </jsp:include>
        </div>

        <div class="col-lg-9">
            <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                <div>
                    <h4 class="fw-bold m-0 text-dark">
                        <i class="bi bi-wrench-adjustable text-warning me-2"></i> Manage Booking #${appointment.appointmentId}
                    </h4>
                    <span class="badge ${appointment.badgeClass} mt-1">${appointment.status}</span>
                </div>
                <a href="${pageContext.request.contextPath}/admin/appointments" class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-arrow-left me-1"></i> Back to Appointments
                </a>
            </div>

            <!-- Overview Cards -->
            <div class="row g-4 mb-4">
                <div class="col-md-6">
                    <div class="card h-100 border-0 shadow-sm rounded-4 p-4 bg-white">
                        <h6 class="fw-bold border-bottom pb-2 mb-3"><i class="bi bi-person me-2 text-warning"></i>Customer & Vehicle Details</h6>
                        <dl class="row small mb-0">
                            <dt class="col-sm-5 text-secondary">Customer Name:</dt>
                            <dd class="col-sm-7 fw-semibold">${appointment.customerName}</dd>

                            <dt class="col-sm-5 text-secondary">Email & Phone:</dt>
                            <dd class="col-sm-7">${appointment.customerEmail}<br>${appointment.customerPhone}</dd>

                            <dt class="col-sm-5 text-secondary">Vehicle Reg No:</dt>
                            <dd class="col-sm-7 fw-bold text-dark">${appointment.vehicleRegNo}</dd>

                            <dt class="col-sm-5 text-secondary">Brand & Model:</dt>
                            <dd class="col-sm-7">${appointment.vehicleBrand} ${appointment.vehicleModel} (${appointment.vehicleType})</dd>
                        </dl>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="card h-100 border-0 shadow-sm rounded-4 p-4 bg-white">
                        <h6 class="fw-bold border-bottom pb-2 mb-3"><i class="bi bi-calendar-event me-2 text-warning"></i>Service & Schedule</h6>
                        <dl class="row small mb-0">
                            <dt class="col-sm-5 text-secondary">Package:</dt>
                            <dd class="col-sm-7 fw-semibold">${appointment.serviceName}</dd>

                            <dt class="col-sm-5 text-secondary">Date & Time:</dt>
                            <dd class="col-sm-7">${appointment.appointmentDate} (${appointment.timeSlot})</dd>

                            <dt class="col-sm-5 text-secondary">Customer Remarks:</dt>
                            <dd class="col-sm-7 text-dark">${appointment.issueDescription}</dd>

                            <dt class="col-sm-5 text-secondary">Admin Remarks:</dt>
                            <dd class="col-sm-7 text-muted">${appointment.adminRemarks}</dd>
                        </dl>
                    </div>
                </div>
            </div>

            <!-- Action Controls Accordion -->
            <div class="accordion mb-4 shadow-sm" id="adminActionsAccordion">
                <!-- 1. Status Update -->
                <div class="accordion-item">
                    <h2 class="accordion-header">
                        <button class="accordion-button fw-bold text-dark" type="button" data-bs-toggle="collapse" data-bs-target="#collapseStatus">
                            <i class="bi bi-sliders me-2 text-warning"></i> 1. Update Booking Status & Remarks
                        </button>
                    </h2>
                    <div id="collapseStatus" class="accordion-collapse collapse show">
                        <div class="accordion-body">
                            <form action="${pageContext.request.contextPath}/admin/appointments/update-status" method="POST" class="row g-3">
                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">

                                <div class="col-md-4">
                                    <label class="form-label small fw-semibold">New Status</label>
                                    <select name="status" class="form-select form-select-sm" required>
                                        <option value="PENDING" ${appointment.status == 'PENDING' ? 'selected' : ''}>PENDING</option>
                                        <option value="CONFIRMED" ${appointment.status == 'CONFIRMED' ? 'selected' : ''}>CONFIRMED</option>
                                        <option value="IN_PROGRESS" ${appointment.status == 'IN_PROGRESS' ? 'selected' : ''}>IN_PROGRESS</option>
                                        <option value="COMPLETED" ${appointment.status == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                                        <option value="CANCELLED" ${appointment.status == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                                        <option value="REJECTED" ${appointment.status == 'REJECTED' ? 'selected' : ''}>REJECTED</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small fw-semibold">Administrative Remarks</label>
                                    <input type="text" name="adminRemarks" class="form-control form-control-sm" value="${appointment.adminRemarks}" placeholder="Notes visible to customer...">
                                </div>
                                <div class="col-md-2 d-flex align-items-end">
                                    <button type="submit" class="btn btn-navy btn-sm w-100">Update</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- 2. Post Progress Milestone -->
                <div class="accordion-item">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed fw-bold text-dark" type="button" data-bs-toggle="collapse" data-bs-target="#collapseProgress">
                            <i class="bi bi-signpost-2 me-2 text-warning"></i> 2. Log Service Bay Milestone
                        </button>
                    </h2>
                    <div id="collapseProgress" class="accordion-collapse collapse">
                        <div class="accordion-body">
                            <form action="${pageContext.request.contextPath}/admin/appointments/add-progress" method="POST" class="row g-3">
                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">

                                <div class="col-md-4">
                                    <label class="form-label small fw-semibold">Milestone Stage</label>
                                    <select name="stageStatus" class="form-select form-select-sm" required>
                                        <option value="Vehicle Received">Vehicle Received</option>
                                        <option value="Inspection Started">Inspection Started</option>
                                        <option value="Repair in Progress">Repair in Progress</option>
                                        <option value="Quality Inspection">Quality Inspection</option>
                                        <option value="Work Completed">Work Completed</option>
                                        <option value="Ready for Collection">Ready for Collection</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small fw-semibold">Stage Progress Description</label>
                                    <input type="text" name="description" class="form-control form-control-sm" placeholder="e.g. Engine diagnostics complete, flushing transmission oil..." required>
                                </div>
                                <div class="col-md-2 d-flex align-items-end">
                                    <button type="submit" class="btn btn-primary-vmss btn-sm w-100">Add Milestone</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- 3. Complete & Generate Invoice -->
                <c:if test="${empty invoice}">
                    <div class="accordion-item">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed fw-bold text-success" type="button" data-bs-toggle="collapse" data-bs-target="#collapseInvoice">
                                <i class="bi bi-receipt me-2"></i> 3. Complete Job & Generate Tax Invoice
                            </button>
                        </h2>
                        <div id="collapseInvoice" class="accordion-collapse collapse">
                            <div class="accordion-body">
                                <form action="${pageContext.request.contextPath}/admin/invoices/generate" method="POST" class="row g-3">
                                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                    <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">

                                    <div class="col-12">
                                        <label class="form-label small fw-semibold">Detailed Work Performed *</label>
                                        <textarea name="workDescription" class="form-control form-control-sm" rows="3" placeholder="Replaced brake pads, flushed oil, cleaned throttle body..." required></textarea>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label small fw-semibold">Parts Cost (INR) *</label>
                                        <input type="number" step="0.01" min="0" name="partsCost" class="form-control form-control-sm" value="0.00" required>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label small fw-semibold">Labor Charges (INR) *</label>
                                        <input type="number" step="0.01" min="0" name="laborCost" class="form-control form-control-sm" value="500.00" required>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label small fw-semibold">Discount (INR)</label>
                                        <input type="number" step="0.01" min="0" name="discount" class="form-control form-control-sm" value="0.00">
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label small fw-semibold">Technician Remarks</label>
                                        <input type="text" name="remarks" class="form-control form-control-sm" placeholder="e.g. Next service due in 6 months or 5,000 km.">
                                    </div>
                                    <div class="col-12 text-end">
                                        <button type="submit" class="btn btn-success btn-sm px-4">
                                            <i class="bi bi-check-circle me-1"></i> Finalize Job & Generate Bill
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>

            <!-- Existing Invoice Card if Available -->
            <c:if test="${not empty invoice}">
                <div class="card border-success border-2 shadow-sm rounded-4 p-4 mb-4 bg-white">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <span class="badge bg-success mb-1">Invoice Generated</span>
                            <h5 class="fw-bold text-dark m-0">Bill: ${invoice.invoiceNumber}</h5>
                            <span class="text-secondary small">Total: ₹${invoice.totalAmount} (Status: <strong>${invoice.paymentStatus}</strong>)</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/invoices/details?id=${invoice.invoiceId}" class="btn btn-outline-success btn-sm">
                            <i class="bi bi-receipt me-1"></i> Manage Bill & Record Payment
                        </a>
                    </div>
                </div>
            </c:if>

            <!-- Real-time Progress Log -->
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                <h6 class="fw-bold border-bottom pb-2 mb-4"><i class="bi bi-clock-history me-2 text-warning"></i>Milestone Chronology</h6>
                <c:choose>
                    <c:when test="${empty timeline}">
                        <p class="text-muted small text-center m-0">No progress milestones recorded yet.</p>
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
                                    <span class="text-muted" style="font-size:0.75rem;">Recorded by: ${t.adminName}</span>
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
