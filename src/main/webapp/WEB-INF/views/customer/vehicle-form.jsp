<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="${vehicle != null ? 'Edit Vehicle' : 'Add Vehicle'}" />
</jsp:include>

<div class="container py-4">
    <div class="row">
        <div class="col-lg-3">
            <jsp:include page="/WEB-INF/views/customer/sidebar.jsp">
                <jsp:param name="active" value="vehicles" />
            </jsp:include>
        </div>

        <div class="col-lg-9">
            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-4 p-md-5">
                    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                        <h4 class="fw-bold m-0 text-dark">
                            <i class="bi bi-car-front text-warning me-2"></i>
                            ${vehicle != null ? 'Edit Vehicle Specifications' : 'Register New Vehicle'}
                        </h4>
                        <a href="${pageContext.request.contextPath}/customer/vehicles" class="btn btn-outline-secondary btn-sm">
                            <i class="bi bi-arrow-left me-1"></i> Back to Vehicles
                        </a>
                    </div>

                    <form action="${pageContext.request.contextPath}/customer/vehicles/${vehicle != null ? 'update' : 'add'}" method="POST">
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                        <c:if test="${vehicle != null}">
                            <input type="hidden" name="vehicleId" value="${vehicle.vehicleId}">
                        </c:if>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="registrationNo" class="form-label small fw-semibold">Registration Number *</label>
                                <input type="text" class="form-control text-uppercase" id="registrationNo" name="registrationNo" 
                                       value="${vehicle != null ? vehicle.registrationNo : ''}" 
                                       placeholder="e.g. KA-01-AB-1234" 
                                       ${vehicle != null ? 'readonly' : 'required'}>
                                <div class="form-text">State code, district, and unique vehicle registration number.</div>
                            </div>

                            <div class="col-md-6">
                                <label for="vehicleType" class="form-label small fw-semibold">Vehicle Category *</label>
                                <select class="form-select" id="vehicleType" name="vehicleType" required>
                                    <option value="Four-Wheeler" ${vehicle != null && vehicle.vehicleType == 'Four-Wheeler' ? 'selected' : ''}>Four-Wheeler (Car / SUV)</option>
                                    <option value="Two-Wheeler" ${vehicle != null && vehicle.vehicleType == 'Two-Wheeler' ? 'selected' : ''}>Two-Wheeler (Bike / Scooter)</option>
                                    <option value="Other" ${vehicle != null && vehicle.vehicleType == 'Other' ? 'selected' : ''}>Other Commercial / Utility</option>
                                </select>
                            </div>

                            <div class="col-md-6">
                                <label for="brand" class="form-label small fw-semibold">Brand / Manufacturer *</label>
                                <input type="text" class="form-control" id="brand" name="brand" 
                                       value="${vehicle != null ? vehicle.brand : ''}" 
                                       placeholder="e.g. Hyundai, Honda, Tata" required>
                            </div>

                            <div class="col-md-6">
                                <label for="model" class="form-label small fw-semibold">Model Name *</label>
                                <input type="text" class="form-control" id="model" name="model" 
                                       value="${vehicle != null ? vehicle.model : ''}" 
                                       placeholder="e.g. Creta SX, Activa 6G, Nexon" required>
                            </div>

                            <div class="col-md-4">
                                <label for="manufacturingYear" class="form-label small fw-semibold">Manufacturing Year *</label>
                                <input type="number" class="form-control" id="manufacturingYear" name="manufacturingYear" 
                                       value="${vehicle != null ? vehicle.manufacturingYear : 2022}" 
                                       min="1980" max="2027" required>
                            </div>

                            <div class="col-md-4">
                                <label for="fuelType" class="form-label small fw-semibold">Fuel Type *</label>
                                <select class="form-select" id="fuelType" name="fuelType" required>
                                    <option value="Petrol" ${vehicle != null && vehicle.fuelType == 'Petrol' ? 'selected' : ''}>Petrol</option>
                                    <option value="Diesel" ${vehicle != null && vehicle.fuelType == 'Diesel' ? 'selected' : ''}>Diesel</option>
                                    <option value="Electric" ${vehicle != null && vehicle.fuelType == 'Electric' ? 'selected' : ''}>Electric (EV)</option>
                                    <option value="Hybrid" ${vehicle != null && vehicle.fuelType == 'Hybrid' ? 'selected' : ''}>Hybrid</option>
                                    <option value="CNG" ${vehicle != null && vehicle.fuelType == 'CNG' ? 'selected' : ''}>CNG</option>
                                    <option value="Other" ${vehicle != null && vehicle.fuelType == 'Other' ? 'selected' : ''}>Other</option>
                                </select>
                            </div>

                            <div class="col-md-4">
                                <label for="odometerReading" class="form-label small fw-semibold">Current Odometer (km)</label>
                                <input type="number" class="form-control" id="odometerReading" name="odometerReading" 
                                       value="${vehicle != null ? vehicle.odometerReading : 0}" min="0">
                            </div>

                            <div class="col-12">
                                <label for="chassisNo" class="form-label small fw-semibold">Chassis / VIN Number (Optional)</label>
                                <input type="text" class="form-control text-uppercase" id="chassisNo" name="chassisNo" 
                                       value="${vehicle != null ? vehicle.chassisNo : ''}" 
                                       placeholder="17-character VIN or Chassis number">
                            </div>
                        </div>

                        <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
                            <a href="${pageContext.request.contextPath}/customer/vehicles" class="btn btn-light px-4">Cancel</a>
                            <button type="submit" class="btn btn-primary-vmss px-4 shadow-sm">
                                <i class="bi bi-check2-circle me-1"></i> ${vehicle != null ? 'Update Vehicle' : 'Register Vehicle'}
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
