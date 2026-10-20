package com.vmss.listener;

import com.vmss.util.DBConnection;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.logging.Logger;

@WebListener
public class AppContextListener implements ServletContextListener {

    private static final Logger LOGGER = Logger.getLogger(AppContextListener.class.getName());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        LOGGER.info("VMSS Web Application initializing... checking database connection.");
        try {
            DBConnection.initialize();
            LOGGER.info("VMSS Database layer initialized successfully (H2 fallback active: " + DBConnection.isH2Fallback() + ")");
        } catch (Exception e) {
            LOGGER.severe("VMSS initialization error: " + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        LOGGER.info("VMSS Web Application shutting down.");
    }
}
