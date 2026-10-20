<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Maintenance History - ${vehicle.registrationNo}" />
</jsp:include>

<div class="container py-4">
    <div class="row">
        <div class="col-lg-3">
            <jsp:include page="/WEB-INF/views/admin/sidebar.jsp">
                <jsp:param name="active" value="vehicles" />
            </jsp:include>
        </div>

        <div class="col-lg-9">
            <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                <div>
                    <h4 class="fw-bold m-0 text-dark">
                        <i class="bi bi-clock-history text-warning me-2"></i> Maintenance History: ${vehicle.registrationNo}
                    </h4>
                    <span class="text-secondary small">${vehicle.brand} ${vehicle.model} (${vehicle.manufacturingYear}) - ${vehicle.fuelType}</span>
                </div>
                <a href="${pageContext.request.contextPath}/admin/vehicles" class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-arrow-left me-1"></i> Back to Fleet
                </a>
            </div>

            <!-- Vehicle Summary Card -->
            <div class="card border-0 shadow-sm rounded-4 p-4 mb-4 bg-white">
                <div class="row g-3 small">
                    <div class="col-md-3">
                        <span class="text-secondary d-block">Registered Owner:</span>
                        <strong class="text-dark">${vehicle.ownerName}</strong>
                    </div>
                    <div class="col-md-3">
                        <span class="text-secondary d-block">Owner Contact:</span>
                        <span class="text-dark">${vehicle.ownerEmail}</span>
                    </div>
                    <div class="col-md-3">
                        <span class="text-secondary d-block">Current Odometer:</span>
                        <strong class="text-dark">${vehicle.odometerReading} km</strong>
                    </div>
                    <div class="col-md-3">
                        <span class="text-secondary d-block">Category:</span>
                        <span class="badge bg-light text-dark border">${vehicle.vehicleType}</span>
                    </div>
                </div>
            </div>

            <!-- Records List -->
            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty history}">
                            <div class="text-center py-5">
                                <i class="bi bi-journal-check display-5 text-secondary opacity-50 mb-2 d-block"></i>
                                <h6 class="fw-bold">No Service History Found</h6>
                                <p class="text-muted small">No past completed service jobs recorded for this vehicle.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light small">
                                        <tr>
                                            <th>Record ID</th>
                                            <th>Service Performed</th>
                                            <th>Work Description</th>
                                            <th>Parts + Labor</th>
                                            <th>Completion Date</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="h" items="${history}">
                                            <tr>
                                                <td class="fw-bold">#SR-${h.recordId}</td>
                                                <td><span class="badge bg-light text-dark border">${h.serviceName}</span></td>
                                                <td>
                                                    <div class="small text-dark">${h.workDescription}</div>
                                                    <c:if test="${not empty h.remarks}">
                                                        <div class="text-muted fst-italic" style="font-size:0.75rem;">Remarks: ${h.remarks}</div>
                                                    </c:if>
                                                </td>
                                                <td class="text-success fw-bold">₹${h.totalCost}</td>
                                                <td>${h.completionDate}</td>
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
