<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Login" />
</jsp:include>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card shadow-sm border-0 rounded-4">
                <div class="card-body p-4 p-md-5">
                    <div class="text-center mb-4">
                        <div class="d-inline-flex align-items-center justify-content-center bg-warning bg-opacity-10 text-warning rounded-circle p-3 mb-2">
                            <i class="bi bi-box-arrow-in-right fs-2"></i>
                        </div>
                        <h3 class="fw-bold text-dark">Welcome Back</h3>
                        <p class="text-muted small">Sign in to manage vehicles, appointments, or administration</p>
                    </div>

                    <form action="${pageContext.request.contextPath}/login" method="POST">
                        <div class="mb-3">
                            <label for="email" class="form-label small fw-semibold">Email Address</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-envelope"></i></span>
                                <input type="email" class="form-control" id="email" name="email" value="${email}" placeholder="name@example.com" required>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="password" class="form-label small fw-semibold">Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-lock"></i></span>
                                <input type="password" class="form-control" id="password" name="password" placeholder="••••••••" required>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary-vmss w-100 py-2 mb-3 shadow-sm">
                            Sign In to Portal
                        </button>
                    </form>

                    <!-- Academic Demonstration Test Credentials Box -->
                    <div class="card bg-light border-0 p-3 rounded-3 mt-3">
                        <h6 class="fw-bold small text-dark mb-2"><i class="bi bi-key-fill text-warning me-1"></i> Demo Credentials:</h6>
                        <div class="small text-secondary mb-1">
                            <strong>Admin:</strong> <code>admin@vmss.com</code> / <code>Admin@123</code>
                        </div>
                        <div class="small text-secondary">
                            <strong>Customer:</strong> <code>rahul@gmail.com</code> / <code>Customer@123</code>
                        </div>
                    </div>

                    <div class="text-center mt-4">
                        <p class="small text-muted mb-0">Don't have an account? <a href="${pageContext.request.contextPath}/register" class="text-decoration-none fw-semibold text-warning">Create Account</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
