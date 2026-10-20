package com.vmss.filter;

import com.vmss.model.User;
import com.vmss.util.SecurityUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Authentication and Security Filter:
 * 1. Guarantees a valid CSRF token is present in the session.
 * 2. Enforces Role-Based Access Control (RBAC):
 *    - /admin/* requires an authenticated user with role == 'ADMIN'
 *    - /customer/* requires an authenticated user with role == 'CUSTOMER'
 * 3. Enforces CSRF token check on authenticated state-changing POST requests.
 * 4. Sets secure HTTP headers (X-Frame-Options, X-Content-Type-Options, etc.)
 */
@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        // Set security headers
        response.setHeader("X-Frame-Options", "DENY");
        response.setHeader("X-Content-Type-Options", "nosniff");
        response.setHeader("X-XSS-Protection", "1; mode=block");

        HttpSession session = request.getSession(true);
        if (session.getAttribute("csrfToken") == null) {
            session.setAttribute("csrfToken", SecurityUtil.generateToken());
        }

        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());

        // Allow static assets, error pages, and public endpoints
        if (path.startsWith("/assets/") || path.equals("/error.jsp") || path.equals("/access-denied.jsp") ||
            path.equals("/") || path.equals("/index.jsp") || path.equals("/login") || 
            path.equals("/register") || path.equals("/services") || path.equals("/about") ||
            path.equals("/logout")) {
            chain.doFilter(req, res);
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");

        // Admin paths protection
        if (path.startsWith("/admin/")) {
            if (currentUser == null) {
                session.setAttribute("errorMessage", "Please log in as an administrator to access this area.");
                response.sendRedirect(contextPath + "/login");
                return;
            }
            if (!currentUser.isAdmin()) {
                response.sendRedirect(contextPath + "/access-denied.jsp");
                return;
            }
        }

        // Customer paths protection
        if (path.startsWith("/customer/")) {
            if (currentUser == null) {
                session.setAttribute("errorMessage", "Please log in to access your customer portal.");
                response.sendRedirect(contextPath + "/login");
                return;
            }
            if (!currentUser.isCustomer() && !currentUser.isAdmin()) {
                response.sendRedirect(contextPath + "/access-denied.jsp");
                return;
            }
        }

        // CSRF verification on authenticated state-changing POST requests
        if ("POST".equalsIgnoreCase(request.getMethod()) && currentUser != null && !path.equals("/logout")) {
            String requestToken = request.getParameter("csrfToken");
            String sessionToken = (String) session.getAttribute("csrfToken");
            if (sessionToken == null || !sessionToken.equals(requestToken)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Security validation failed: Invalid or missing CSRF token.");
                return;
            }
        }

        chain.doFilter(req, res);
    }
}
