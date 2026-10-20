<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Service Catalog" />
</jsp:include>

<div class="container py-4">
    <div class="text-center mb-5">
        <h2 class="fw-bold">Comprehensive Automotive Services</h2>
        <p class="text-muted col-lg-6 mx-auto">
            Browse our standard maintenance procedures and transparent pricing. All services include digital diagnostic logs and warranty-backed parts.
        </p>
    </div>

    <div class="row g-4">
        <c:forEach var="s" items="${services}">
            <div class="col-md-6 col-lg-4">
                <div class="card h-100 card-stat border p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-1 rounded-pill">
                            <i class="bi bi-tag-fill me-1"></i> ${s.vehicleType}
                        </span>
                        <h4 class="fw-bold text-success m-0">₹${s.basePrice}</h4>
                    </div>

                    <h5 class="fw-bold text-dark mb-2">${s.serviceName}</h5>
                    <p class="text-muted small mb-4 flex-grow-1">${s.description}</p>

                    <div class="border-top pt-3 d-flex justify-content-between align-items-center">
                        <span class="text-secondary small"><i class="bi bi-clock-history me-1 text-warning"></i> Approx. ${s.estimatedDuration}</span>
                        <a href="${pageContext.request.contextPath}/customer/bookings/new" class="btn btn-primary-vmss btn-sm px-3">
                            Book Slot
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
