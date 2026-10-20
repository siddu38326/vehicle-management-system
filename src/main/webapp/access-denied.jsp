<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Access Denied" />
</jsp:include>

<div class="container py-5 text-center">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card border-0 shadow-sm p-5 rounded-4">
                <i class="bi bi-shield-slash-fill text-danger display-1 mb-3"></i>
                <h3 class="fw-bold text-danger">403 - Access Denied</h3>
                <p class="text-secondary mb-4">
                    You do not have the required permissions or authorization level to access this resource or record.
                </p>
                <div class="d-flex justify-content-center gap-3">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-navy px-4">
                        <i class="bi bi-house me-1"></i> Return Home
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
