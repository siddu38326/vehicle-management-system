<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Book Service Appointment" />
</jsp:include>

<div class="container py-4">
    <div class="row">
        <div class="col-lg-3">
            <jsp:include page="/WEB-INF/views/customer/sidebar.jsp">
                <jsp:param name="active" value="bookings" />
            </jsp:include>
        </div>

        <div class="col-lg-9">
            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-4 p-md-5">
                    <div class="mb-4 pb-2 border-bottom">
                        <h4 class="fw-bold m-0 text-dark">
                            <i class="bi bi-calendar2-plus text-warning me-2"></i> Book Service Appointment
                        </h4>
                        <p class="text-muted small m-0 mt-1">Select your vehicle, maintenance type, and convenient schedule</p>
                    </div>

                    <form action="${pageContext.request.contextPath}/customer/bookings/create" method="POST">
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">

                        <div class="row g-4">
                            <!-- Vehicle Selection -->
                            <div class="col-md-6">
                                <label for="vehicleId" class="form-label small fw-semibold">Select Vehicle *</label>
                                <select class="form-select" id="vehicleId" name="vehicleId" required>
                                    <option value="" disabled selected>-- Choose from registered vehicles --</option>
                                    <c:forEach var="v" items="${vehicles}">
                                        <option value="${v.vehicleId}" ${param.vehicleId == v.vehicleId ? 'selected' : ''}>
                                            ${v.brand} ${v.model} (${v.registrationNo}) - ${v.vehicleType}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Service Selection -->
                            <div class="col-md-6">
                                <label for="serviceId" class="form-label small fw-semibold">Service Package *</label>
                                <select class="form-select" id="serviceId" name="serviceId" required>
                                    <option value="" disabled selected>-- Select service type --</option>
                                    <c:forEach var="s" items="${services}">
                                        <option value="${s.serviceId}">
                                            ${s.serviceName} (₹${s.basePrice}) - For ${s.vehicleType}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Appointment Date -->
                            <div class="col-md-6">
                                <label for="appointmentDate" class="form-label small fw-semibold">Appointment Date *</label>
                                <input type="date" class="form-control" id="appointmentDate" name="appointmentDate" required>
                                <div class="form-text">Service bay is open Monday through Saturday.</div>
                            </div>

                            <!-- Time Slot -->
                            <div class="col-md-6">
                                <label for="timeSlot" class="form-label small fw-semibold">Preferred Time Slot *</label>
                                <select class="form-select" id="timeSlot" name="timeSlot" required>
                                    <option value="" disabled selected>-- Select time window --</option>
                                    <option value="09:00 AM - 11:00 AM">09:00 AM - 11:00 AM (Morning Slot 1)</option>
                                    <option value="11:00 AM - 01:00 PM">11:00 AM - 01:00 PM (Morning Slot 2)</option>
                                    <option value="02:00 PM - 04:00 PM">02:00 PM - 04:00 PM (Afternoon Slot 1)</option>
                                    <option value="04:00 PM - 06:00 PM">04:00 PM - 06:00 PM (Afternoon Slot 2)</option>
                                </select>
                            </div>

                            <!-- Issue Description -->
                            <div class="col-12">
                                <label for="issueDescription" class="form-label small fw-semibold">Describe Issues / Requests</label>
                                <textarea class="form-control" id="issueDescription" name="issueDescription" rows="4" 
                                          placeholder="e.g. Engine oil replacement due, squeaking front brakes, check tire pressure, AC not cooling efficiently..."></textarea>
                            </div>
                        </div>

                        <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
                            <a href="${pageContext.request.contextPath}/customer/bookings" class="btn btn-light px-4">Cancel</a>
                            <button type="submit" class="btn btn-primary-vmss px-4 shadow-sm">
                                <i class="bi bi-calendar-check me-1"></i> Confirm & Book Slot
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Set minimum date to tomorrow automatically
    document.addEventListener("DOMContentLoaded", function() {
        const dateInput = document.getElementById("appointmentDate");
        if (dateInput) {
            const tomorrow = new Date();
            tomorrow.setDate(tomorrow.getDate() + 1);
            dateInput.min = tomorrow.toISOString().split("T")[0];
            dateInput.value = tomorrow.toISOString().split("T")[0];
        }
    });
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
