<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Vehicle Fleet Inspection" />
</jsp:include>

<div class="container py-4">
    <div class="row">
        <div class="col-lg-3">
            <jsp:include page="/WEB-INF/views/admin/sidebar.jsp">
                <jsp:param name="active" value="vehicles" />
            </jsp:include>
        </div>

        <div class="col-lg-9">
            <div class="mb-4">
                <h3 class="fw-bold m-0 text-dark">Registered Fleet Registry</h3>
                <p class="text-muted small m-0">Inspect customer vehicles, fuel types, models, and ownership records</p>
            </div>

            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light small">
                                <tr>
                                    <th>Reg. Number</th>
                                    <th>Category</th>
                                    <th>Brand & Model</th>
                                    <th>Fuel</th>
                                    <th>Owner Name</th>
                                    <th>Odometer</th>
                                    <th>Registered Date</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="v" items="${vehicles}">
                                    <tr>
                                        <td class="fw-bold text-dark">${v.registrationNo}</td>
                                        <td><span class="badge bg-light text-dark border">${v.vehicleType}</span></td>
                                        <td>${v.brand} ${v.model} (${v.manufacturingYear})</td>
                                        <td>${v.fuelType}</td>
                                        <td>
                                            <div class="fw-semibold">${v.ownerName}</div>
                                            <div class="text-muted small">${v.ownerEmail}</div>
                                        </td>
                                        <td>${v.odometerReading} km</td>
                                        <td class="text-secondary small">${v.createdAt}</td>
                                        <td class="text-end">
                                            <a href="${pageContext.request.contextPath}/admin/vehicles/history?id=${v.vehicleId}" class="btn btn-sm btn-outline-dark py-0 px-2" title="View Service History">
                                                <i class="bi bi-clock-history me-1"></i> History
                                            </a>
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
