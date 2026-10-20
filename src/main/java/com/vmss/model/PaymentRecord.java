package com.vmss.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class PaymentRecord implements Serializable {
    private static final long serialVersionUID = 1L;

    private int paymentId;
    private int invoiceId;
    private BigDecimal amount;
    private String paymentMethod; // Cash, Card, UPI, NetBanking, Demo Simulation
    private String paymentReference;
    private Timestamp paymentDate;
    private String paymentStatus; // SUCCESS, PENDING, FAILED

    public PaymentRecord() {}

    public PaymentRecord(int paymentId, int invoiceId, BigDecimal amount, String paymentMethod, String paymentReference, Timestamp paymentDate, String paymentStatus) {
        this.paymentId = paymentId;
        this.invoiceId = invoiceId;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.paymentReference = paymentReference;
        this.paymentDate = paymentDate;
        this.paymentStatus = paymentStatus;
    }

    public int getPaymentId() { return paymentId; }
    public void setPaymentId(int paymentId) { this.paymentId = paymentId; }

    public int getInvoiceId() { return invoiceId; }
    public void setInvoiceId(int invoiceId) { this.invoiceId = invoiceId; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getPaymentReference() { return paymentReference; }
    public void setPaymentReference(String paymentReference) { this.paymentReference = paymentReference; }

    public Timestamp getPaymentDate() { return paymentDate; }
    public void setPaymentDate(Timestamp paymentDate) { this.paymentDate = paymentDate; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
}
