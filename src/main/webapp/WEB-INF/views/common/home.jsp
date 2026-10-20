<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Home" />
</jsp:include>

<!-- Hero Section -->
<section class="hero-section text-center">
    <div class="container py-4">
        <span class="badge bg-warning text-dark px-3 py-2 rounded-pill fw-bold mb-3">
            <i class="bi bi-shield-check me-1"></i> Authorized Multibrand Vehicle Care
        </span>
        <h1 class="display-4 fw-bold mb-3">Smart Vehicle Management & Servicing</h1>
        <p class="lead text-light opacity-75 col-lg-8 mx-auto mb-4">
            Book certified maintenance, track live repair progress stage-by-stage, store complete digital service histories, and receive transparent itemized invoices.
        </p>
        <div class="d-flex justify-content-center gap-3">
            <c:choose>
                <c:when test="${not empty sessionScope.currentUser}">
                    <a href="${pageContext.request.contextPath}/customer/bookings/new" class="btn btn-primary-vmss btn-lg px-4 shadow">
                        <i class="bi bi-calendar-plus me-2"></i> Book Service Now
                    </a>
                    <a href="${pageContext.request.contextPath}/customer/dashboard" class="btn btn-outline-light btn-lg px-4">
                        <i class="bi bi-speedometer2 me-2"></i> My Dashboard
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-primary-vmss btn-lg px-4 shadow">
                        <i class="bi bi-person-plus me-2"></i> Create Free Account
                    </a>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-light btn-lg px-4">
                        <i class="bi bi-box-arrow-in-right me-2"></i> Customer Login
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</section>

<!-- Features Grid -->
<section class="py-5">
    <div class="container">
        <div class="text-center mb-5">
            <h6 class="text-uppercase text-warning fw-bold">Why Choose VMSS</h6>
            <h2 class="fw-bold">Designed for Modern Vehicle Care</h2>
        </div>

        <div class="row g-4">
            <div class="col-md-4">
                <div class="card h-100 card-stat p-4 border-0">
                    <div class="stat-icon bg-primary bg-opacity-10 text-primary mb-3">
                        <i class="bi bi-car-front-fill fs-3"></i>
                    </div>
                    <h5 class="fw-bold">Digital Garage Management</h5>
                    <p class="text-muted small">
                        Register multiple two-wheelers and four-wheelers. Track odometer readings, registration numbers, and maintain complete digital identity for your garage.
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card h-100 card-stat p-4 border-0">
                    <div class="stat-icon bg-warning bg-opacity-10 text-warning mb-3">
                        <i class="bi bi-stopwatch-fill fs-3"></i>
                    </div>
                    <h5 class="fw-bold">Real-Time Service Progress</h5>
                    <p class="text-muted small">
                        Never wonder about your vehicle's status. Watch chronological milestone updates from gate reception to diagnostics, repair, and final collection.
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card h-100 card-stat p-4 border-0">
                    <div class="stat-icon bg-success bg-opacity-10 text-success mb-3">
                        <i class="bi bi-receipt-cutoff fs-3"></i>
                    </div>
                    <h5 class="fw-bold">Itemized Billing & Invoicing</h5>
                    <p class="text-muted small">
                        Receive 100% transparent itemized invoices with exact parts cost, labor charges, applicable taxes, and simulated instant payment confirmations.
                    </p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Featured Service Catalog Preview -->
<section class="py-5 bg-white border-top border-bottom">
    <div class="container">
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <h6 class="text-uppercase text-warning fw-bold">Our Services</h6>
                <h2 class="fw-bold m-0">Popular Maintenance Packages</h2>
            </div>
            <a href="${pageContext.request.contextPath}/services" class="btn btn-outline-dark btn-sm">
                View All Services <i class="bi bi-arrow-right ms-1"></i>
            </a>
        </div>

        <div class="row g-4">
            <c:forEach var="s" items="${featuredServices}">
                <div class="col-lg-3 col-md-6">
                    <div class="card h-100 border rounded-3 p-3 shadow-sm hover-shadow">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="badge bg-light text-dark border">${s.vehicleType}</span>
                            <span class="fw-bold text-success">₹${s.basePrice}</span>
                        </div>
                        <h6 class="fw-bold mb-2">${s.serviceName}</h6>
                        <p class="text-muted small flex-grow-1">${s.description}</p>
                        <div class="border-top pt-2 mt-2 d-flex justify-content-between align-items-center text-secondary small">
                            <span><i class="bi bi-clock me-1"></i> ${s.estimatedDuration}</span>
                            <a href="${pageContext.request.contextPath}/customer/bookings/new" class="btn btn-sm btn-primary-vmss py-0 px-2">Book</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
