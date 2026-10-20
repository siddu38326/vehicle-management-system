package com.vmss.dao;

import com.vmss.model.PaymentRecord;
import com.vmss.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    public List<PaymentRecord> findByInvoiceId(int invoiceId) throws SQLException {
        List<PaymentRecord> list = new ArrayList<>();
        String sql = "SELECT payment_id, invoice_id, amount, payment_method, payment_reference, payment_date, payment_status " +
                     "FROM payment_records WHERE invoice_id = ? ORDER BY payment_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PaymentRecord p = new PaymentRecord();
                    p.setPaymentId(rs.getInt("payment_id"));
                    p.setInvoiceId(rs.getInt("invoice_id"));
                    p.setAmount(rs.getBigDecimal("amount"));
                    p.setPaymentMethod(rs.getString("payment_method"));
                    p.setPaymentReference(rs.getString("payment_reference"));
                    p.setPaymentDate(rs.getTimestamp("payment_date"));
                    p.setPaymentStatus(rs.getString("payment_status"));
                    list.add(p);
                }
            }
        }
        return list;
    }

    public List<PaymentRecord> findAll() throws SQLException {
        List<PaymentRecord> list = new ArrayList<>();
        String sql = "SELECT payment_id, invoice_id, amount, payment_method, payment_reference, payment_date, payment_status " +
                     "FROM payment_records ORDER BY payment_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                PaymentRecord p = new PaymentRecord();
                p.setPaymentId(rs.getInt("payment_id"));
                p.setInvoiceId(rs.getInt("invoice_id"));
                p.setAmount(rs.getBigDecimal("amount"));
                p.setPaymentMethod(rs.getString("payment_method"));
                p.setPaymentReference(rs.getString("payment_reference"));
                p.setPaymentDate(rs.getTimestamp("payment_date"));
                p.setPaymentStatus(rs.getString("payment_status"));
                list.add(p);
            }
        }
        return list;
    }

    public boolean create(Connection conn, PaymentRecord payment) throws SQLException {
        String sql = "INSERT INTO payment_records (invoice_id, amount, payment_method, payment_reference, payment_status) " +
                     "VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, payment.getInvoiceId());
            ps.setBigDecimal(2, payment.getAmount());
            ps.setString(3, payment.getPaymentMethod());
            ps.setString(4, payment.getPaymentReference());
            ps.setString(5, payment.getPaymentStatus());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        payment.setPaymentId(rs.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }
}
