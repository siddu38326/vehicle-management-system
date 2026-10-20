<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Service History" />
</jsp:include>

<div class="container py-4">
    <div class="row">
        <div class="col-lg-3">
            <jsp:include page="/WEB-INF/views/customer/sidebar.jsp">
                <jsp:param name="active" value="history" />
            </jsp:include>
        </div>

        <div class="col-lg-9">
            <div class="mb-4">
                <h3 class="fw-bold m-0">Completed Service Records</h3>
                <p class="text-muted small m-0">Full historical maintenance logs and technician remarks</p>
                <c:if test="${not empty selectedVehicle}">
                    <div class="alert alert-info py-2 px-3 mt-2 d-flex justify-content-between align-items-center small">
                        <span><i class="bi bi-filter me-1"></i> Showing records for: <strong>${selectedVehicle.brand} ${selectedVehicle.model} (${selectedVehicle.registrationNo})</strong></span>
                        <a href="${pageContext.request.contextPath}/customer/service-history" class="btn btn-outline-info btn-sm py-0 px-2">Show All Records</a>
                    </div>
                </c:if>
            </div>

            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty history}">
                            <div class="text-center py-5">
                                <i class="bi bi-journal-x display-4 text-secondary opacity-50 mb-3 d-block"></i>
                                <h5 class="fw-bold">No Service Records Found</h5>
                                <p class="text-muted small">Completed services and part replacements will appear here.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light small">
                                        <tr>
                                            <th>Record ID</th>
                                            <th>Vehicle</th>
                                            <th>Service Package</th>
                                            <th>Work Carried Out</th>
                                            <th>Parts + Labor</th>
                                            <th>Completed On</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="h" items="${history}">
                                            <tr>
                                                <td class="fw-bold">#SR-${h.recordId}</td>
                                                <td>
                                                    <span class="fw-bold text-dark">${h.vehicleRegNo}</span>
                                                    <div class="text-muted small">${h.vehicleBrand} ${h.vehicleModel}</div>
                                                </td>
                                                <td>${h.serviceName}</td>
                                                <td>
                                                    <div class="small text-dark">${h.workDescription}</div>
                                                    <c:if test="${not empty h.remarks}">
                                                        <div class="text-muted fst-italic" style="font-size:0.75rem;">Note: ${h.remarks}</div>
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
