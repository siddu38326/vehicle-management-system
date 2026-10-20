<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="System Error" />
</jsp:include>

<div class="container py-5 text-center">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card border-0 shadow-sm p-5 rounded-4">
                <i class="bi bi-exclamation-triangle-fill text-warning display-1 mb-3"></i>
                <h3 class="fw-bold">Something went wrong</h3>
                <p class="text-secondary mb-4">
                    The application encountered an unexpected issue while processing your request.
                </p>
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-light border text-danger small text-start">
                        <strong>Details:</strong> ${errorMessage}
                    </div>
                </c:if>
                <div class="d-flex justify-content-center gap-3">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-primary-vmss px-4">
                        <i class="bi bi-house me-1"></i> Return Home
                    </a>
                    <button onclick="window.history.back()" class="btn btn-outline-secondary px-4">
                        <i class="bi bi-arrow-left me-1"></i> Go Back
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
