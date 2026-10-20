package com.vmss.controller;

import com.vmss.service.VehicleService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet({"", "/home", "/index.jsp", "/services", "/about"})
public class HomeServlet extends HttpServlet {

    private final VehicleService vehicleService = new VehicleService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        try {
            if ("/services".equals(path)) {
                req.setAttribute("services", vehicleService.getActiveServices());
                req.getRequestDispatcher("/WEB-INF/views/common/services.jsp").forward(req, resp);
            } else if ("/about".equals(path)) {
                req.getRequestDispatcher("/WEB-INF/views/common/about.jsp").forward(req, resp);
            } else {
                // Home page / landing
                req.setAttribute("featuredServices", vehicleService.getActiveServices());
                req.getRequestDispatcher("/WEB-INF/views/common/home.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("errorMessage", "Error loading data: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/common/home.jsp").forward(req, resp);
        }
    }
}
