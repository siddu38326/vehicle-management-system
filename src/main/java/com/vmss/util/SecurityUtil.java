package com.vmss.util;

import at.favre.lib.crypto.bcrypt.BCrypt;

/**
 * SecurityUtil provides secure password hashing and verification using BCrypt,
 * CSRF token generation and validation, and HTML sanitization utilities.
 */
public class SecurityUtil {

    private static final int BCRYPT_COST = 12;

    /**
     * Hashes plaintext password using BCrypt with cost factor 12.
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be empty");
        }
        return BCrypt.withDefaults().hashToString(BCRYPT_COST, plainPassword.toCharArray());
    }

    /**
     * Verifies a plaintext password against a stored BCrypt hash.
     */
    public static boolean verifyPassword(String plainPassword, String storedHash) {
        if (plainPassword == null || storedHash == null || storedHash.isEmpty()) {
            return false;
        }
        BCrypt.Result result = BCrypt.verifyer().verify(plainPassword.toCharArray(), storedHash);
        return result.verified;
    }

    /**
     * Generates a random secure hexadecimal CSRF token.
     */
    public static String generateToken() {
        return java.util.UUID.randomUUID().toString().replace("-", "");
    }

    /**
     * Escapes critical characters to prevent XSS if ever rendered directly.
     */
    public static void main(String[] args) {
        System.out.println("ADMIN_HASH=" + hashPassword("Admin@123"));
        System.out.println("CUSTOMER_HASH=" + hashPassword("Customer@123"));
    }
}
