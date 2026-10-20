<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Payment Transactions" />
</jsp:include>

<div class="container py-4">
    <div class="row">
        <div class="col-lg-3">
            <jsp:include page="/WEB-INF/views/admin/sidebar.jsp">
                <jsp:param name="active" value="payments" />
            </jsp:include>
        </div>

        <div class="col-lg-9">
            <div class="mb-4">
                <h3 class="fw-bold m-0 text-dark">Payment Transactions</h3>
                <p class="text-muted small m-0">Audit log of all settled invoices, methods, and reference identifiers</p>
            </div>

            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light small">
                                <tr>
                                    <th>Payment ID</th>
                                    <th>Invoice ID</th>
                                    <th>Method</th>
                                    <th>Reference No.</th>
                                    <th>Amount Paid</th>
                                    <th>Status</th>
                                    <th>Timestamp</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${payments}">
                                    <tr>
                                        <td class="fw-bold">#PAY-${p.paymentId}</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/admin/invoices/details?id=${p.invoiceId}" class="text-decoration-none">
                                                Invoice #${p.invoiceId}
                                            </a>
                                        </td>
                                        <td><span class="badge bg-light text-dark border">${p.paymentMethod}</span></td>
                                        <td><code>${p.paymentReference}</code></td>
                                        <td class="fw-bold text-success">₹${p.amount}</td>
                                        <td><span class="badge bg-success">${p.paymentStatus}</span></td>
                                        <td class="text-secondary small">${p.paymentDate}</td>
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
