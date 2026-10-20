<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Admin Profile" />
</jsp:include>

<div class="container py-4">
    <div class="row">
        <div class="col-lg-3">
            <jsp:include page="/WEB-INF/views/admin/sidebar.jsp">
                <jsp:param name="active" value="profile" />
            </jsp:include>
        </div>

        <div class="col-lg-9">
            <div class="row g-4">
                <!-- Update Admin Profile Details -->
                <div class="col-md-6">
                    <div class="card border-0 shadow-sm rounded-4 h-100 p-4 bg-white">
                        <h5 class="fw-bold text-dark border-bottom pb-2 mb-4">
                            <i class="bi bi-person-gear text-warning me-2"></i> Administrator Profile
                        </h5>
                        <form action="${pageContext.request.contextPath}/admin/profile/update" method="POST">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">

                            <div class="mb-3">
                                <label for="fullName" class="form-label small fw-semibold">Administrator Name</label>
                                <input type="text" class="form-control" id="fullName" name="fullName" value="${sessionScope.currentUser.fullName}" required>
                            </div>

                            <div class="mb-3">
                                <label for="email" class="form-label small fw-semibold">Email Address (System Login)</label>
                                <input type="email" class="form-control" id="email" value="${sessionScope.currentUser.email}" readonly>
                                <div class="form-text">System administrator primary credential.</div>
                            </div>

                            <div class="mb-4">
                                <label for="phone" class="form-label small fw-semibold">Direct Phone / Hotline</label>
                                <input type="tel" class="form-control" id="phone" name="phone" value="${sessionScope.currentUser.phone}" required>
                            </div>

                            <button type="submit" class="btn btn-navy w-100">
                                <i class="bi bi-check-circle me-1"></i> Save Changes
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Change Admin Password -->
                <div class="col-md-6">
                    <div class="card border-0 shadow-sm rounded-4 h-100 p-4 bg-white">
                        <h5 class="fw-bold text-dark border-bottom pb-2 mb-4">
                            <i class="bi bi-shield-lock text-warning me-2"></i> Security Credentials
                        </h5>
                        <form action="${pageContext.request.contextPath}/admin/profile/password" method="POST">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">

                            <div class="mb-3">
                                <label for="currentPassword" class="form-label small fw-semibold">Current Password</label>
                                <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                            </div>

                            <div class="mb-3">
                                <label for="newPassword" class="form-label small fw-semibold">New Administrator Password</label>
                                <input type="password" class="form-control" id="newPassword" name="newPassword" minlength="6" required>
                            </div>

                            <div class="mb-4">
                                <label for="confirmPassword" class="form-label small fw-semibold">Confirm New Password</label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" minlength="6" required>
                            </div>

                            <button type="submit" class="btn btn-primary-vmss w-100">
                                <i class="bi bi-key me-1"></i> Update Security Password
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
