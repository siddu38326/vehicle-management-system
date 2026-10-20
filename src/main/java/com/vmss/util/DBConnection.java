package com.vmss.util;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DBConnection provides JDBC database connectivity for VMSS.
 * Supports MySQL 8.x, environment variable overrides (DB_USER, DB_PASSWORD, DB_URL),
 * and transparent automated in-memory H2 fallback if MySQL is not reachable,
 * ensuring the application can always be built, tested, and demonstrated seamlessly.
 */
public class DBConnection {

    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());
    private static final Properties PROPERTIES = new Properties();
    private static volatile boolean initialized = false;
    private static boolean useH2Fallback = false;

    static {
        loadProperties();
    }

    private static void loadProperties() {
        try (InputStream in = DBConnection.class.getClassLoader().getResourceAsStream("database.properties")) {
            if (in != null) {
                PROPERTIES.load(in);
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Could not load database.properties, using system defaults", e);
        }
    }

    public static synchronized void initialize() {
        if (initialized) {
            return;
        }

        String dbType = System.getenv("DB_TYPE") != null ? 
                System.getenv("DB_TYPE") : PROPERTIES.getProperty("db.type", "mysql");

        if ("h2".equalsIgnoreCase(dbType)) {
            useH2Fallback = true;
            initH2Schema();
            initialized = true;
            return;
        }

        // Try MySQL first
        try {
            Class.forName(PROPERTIES.getProperty("db.mysql.driver", "com.mysql.cj.jdbc.Driver"));
            String url = getDbUrl();
            String user = getDbUser();
            String pass = getDbPassword();

            LOGGER.info("Attempting connection to MySQL at: " + url + " with user: " + user);
            try (Connection conn = DriverManager.getConnection(url, user, pass)) {
                LOGGER.info("Successfully connected to MySQL database!");
                initialized = true;
                return;
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "MySQL connection failed (" + e.getMessage() + "). Switching to embedded H2 MySQL mode for full functionality.", e);
            useH2Fallback = true;
            initH2Schema();
            initialized = true;
        }
    }

    private static void initH2Schema() {
        try {
            Class.forName(PROPERTIES.getProperty("db.h2.driver", "org.h2.Driver"));
            String h2Url = PROPERTIES.getProperty("db.h2.url", "jdbc:h2:mem:vehicle_management_db;MODE=MySQL;DATABASE_TO_LOWER=TRUE;DB_CLOSE_DELAY=-1");
            String h2User = PROPERTIES.getProperty("db.h2.user", "sa");
            String h2Pass = PROPERTIES.getProperty("db.h2.password", "");

            try (Connection conn = DriverManager.getConnection(h2Url, h2User, h2Pass);
                 Statement stmt = conn.createStatement()) {

                // Load schema and execute
                executeSqlScript(stmt, "/schema-h2.sql");
                // Load sample seed data
                executeSqlScript(stmt, "/sample-data-h2.sql");
                LOGGER.info("H2 in-memory MySQL-compatible database successfully initialized with full schema and sample data.");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize H2 database", e);
        }
    }

    private static void executeSqlScript(Statement stmt, String resourcePath) {
        try (InputStream in = DBConnection.class.getResourceAsStream(resourcePath)) {
            if (in == null) {
                // Try classpath root
                InputStream inRoot = DBConnection.class.getClassLoader().getResourceAsStream(resourcePath.startsWith("/") ? resourcePath.substring(1) : resourcePath);
                if (inRoot != null) {
                    runStatements(stmt, inRoot);
                }
                return;
            }
            runStatements(stmt, in);
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error executing script " + resourcePath + ": " + e.getMessage());
        }
    }

    private static void runStatements(Statement stmt, InputStream in) throws Exception {
        try (InputStreamReader reader = new InputStreamReader(in, StandardCharsets.UTF_8)) {
            StringBuilder sb = new StringBuilder();
            int c;
            while ((c = reader.read()) != -1) {
                sb.append((char) c);
            }
            String[] commands = sb.toString().split(";");
            for (String cmd : commands) {
                String trimmed = cmd.trim();
                if (!trimmed.isEmpty()) {
                    try {
                        stmt.execute(trimmed);
                    } catch (SQLException ex) {
                        LOGGER.log(Level.FINE, "SQL Warning/Skip: " + ex.getMessage());
                    }
                }
            }
        }
    }

    public static Connection getConnection() throws SQLException {
        if (!initialized) {
            initialize();
        }

        if (useH2Fallback) {
            String h2Url = PROPERTIES.getProperty("db.h2.url", "jdbc:h2:mem:vehicle_management_db;MODE=MySQL;DATABASE_TO_LOWER=TRUE;DB_CLOSE_DELAY=-1");
            String h2User = PROPERTIES.getProperty("db.h2.user", "sa");
            String h2Pass = PROPERTIES.getProperty("db.h2.password", "");
            return DriverManager.getConnection(h2Url, h2User, h2Pass);
        }

        String url = getDbUrl();
        String user = getDbUser();
        String pass = getDbPassword();
        return DriverManager.getConnection(url, user, pass);
    }

    public static String getDbUrl() {
        String envUrl = System.getenv("DB_URL");
        if (envUrl != null && !envUrl.trim().isEmpty()) {
            return envUrl;
        }
        return PROPERTIES.getProperty("db.mysql.url", "jdbc:mysql://localhost:3306/vehicle_management_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC");
    }

    public static String getDbUser() {
        String envUser = System.getenv("DB_USER");
        if (envUser != null && !envUser.trim().isEmpty()) {
            return envUser;
        }
        return PROPERTIES.getProperty("db.mysql.user", "root");
    }

    public static String getDbPassword() {
        String envPass = System.getenv("DB_PASSWORD");
        if (envPass != null) {
            return envPass;
        }
        return PROPERTIES.getProperty("db.mysql.password", "root");
    }

    public static boolean isH2Fallback() {
        return useH2Fallback;
    }
}
