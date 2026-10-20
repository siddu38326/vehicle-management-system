<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Customer Registration" />
</jsp:include>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="card shadow-sm border-0 rounded-4">
                <div class="card-body p-4 p-md-5">
                    <div class="text-center mb-4">
                        <div class="d-inline-flex align-items-center justify-content-center bg-primary bg-opacity-10 text-primary rounded-circle p-3 mb-2">
                            <i class="bi bi-person-plus fs-2"></i>
                        </div>
                        <h3 class="fw-bold text-dark">Create Account</h3>
                        <p class="text-muted small">Register as a customer to manage vehicles and book services</p>
                    </div>

                    <form action="${pageContext.request.contextPath}/register" method="POST">
                        <div class="mb-3">
                            <label for="fullName" class="form-label small fw-semibold">Full Name</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-person"></i></span>
                                <input type="text" class="form-control" id="fullName" name="fullName" value="${fullName}" placeholder="e.g. John Doe" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="email" class="form-label small fw-semibold">Email Address</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-envelope"></i></span>
                                <input type="email" class="form-control" id="email" name="email" value="${email}" placeholder="name@example.com" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="phone" class="form-label small fw-semibold">Phone Number</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-phone"></i></span>
                                <input type="tel" class="form-control" id="phone" name="phone" value="${phone}" placeholder="10-digit mobile number" pattern="[0-9]{10,15}" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="password" class="form-label small fw-semibold">Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-lock"></i></span>
                                <input type="password" class="form-control" id="password" name="password" placeholder="At least 6 characters" minlength="6" required>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="confirmPassword" class="form-label small fw-semibold">Confirm Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-lock-fill"></i></span>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Repeat password" minlength="6" required>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary-vmss w-100 py-2 mb-3 shadow-sm">
                            Complete Registration
                        </button>
                    </form>

                    <div class="text-center mt-3">
                        <p class="small text-muted mb-0">Already registered? <a href="${pageContext.request.contextPath}/login" class="text-decoration-none fw-semibold text-warning">Sign In</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
