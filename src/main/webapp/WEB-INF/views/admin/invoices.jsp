<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Invoices & Billing" />
</jsp:include>

<div class="container py-4">
    <div class="row">
        <div class="col-lg-3">
            <jsp:include page="/WEB-INF/views/admin/sidebar.jsp">
                <jsp:param name="active" value="invoices" />
            </jsp:include>
        </div>

        <div class="col-lg-9">
            <div class="mb-4">
                <h3 class="fw-bold m-0 text-dark">Invoice Ledger</h3>
                <p class="text-muted small m-0">All generated bills, tax invoices, and payment statuses</p>
            </div>

            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light small">
                                <tr>
                                    <th>Invoice #</th>
                                    <th>Customer</th>
                                    <th>Vehicle</th>
                                    <th>Date</th>
                                    <th>Total Amount</th>
                                    <th>Status</th>
                                    <th class="text-end">Manage</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="inv" items="${invoices}">
                                    <tr>
                                        <td class="fw-bold text-dark">${inv.invoiceNumber}</td>
                                        <td>${inv.customerName}</td>
                                        <td>${inv.vehicleRegNo}</td>
                                        <td>${inv.invoiceDate}</td>
                                        <td class="fw-bold text-success">₹${inv.totalAmount}</td>
                                        <td><span class="badge ${inv.badgeClass}">${inv.paymentStatus}</span></td>
                                        <td class="text-end">
                                            <a href="${pageContext.request.contextPath}/admin/invoices/details?id=${inv.invoiceId}" class="btn btn-sm btn-outline-dark">
                                                Manage Bill
                                            </a>
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
