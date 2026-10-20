<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="My Invoices" />
</jsp:include>

<div class="container py-4">
    <div class="row">
        <div class="col-lg-3">
            <jsp:include page="/WEB-INF/views/customer/sidebar.jsp">
                <jsp:param name="active" value="invoices" />
            </jsp:include>
        </div>

        <div class="col-lg-9">
            <div class="mb-4">
                <h3 class="fw-bold m-0">Invoices & Billing</h3>
                <p class="text-muted small m-0">View generated bills, itemized breakdowns, and simulated payments</p>
            </div>

            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty invoices}">
                            <div class="text-center py-5">
                                <i class="bi bi-receipt-cutoff display-4 text-secondary opacity-50 mb-3 d-block"></i>
                                <h5 class="fw-bold">No Invoices Found</h5>
                                <p class="text-muted small">Invoices generated upon completion of services will appear here.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light small">
                                        <tr>
                                            <th>Invoice #</th>
                                            <th>Vehicle</th>
                                            <th>Service</th>
                                            <th>Invoice Date</th>
                                            <th>Total (inc. GST)</th>
                                            <th>Status</th>
                                            <th class="text-end">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="inv" items="${invoices}">
                                            <tr>
                                                <td class="fw-bold text-dark">${inv.invoiceNumber}</td>
                                                <td>${inv.vehicleRegNo}</td>
                                                <td>${inv.serviceName}</td>
                                                <td>${inv.invoiceDate}</td>
                                                <td class="fw-bold text-success">₹${inv.totalAmount}</td>
                                                <td><span class="badge ${inv.badgeClass}">${inv.paymentStatus}</span></td>
                                                <td class="text-end">
                                                    <a href="${pageContext.request.contextPath}/customer/invoices/details?id=${inv.invoiceId}" class="btn btn-sm btn-outline-dark">
                                                        <i class="bi bi-file-earmark-text me-1"></i> View Bill
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
