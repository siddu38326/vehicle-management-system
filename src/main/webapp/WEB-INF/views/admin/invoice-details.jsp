<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Manage Invoice - ${invoice.invoiceNumber}" />
</jsp:include>

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3 no-print">
        <a href="${pageContext.request.contextPath}/admin/invoices" class="btn btn-outline-secondary btn-sm">
            <i class="bi bi-arrow-left me-1"></i> Back to Invoices
        </a>
        <div class="d-flex gap-2">
            <button onclick="window.print()" class="btn btn-outline-dark btn-sm">
                <i class="bi bi-printer me-1"></i> Print Invoice
            </button>
            <c:if test="${invoice.paymentStatus != 'PAID'}">
                <button type="button" class="btn btn-success btn-sm" data-bs-toggle="modal" data-bs-target="#adminPaymentModal">
                    <i class="bi bi-cash-stack me-1"></i> Record Customer Payment
                </button>
            </c:if>
        </div>
    </div>

    <!-- Printable Invoice Container -->
    <div id="printable-invoice" class="card border shadow-sm rounded-4 p-5 bg-white mb-4">
        <div class="d-flex justify-content-between align-items-start border-bottom pb-4 mb-4">
            <div>
                <h3 class="fw-bold text-dark d-flex align-items-center gap-2 m-0">
                    <i class="bi bi-gear-wide-connected text-warning"></i> VMSS AUTOMOTIVE
                </h3>
                <p class="text-secondary small mt-1 mb-0">Authorized Multi-Brand Vehicle Care & Diagnostics Center</p>
                <div class="text-secondary small">GSTIN: 29AAAAA0000A1Z5 | Reg: DL-KA-2026-9812</div>
            </div>
            <div class="text-end">
                <span class="badge bg-light text-dark border px-3 py-2 fs-6 mb-2">TAX INVOICE</span>
                <div class="fw-bold text-dark fs-5">${invoice.invoiceNumber}</div>
                <div class="text-secondary small">Date: ${invoice.invoiceDate}</div>
            </div>
        </div>

        <div class="row g-4 mb-4 border-bottom pb-4">
            <div class="col-6">
                <h6 class="text-uppercase text-secondary small fw-bold mb-2">Customer Details:</h6>
                <div class="fw-bold text-dark fs-6">${invoice.customerName}</div>
                <div class="text-secondary small"><i class="bi bi-envelope me-1"></i> ${invoice.customerEmail}</div>
                <div class="text-secondary small"><i class="bi bi-phone me-1"></i> ${invoice.customerPhone}</div>
            </div>
            <div class="col-6 text-end">
                <h6 class="text-uppercase text-secondary small fw-bold mb-2">Vehicle Details:</h6>
                <div class="fw-bold text-dark fs-6">${invoice.vehicleRegNo}</div>
                <div class="text-secondary small">${invoice.vehicleBrand} ${invoice.vehicleModel}</div>
                <div class="text-secondary small">Service: ${invoice.serviceName}</div>
            </div>
        </div>

        <div class="mb-4">
            <h6 class="fw-bold text-dark mb-1">Service & Repair Report:</h6>
            <p class="text-secondary small bg-light p-3 rounded-3 mb-0">
                ${invoice.workDescription}
            </p>
        </div>

        <table class="table table-bordered mb-4 align-middle">
            <thead class="table-light small">
                <tr>
                    <th>Item Description</th>
                    <th class="text-center" style="width: 15%;">Type</th>
                    <th class="text-end" style="width: 25%;">Amount (INR)</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
                        <div class="fw-semibold">Replacement Parts & Consumables</div>
                    </td>
                    <td class="text-center"><span class="badge bg-light text-secondary border">Parts</span></td>
                    <td class="text-end fw-semibold">₹${invoice.partsCost}</td>
                </tr>
                <tr>
                    <td>
                        <div class="fw-semibold">Technician & Workshop Labor Charges</div>
                    </td>
                    <td class="text-center"><span class="badge bg-light text-secondary border">Labor</span></td>
                    <td class="text-end fw-semibold">₹${invoice.laborCost}</td>
                </tr>
            </tbody>
        </table>

        <div class="row justify-content-end mb-4">
            <div class="col-md-5">
                <table class="table table-sm table-borderless small mb-0">
                    <tr>
                        <td class="text-secondary">Subtotal:</td>
                        <td class="text-end fw-semibold">₹${invoice.subtotal}</td>
                    </tr>
                    <tr>
                        <td class="text-secondary">Discount:</td>
                        <td class="text-end text-danger">- ₹${invoice.discount}</td>
                    </tr>
                    <tr>
                        <td class="text-secondary">GST (${invoice.taxRate}%):</td>
                        <td class="text-end fw-semibold">₹${invoice.taxAmount}</td>
                    </tr>
                    <tr class="border-top">
                        <td class="fw-bold text-dark fs-6 pt-2">Total Amount:</td>
                        <td class="text-end fw-bold text-success fs-5 pt-2">₹${invoice.totalAmount}</td>
                    </tr>
                    <tr>
                        <td class="text-secondary pt-2">Payment Status:</td>
                        <td class="text-end pt-2">
                            <span class="badge ${invoice.badgeClass} fs-6 px-3">${invoice.paymentStatus}</span>
                        </td>
                    </tr>
                </table>
            </div>
        </div>

        <!-- Payment History -->
        <c:if test="${not empty payments}">
            <div class="border-top pt-3">
                <h6 class="fw-bold small text-dark mb-2"><i class="bi bi-credit-card-2-front text-success me-1"></i> Recorded Payments:</h6>
                <table class="table table-sm table-striped small mb-0">
                    <thead>
                        <tr>
                            <th>Ref Code</th>
                            <th>Method</th>
                            <th>Amount</th>
                            <th>Timestamp</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${payments}">
                            <tr>
                                <td><code>${p.paymentReference}</code></td>
                                <td>${p.paymentMethod}</td>
                                <td class="fw-bold text-success">₹${p.amount}</td>
                                <td>${p.paymentDate}</td>
                                <td><span class="badge bg-success">${p.paymentStatus}</span></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
    </div>
</div>

<!-- Modal for Admin Recording Customer Payment -->
<div class="modal fade" id="adminPaymentModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold"><i class="bi bi-cash-stack text-success me-2"></i>Record Customer Payment</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/invoices/record-payment" method="POST">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                <input type="hidden" name="invoiceId" value="${invoice.invoiceId}">

                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Amount Received</label>
                        <div class="input-group">
                            <span class="input-group-text">₹</span>
                            <input type="number" step="0.01" name="amount" class="form-control fw-bold" value="${invoice.totalAmount}" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Payment Mode</label>
                        <select name="paymentMethod" class="form-select" required>
                            <option value="Cash" selected>Cash at Bay</option>
                            <option value="UPI">UPI POS QR</option>
                            <option value="Card">Card Swipe Terminal</option>
                            <option value="NetBanking">Direct Bank Transfer</option>
                            <option value="Demo Simulation">Demo Simulation</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Receipt / Reference No.</label>
                        <input type="text" name="paymentReference" class="form-control" value="RCP-${invoice.invoiceId}-${System.currentTimeMillis() % 100000}">
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-success">Save Payment & Mark Paid</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
