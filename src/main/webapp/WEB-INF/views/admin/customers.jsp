<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Customer Accounts" />
</jsp:include>

<div class="container py-4">
    <div class="row">
        <div class="col-lg-3">
            <jsp:include page="/WEB-INF/views/admin/sidebar.jsp">
                <jsp:param name="active" value="customers" />
            </jsp:include>
        </div>

        <div class="col-lg-9">
            <div class="mb-4">
                <h3 class="fw-bold m-0 text-dark">Customer Accounts</h3>
                <p class="text-muted small m-0">Directory of registered vehicle owners and contact records</p>
            </div>

            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light small">
                                <tr>
                                    <th>User ID</th>
                                    <th>Full Name</th>
                                    <th>Email Address</th>
                                    <th>Phone</th>
                                    <th>Status</th>
                                    <th>Member Since</th>
                                    <th class="text-end">Account Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="c" items="${customers}">
                                    <tr>
                                        <td class="fw-bold">#USR-${c.userId}</td>
                                        <td class="fw-semibold text-dark">${c.fullName}</td>
                                        <td>${c.email}</td>
                                        <td>${c.phone}</td>
                                        <td>
                                            <span class="badge ${c.active ? 'bg-success' : 'bg-secondary'}">${c.active ? 'Active' : 'Suspended'}</span>
                                        </td>
                                        <td class="text-secondary small">${c.createdAt}</td>
                                        <td class="text-end">
                                            <form action="${pageContext.request.contextPath}/admin/customers/toggle" method="POST" class="d-inline" onsubmit="return confirm('Change status for ${c.fullName}?');">
                                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                                <input type="hidden" name="userId" value="${c.userId}">
                                                <input type="hidden" name="active" value="${!c.active}">
                                                <button type="submit" class="btn btn-sm ${c.active ? 'btn-outline-danger' : 'btn-outline-success'} py-0 px-2">
                                                    <i class="bi ${c.active ? 'bi-person-x' : 'bi-person-check'} me-1"></i> ${c.active ? 'Suspend' : 'Activate'}
                                                </button>
                                            </form>
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
