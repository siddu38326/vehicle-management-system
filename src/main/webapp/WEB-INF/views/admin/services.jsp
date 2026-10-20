<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Service Packages Management" />
</jsp:include>

<div class="container py-4">
    <div class="row">
        <div class="col-lg-3">
            <jsp:include page="/WEB-INF/views/admin/sidebar.jsp">
                <jsp:param name="active" value="services" />
            </jsp:include>
        </div>

        <div class="col-lg-9">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="fw-bold m-0 text-dark">Service Packages</h3>
                    <p class="text-muted small m-0">Define catalog offerings, labor rates, and vehicle compatibility</p>
                </div>
                <button type="button" class="btn btn-primary-vmss btn-sm" data-bs-toggle="modal" data-bs-target="#newServiceModal">
                    <i class="bi bi-plus-lg me-1"></i> Add Service Package
                </button>
            </div>

            <!-- Services Table -->
            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light small">
                                <tr>
                                    <th>ID</th>
                                    <th>Service Name</th>
                                    <th>Vehicle Category</th>
                                    <th>Base Rate</th>
                                    <th>Duration</th>
                                    <th>Status</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="s" items="${services}">
                                    <tr>
                                        <td class="fw-bold">#${s.serviceId}</td>
                                        <td>
                                            <div class="fw-semibold text-dark">${s.serviceName}</div>
                                            <div class="text-muted small text-truncate" style="max-width: 250px;">${s.description}</div>
                                        </td>
                                        <td><span class="badge bg-light text-dark border">${s.vehicleType}</span></td>
                                        <td class="fw-bold text-success">₹${s.basePrice}</td>
                                        <td>${s.estimatedDuration}</td>
                                        <td>
                                            <span class="badge ${s.active ? 'bg-success' : 'bg-secondary'}">${s.active ? 'Active' : 'Inactive'}</span>
                                        </td>
                                        <td class="text-end">
                                            <div class="btn-group btn-group-sm">
                                                <button type="button" class="btn btn-outline-secondary py-0 px-2" data-bs-toggle="modal" data-bs-target="#editServiceModal${s.serviceId}" title="Edit Service">
                                                    <i class="bi bi-pencil"></i>
                                                </button>
                                                <form action="${pageContext.request.contextPath}/admin/services/toggle" method="POST" class="d-inline">
                                                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                                    <input type="hidden" name="serviceId" value="${s.serviceId}">
                                                    <input type="hidden" name="active" value="${!s.active}">
                                                    <button type="submit" class="btn ${s.active ? 'btn-outline-danger' : 'btn-outline-success'} py-0 px-2" title="${s.active ? 'Deactivate' : 'Activate'}">
                                                        <i class="bi ${s.active ? 'bi-slash-circle' : 'bi-check-circle'}"></i>
                                                    </button>
                                                </form>
                                            </div>

                                            <!-- Edit Service Modal -->
                                            <div class="modal fade text-start" id="editServiceModal${s.serviceId}" tabindex="-1">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square text-warning me-2"></i>Edit Service Package</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <form action="${pageContext.request.contextPath}/admin/services/update" method="POST">
                                                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                                            <input type="hidden" name="serviceId" value="${s.serviceId}">

                                                            <div class="modal-body">
                                                                <div class="mb-3">
                                                                    <label class="form-label small fw-semibold">Service Name</label>
                                                                    <input type="text" name="serviceName" class="form-control" value="${s.serviceName}" required>
                                                                </div>

                                                                <div class="mb-3">
                                                                    <label class="form-label small fw-semibold">Vehicle Compatibility</label>
                                                                    <select name="vehicleType" class="form-select" required>
                                                                        <option value="All" ${s.vehicleType == 'All' ? 'selected' : ''}>All Vehicle Types</option>
                                                                        <option value="Four-Wheeler" ${s.vehicleType == 'Four-Wheeler' ? 'selected' : ''}>Four-Wheeler</option>
                                                                        <option value="Two-Wheeler" ${s.vehicleType == 'Two-Wheeler' ? 'selected' : ''}>Two-Wheeler</option>
                                                                    </select>
                                                                </div>

                                                                <div class="row g-2 mb-3">
                                                                    <div class="col-6">
                                                                        <label class="form-label small fw-semibold">Base Price (INR)</label>
                                                                        <input type="number" step="0.01" min="0" name="basePrice" class="form-control" value="${s.basePrice}" required>
                                                                    </div>
                                                                    <div class="col-6">
                                                                        <label class="form-label small fw-semibold">Duration</label>
                                                                        <input type="text" name="estimatedDuration" class="form-control" value="${s.estimatedDuration}" required>
                                                                    </div>
                                                                </div>

                                                                <div class="mb-3">
                                                                    <label class="form-label small fw-semibold">Description</label>
                                                                    <textarea name="description" class="form-control" rows="3">${s.description}</textarea>
                                                                </div>

                                                                <div class="mb-3">
                                                                    <label class="form-label small fw-semibold">Status</label>
                                                                    <select name="active" class="form-select">
                                                                        <option value="true" ${s.active ? 'selected' : ''}>Active</option>
                                                                        <option value="false" ${!s.active ? 'selected' : ''}>Inactive</option>
                                                                    </select>
                                                                </div>
                                                            </div>

                                                            <div class="modal-footer">
                                                                <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                                                                <button type="submit" class="btn btn-navy">Save Changes</button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
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

<!-- Modal for New Service -->
<div class="modal fade" id="newServiceModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold"><i class="bi bi-tools text-warning me-2"></i>New Service Package</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/services/create" method="POST">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">

                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Service Name *</label>
                        <input type="text" name="serviceName" class="form-control" placeholder="e.g. Brake Pad Replacement" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Vehicle Compatibility *</label>
                        <select name="vehicleType" class="form-select" required>
                            <option value="All">All Vehicle Types</option>
                            <option value="Four-Wheeler">Four-Wheeler (Cars/SUVs)</option>
                            <option value="Two-Wheeler">Two-Wheeler (Bikes/Scooters)</option>
                        </select>
                    </div>

                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Base Price (INR) *</label>
                            <input type="number" step="0.01" min="0" name="basePrice" class="form-control" placeholder="999.00" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Estimated Duration *</label>
                            <input type="text" name="estimatedDuration" class="form-control" placeholder="1-2 hours" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Procedure Description</label>
                        <textarea name="description" class="form-control" rows="3" placeholder="Explain the inspection criteria, fluid replacements, and safety checks..."></textarea>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary-vmss">Save Package</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
