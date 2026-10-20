<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="title" value="Reports & Analytics" />
</jsp:include>

<div class="container py-4">
    <div class="row">
        <div class="col-lg-3">
            <jsp:include page="/WEB-INF/views/admin/sidebar.jsp">
                <jsp:param name="active" value="reports" />
            </jsp:include>
        </div>

        <div class="col-lg-9">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="fw-bold m-0 text-dark">Business Reports & Analytics</h3>
                    <p class="text-muted small m-0">Performance breakdown, revenue distribution, and workflow completion ratios</p>
                </div>
                <button onclick="window.print()" class="btn btn-outline-dark btn-sm">
                    <i class="bi bi-printer me-1"></i> Print Report
                </button>
            </div>

            <!-- Summary Financial & Workflow Metrics -->
            <div class="row g-3 mb-4">
                <div class="col-md-4">
                    <div class="card card-stat border-0 p-4 bg-white">
                        <span class="text-secondary small fw-semibold">Net Recorded Revenue</span>
                        <h2 class="fw-bold text-success mt-1 mb-0">₹${stats.totalRevenue}</h2>
                        <span class="text-muted small">From settled customer invoices</span>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card card-stat border-0 p-4 bg-white">
                        <span class="text-secondary small fw-semibold">Service Conversion Rate</span>
                        <h2 class="fw-bold text-primary mt-1 mb-0">
                            ${conversionRate}%
                        </h2>
                        <span class="text-muted small">${stats.completedAppointments} completed of ${stats.totalAppointments} total</span>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card card-stat border-0 p-4 bg-white">
                        <span class="text-secondary small fw-semibold">Active Customer Garage</span>
                        <h2 class="fw-bold text-dark mt-1 mb-0">${stats.totalVehicles}</h2>
                        <span class="text-muted small">Across ${stats.totalCustomers} registered accounts</span>
                    </div>
                </div>
            </div>

            <!-- Distribution Progress Bars -->
            <div class="card border-0 shadow-sm rounded-4 p-4 mb-4 bg-white">
                <h6 class="fw-bold text-dark border-bottom pb-2 mb-3">Service Pipeline Operational Distribution</h6>
                <div class="mb-3">
                    <div class="d-flex justify-content-between small mb-1">
                        <span>Completed Services (${stats.completedAppointments})</span>
                        <span class="fw-bold">${completedPct}%</span>
                    </div>
                    <div class="progress" style="height: 10px;">
                        <div class="progress-bar bg-success" style="width: ${completedWidth}%;"></div>
                    </div>
                </div>

                <div class="mb-3">
                    <div class="d-flex justify-content-between small mb-1">
                        <span>In Bay / Progress (${stats.inProgressAppointments})</span>
                        <span class="fw-bold">${inProgressPct}%</span>
                    </div>
                    <div class="progress" style="height: 10px;">
                        <div class="progress-bar bg-info" style="width: ${inProgressWidth}%;"></div>
                    </div>
                </div>

                <div class="mb-3">
                    <div class="d-flex justify-content-between small mb-1">
                        <span>Pending Review (${stats.pendingAppointments})</span>
                        <span class="fw-bold">${pendingPct}%</span>
                    </div>
                    <div class="progress" style="height: 10px;">
                        <div class="progress-bar bg-warning" style="width: ${pendingWidth}%;"></div>
                    </div>
                </div>

                <div class="mb-0">
                    <div class="d-flex justify-content-between small mb-1">
                        <span>Cancelled / Rejected (${stats.cancelledAppointments})</span>
                        <span class="fw-bold">${stats.totalAppointments > 0 ? String.format("%.0f", (stats.cancelledAppointments * 100.0) / stats.totalAppointments) : 0}%</span>
                    </div>
                    <div class="progress" style="height: 10px;">
                        <div class="progress-bar bg-secondary" style="width: ${cancelledWidth}%;"></div>
                    </div>
                </div>
            </div>

            <!-- Recent Invoices Summary in Report -->
            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-header bg-white py-3">
                    <h6 class="fw-bold m-0"><i class="bi bi-file-text text-warning me-2"></i>Invoice Settlement Ledger</h6>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light small">
                                <tr>
                                    <th>Invoice #</th>
                                    <th>Customer</th>
                                    <th>Subtotal</th>
                                    <th>GST (18%)</th>
                                    <th>Final Total</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="i" items="${invoices}">
                                    <tr>
                                        <td class="fw-bold">${i.invoiceNumber}</td>
                                        <td>${i.customerName}</td>
                                        <td>₹${i.subtotal}</td>
                                        <td>₹${i.taxAmount}</td>
                                        <td class="fw-bold text-success">₹${i.totalAmount}</td>
                                        <td><span class="badge ${i.badgeClass}">${i.paymentStatus}</span></td>
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
