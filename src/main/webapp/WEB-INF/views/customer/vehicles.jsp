<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="My Vehicles" />
</jsp:include>

<div class="container py-4">
    <div class="row">
        <div class="col-lg-3">
            <jsp:include page="/WEB-INF/views/customer/sidebar.jsp">
                <jsp:param name="active" value="vehicles" />
            </jsp:include>
        </div>

        <div class="col-lg-9">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="fw-bold m-0">My Vehicles</h3>
                    <p class="text-muted small m-0">Manage registered two-wheelers, four-wheelers, and vehicle specs</p>
                </div>
                <a href="${pageContext.request.contextPath}/customer/vehicles/add" class="btn btn-primary-vmss btn-sm shadow-sm">
                    <i class="bi bi-plus-lg me-1"></i> Register New Vehicle
                </a>
            </div>

            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty vehicles}">
                            <div class="text-center py-5">
                                <i class="bi bi-car-front display-4 text-secondary opacity-50 mb-3 d-block"></i>
                                <h5 class="fw-bold">No Vehicles Found</h5>
                                <p class="text-muted small mb-3">You haven't added any vehicles to your garage profile yet.</p>
                                <a href="${pageContext.request.contextPath}/customer/vehicles/add" class="btn btn-primary-vmss btn-sm">Add Your First Vehicle</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light small">
                                        <tr>
                                            <th>Registration No</th>
                                            <th>Category</th>
                                            <th>Brand & Model</th>
                                            <th>Year</th>
                                            <th>Fuel</th>
                                            <th>Odometer</th>
                                            <th class="text-end">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="v" items="${vehicles}">
                                            <tr>
                                                <td class="fw-bold text-dark">${v.registrationNo}</td>
                                                <td><span class="badge bg-light text-dark border">${v.vehicleType}</span></td>
                                                <td>${v.brand} ${v.model}</td>
                                                <td>${v.manufacturingYear}</td>
                                                <td>${v.fuelType}</td>
                                                <td>${v.odometerReading} km</td>
                                                <td class="text-end">
                                                    <div class="btn-group btn-group-sm">
                                                        <a href="${pageContext.request.contextPath}/customer/bookings/new?vehicleId=${v.vehicleId}" class="btn btn-outline-success" title="Book Service">
                                                            <i class="bi bi-calendar-plus"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/customer/service-history?vehicleId=${v.vehicleId}" class="btn btn-outline-info" title="Maintenance History">
                                                            <i class="bi bi-clock-history"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/customer/vehicles/edit?id=${v.vehicleId}" class="btn btn-outline-secondary" title="Edit Vehicle">
                                                            <i class="bi bi-pencil"></i>
                                                        </a>
                                                        <form action="${pageContext.request.contextPath}/customer/vehicles/delete" method="POST" onsubmit="return confirm('Are you sure you want to delete this vehicle?');" class="d-inline">
                                                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                                            <input type="hidden" name="vehicleId" value="${v.vehicleId}">
                                                            <button type="submit" class="btn btn-outline-danger" title="Delete Vehicle">
                                                                <i class="bi bi-trash"></i>
                                                            </button>
                                                        </form>
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
