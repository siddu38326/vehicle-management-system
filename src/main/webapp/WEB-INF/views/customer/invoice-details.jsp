<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Tax Invoice - ${invoice.invoiceNumber}" />
</jsp:include>

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3 no-print">
        <a href="${pageContext.request.contextPath}/customer/invoices" class="btn btn-outline-secondary btn-sm">
            <i class="bi bi-arrow-left me-1"></i> Back to Invoices
        </a>
        <div class="d-flex gap-2">
            <button onclick="window.print()" class="btn btn-outline-dark btn-sm">
                <i class="bi bi-printer me-1"></i> Print Tax Invoice
            </button>
            <c:if test="${invoice.paymentStatus != 'PAID'}">
                <button type="button" class="btn btn-primary-vmss btn-sm" data-bs-toggle="modal" data-bs-target="#paymentModal">
                    <i class="bi bi-credit-card me-1"></i> Simulate Payment
                </button>
            </c:if>
        </div>
    </div>

    <!-- Printable Invoice Container -->
    <div id="printable-invoice" class="card border shadow-sm rounded-4 p-5 bg-white">
        <!-- Invoice Header -->
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

        <!-- Customer & Vehicle Info Grid -->
        <div class="row g-4 mb-4 border-bottom pb-4">
            <div class="col-6">
                <h6 class="text-uppercase text-secondary small fw-bold mb-2">Billed To (Customer):</h6>
                <div class="fw-bold text-dark fs-6">${invoice.customerName}</div>
                <div class="text-secondary small"><i class="bi bi-envelope me-1"></i> ${invoice.customerEmail}</div>
                <div class="text-secondary small"><i class="bi bi-phone me-1"></i> ${invoice.customerPhone}</div>
            </div>
            <div class="col-6 text-end">
                <h6 class="text-uppercase text-secondary small fw-bold mb-2">Vehicle Specifications:</h6>
                <div class="fw-bold text-dark fs-6">${invoice.vehicleRegNo}</div>
                <div class="text-secondary small">${invoice.vehicleBrand} ${invoice.vehicleModel}</div>
                <div class="text-secondary small">Service Type: ${invoice.serviceName}</div>
            </div>
        </div>

        <!-- Work Performed Overview -->
        <div class="mb-4">
            <h6 class="fw-bold text-dark mb-1">Work Done & Maintenance Summary:</h6>
            <p class="text-secondary small bg-light p-3 rounded-3 mb-0">
                ${invoice.workDescription}
            </p>
        </div>

        <!-- Itemized Charges Table -->
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
                        <div class="fw-semibold">Replacement Parts & Genuine Components</div>
                        <div class="text-muted small">Standard OE/OEM specification fluids and consumables</div>
                    </td>
                    <td class="text-center"><span class="badge bg-light text-secondary border">Spares</span></td>
                    <td class="text-end fw-semibold">₹${invoice.partsCost}</td>
                </tr>
                <tr>
                    <td>
                        <div class="fw-semibold">Diagnostic & Technical Labor Charges</div>
                        <div class="text-muted small">Certified technician bay charges, inspection, and testing</div>
                    </td>
                    <td class="text-center"><span class="badge bg-light text-secondary border">Labor</span></td>
                    <td class="text-end fw-semibold">₹${invoice.laborCost}</td>
                </tr>
            </tbody>
        </table>

        <!-- Calculations Summary -->
        <div class="row justify-content-end mb-4">
            <div class="col-md-5">
                <table class="table table-sm table-borderless small mb-0">
                    <tr>
                        <td class="text-secondary">Subtotal (Parts + Labor):</td>
                        <td class="text-end fw-semibold">₹${invoice.subtotal}</td>
                    </tr>
                    <tr>
                        <td class="text-secondary">Special Discount / Promotion:</td>
                        <td class="text-end text-danger">- ₹${invoice.discount}</td>
                    </tr>
                    <tr>
                        <td class="text-secondary">Applicable GST (${invoice.taxRate}%):</td>
                        <td class="text-end fw-semibold">₹${invoice.taxAmount}</td>
                    </tr>
                    <tr class="border-top">
                        <td class="fw-bold text-dark fs-6 pt-2">Final Invoice Total:</td>
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

        <!-- Simulated Payment Records -->
        <c:if test="${not empty payments}">
            <div class="border-top pt-3 mb-4">
                <h6 class="fw-bold small text-dark mb-2"><i class="bi bi-credit-card-2-front text-success me-1"></i> Payment Transaction Records:</h6>
                <div class="table-responsive">
                    <table class="table table-sm table-striped small mb-0">
                        <thead>
                            <tr>
                                <th>Txn Ref</th>
                                <th>Method</th>
                                <th>Paid Amount</th>
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
            </div>
        </c:if>

        <div class="border-top pt-3 text-center text-secondary small">
            <p class="m-0">Thank you for servicing your vehicle with VMSS Automotive.</p>
            <p class="text-muted" style="font-size:0.75rem;">This is a computer-generated tax invoice verified by the service manager.</p>
        </div>
    </div>
</div>

<!-- Modal for Simulated Payment -->
<div class="modal fade" id="paymentModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold"><i class="bi bi-wallet2 text-warning me-2"></i>Pay Bill (Simulation Mode)</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/customer/invoices/pay" method="POST">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                <input type="hidden" name="invoiceId" value="${invoice.invoiceId}">

                <div class="modal-body">
                    <div class="alert alert-info small mb-3">
                        <i class="bi bi-info-circle me-1"></i> <strong>Academic Demonstration:</strong> No actual card or bank charges will be incurred.
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Amount to Pay</label>
                        <div class="input-group">
                            <span class="input-group-text">₹</span>
                            <input type="text" class="form-control fw-bold" value="${invoice.totalAmount}" readonly>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="paymentMethod" class="form-label small fw-semibold">Select Payment Gateway / Method</label>
                        <select class="form-select" id="paymentMethod" name="paymentMethod" required>
                            <option value="UPI" selected>UPI (Google Pay / PhonePe / Paytm)</option>
                            <option value="Card">Credit / Debit Card</option>
                            <option value="NetBanking">Net Banking</option>
                            <option value="Cash">Cash at Garage Bay</option>
                            <option value="Demo Simulation">Demo Simulation Check</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="paymentReference" class="form-label small fw-semibold">Transaction / UTR Reference</label>
                        <input type="text" class="form-control" id="paymentReference" name="paymentReference" value="UPI-SIM-${invoice.invoiceId}9845">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary-vmss">
                        <i class="bi bi-check-circle me-1"></i> Authorize & Mark as Paid
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
