-- =====================================================================
-- Vehicle Management and Service System (VMSS)
-- Sample Seed Data for Academic Demonstration & Development
-- Passwords: All accounts use password 'Admin@123' or 'Customer@123'
-- BCrypt Hash for 'Admin@123': $2a$12$K1r.mZ0e7k0k3vXj8U.Y8eL2t7Z0u9yv7i7f6w4e1b0c9d8e7f6a.
-- BCrypt Hash for 'Customer@123': $2a$12$R9h/cIPz0gi.URNNX3kh2OPST9/PgBkqquzi.Ss7KIUgO2t0jWMUW
-- =====================================================================

USE vehicle_management_db;

-- Clear previous sample data if needed (in reverse dependency order)
DELETE FROM payment_records;
DELETE FROM invoices;
DELETE FROM service_records;
DELETE FROM service_progress;
DELETE FROM appointments;
DELETE FROM services;
DELETE FROM vehicles;
DELETE FROM users;

-- 1. Insert Users
-- Admin: admin@vmss.com / Admin@123
-- Customer 1: rahul@gmail.com / Customer@123
-- Customer 2: priya@gmail.com / Customer@123
-- Customer 3: amit@gmail.com / Customer@123
INSERT INTO users (user_id, full_name, email, phone, password_hash, role, active, created_at) VALUES
(1, 'System Administrator', 'admin@vmss.com', '9876543210', '$2a$12$4Z.G12rC8zP7NvZHEOd.T.lgpC/bfuFX2mE6iYvxdLv1CS8sy7LSm', 'ADMIN', TRUE, NOW()),
(2, 'Rahul Sharma', 'rahul@gmail.com', '9812345678', '$2a$12$piVTs6qw3GE8e/XG4J3HCu7a6T9lzMi1L2T9kJjtwTzWh4gSKPxJe', 'CUSTOMER', TRUE, NOW()),
(3, 'Priya Patel', 'priya@gmail.com', '9823456789', '$2a$12$piVTs6qw3GE8e/XG4J3HCu7a6T9lzMi1L2T9kJjtwTzWh4gSKPxJe', 'CUSTOMER', TRUE, NOW()),
(4, 'Amit Verma', 'amit@gmail.com', '9834567890', '$2a$12$piVTs6qw3GE8e/XG4J3HCu7a6T9lzMi1L2T9kJjtwTzWh4gSKPxJe', 'CUSTOMER', TRUE, NOW());

-- 2. Insert Vehicles
INSERT INTO vehicles (vehicle_id, user_id, registration_no, vehicle_type, brand, model, manufacturing_year, fuel_type, chassis_no, odometer_reading, created_at) VALUES
(1, 2, 'KA-01-AB-1234', 'Four-Wheeler', 'Hyundai', 'Creta SX', 2021, 'Petrol', 'MALB3412345678901', 34250, NOW()),
(2, 2, 'KA-01-XY-9876', 'Two-Wheeler', 'Honda', 'Activa 6G', 2022, 'Petrol', 'ME4JF501234567890', 12400, NOW()),
(3, 3, 'MH-02-CD-5678', 'Four-Wheeler', 'Tata', 'Nexon EV', 2023, 'Electric', 'MAT62312345678902', 18900, NOW()),
(4, 4, 'DL-04-EF-9012', 'Four-Wheeler', 'Maruti Suzuki', 'Swift Dzire', 2019, 'Diesel', 'MA3EYD12345678903', 68500, NOW()),
(5, 4, 'DL-04-GH-3456', 'Two-Wheeler', 'Royal Enfield', 'Classic 350', 2020, 'Petrol', 'ME3U3S12345678904', 21300, NOW());

-- 3. Insert Service Catalog
INSERT INTO services (service_id, service_name, description, vehicle_type, base_price, estimated_duration, active, created_at) VALUES
(1, 'General Periodic Servicing', 'Complete 50-point safety check, fluid top-up, filter cleaning, and mechanical inspection.', 'All', 1499.00, '3-4 hours', TRUE, NOW()),
(2, 'Engine Oil & Filter Change', 'Replacement of premium engine oil and genuine oil filter for peak engine health.', 'All', 899.00, '1-2 hours', TRUE, NOW()),
(3, 'Brake Inspection & Pad Replacement', 'Comprehensive brake disc/pad checking, bleeding, cleaning, and friction component renewal.', 'All', 1199.00, '2 hours', TRUE, NOW()),
(4, 'Wheel Alignment & Balancing', 'Computerized 3D wheel alignment, dynamic wheel balancing, and tire rotation.', 'Four-Wheeler', 799.00, '1 hour', TRUE, NOW()),
(5, 'AC Servicing & Gas Top-up', 'Evaporator cleaning, cabin filter replacement, refrigerant pressure testing, and compressor diagnostics.', 'Four-Wheeler', 1899.00, '2-3 hours', TRUE, NOW()),
(6, 'Battery Inspection & Electrical Health', 'Load voltage testing, terminal cleaning, alternator diagnostic, and backup health check.', 'All', 499.00, '45 minutes', TRUE, NOW()),
(7, 'Foam Wash & Interior Detailing', 'Exterior high-pressure snow foam wash, underbody clean, tire shine, and deep interior vacuum.', 'All', 699.00, '1.5 hours', TRUE, NOW()),
(8, 'Engine Diagnostics & Tuning', 'OBD-II scanner electronic check, sensor fault code analysis, and throttle body calibration.', 'All', 1299.00, '2 hours', TRUE, NOW());

-- 4. Insert Appointments
INSERT INTO appointments (appointment_id, user_id, vehicle_id, service_id, appointment_date, time_slot, issue_description, estimated_cost, status, admin_remarks, created_at) VALUES
-- Pending appointment
(1, 2, 1, 1, DATE_ADD(CURRENT_DATE, INTERVAL 2 DAY), '10:00 AM - 12:00 PM', 'Periodic service due; slight squeak from front suspension on bumps.', 1499.00, 'PENDING', 'Customer requested morning slot.', NOW()),
-- Confirmed appointment
(2, 3, 3, 6, DATE_ADD(CURRENT_DATE, INTERVAL 1 DAY), '02:00 PM - 04:00 PM', 'Battery charge notification displayed on dashboard screen.', 499.00, 'CONFIRMED', 'Technician assigned for EV battery diagnostics.', NOW()),
-- In-progress appointment
(3, 4, 5, 2, CURRENT_DATE, '10:00 AM - 12:00 PM', 'Engine overheating slightly during heavy traffic commutes.', 899.00, 'IN_PROGRESS', 'Vehicle on bay 2. Oil drained and inspection underway.', NOW()),
-- Completed appointment
(4, 2, 2, 3, DATE_SUB(CURRENT_DATE, INTERVAL 3 DAY), '11:00 AM - 01:00 PM', 'Front disc brake feels spongy with reduced stopping bite.', 1199.00, 'COMPLETED', 'Brake pads replaced and lines bled. Tested on road.', DATE_SUB(NOW(), INTERVAL 3 DAY)),
-- Cancelled appointment
(5, 4, 4, 7, DATE_SUB(CURRENT_DATE, INTERVAL 5 DAY), '04:00 PM - 06:00 PM', 'Weekly wash required.', 699.00, 'CANCELLED', 'Cancelled by customer due to travel.', DATE_SUB(NOW(), INTERVAL 5 DAY));

-- 5. Insert Service Progress Timeline
INSERT INTO service_progress (progress_id, appointment_id, admin_id, status, description, created_at) VALUES
(1, 2, 1, 'CONFIRMED', 'Appointment approved and technician slot reserved.', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(2, 3, 1, 'CONFIRMED', 'Appointment accepted.', DATE_SUB(NOW(), INTERVAL 4 HOUR)),
(3, 3, 1, 'VEHICLE_RECEIVED', 'Two-wheeler received at service center gate with key and documents.', DATE_SUB(NOW(), INTERVAL 2 HOUR)),
(4, 3, 1, 'IN_PROGRESS', 'Vehicle mounted on lift; engine diagnostics and oil flush in progress.', DATE_SUB(NOW(), INTERVAL 1 HOUR)),
(5, 4, 1, 'CONFIRMED', 'Appointment verified.', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(6, 4, 1, 'VEHICLE_RECEIVED', 'Vehicle logged into garage register.', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(7, 4, 1, 'IN_PROGRESS', 'Brake calipers dismantled; caliper pins greased.', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(8, 4, 1, 'COMPLETED', 'New ceramic brake pads fitted, brake fluid topped up and road test passed.', DATE_SUB(NOW(), INTERVAL 3 DAY));

-- 6. Insert Service Record for Completed Appointment (id: 4)
INSERT INTO service_records (record_id, appointment_id, work_description, parts_cost, labor_cost, remarks, completion_date, created_at) VALUES
(1, 4, 'Replaced front ceramic brake pads, cleaned rotor disc, flushed DOT 4 fluid, and adjusted rear drum play.', 650.00, 500.00, 'Braking performance restored to optimal specifications.', DATE_SUB(CURRENT_DATE, INTERVAL 3 DAY), DATE_SUB(NOW(), INTERVAL 3 DAY));

-- 7. Insert Invoice for Completed Appointment (id: 4)
-- subtotal: parts 650 + labor 500 = 1150. discount: 50. taxable: 1100. tax (18%): 198. total: 1298.
INSERT INTO invoices (invoice_id, invoice_number, appointment_id, subtotal, discount, tax_rate, tax_amount, total_amount, payment_status, invoice_date, created_at) VALUES
(1, 'INV-202610-0001', 4, 1150.00, 50.00, 18.00, 198.00, 1298.00, 'PAID', DATE_SUB(CURRENT_DATE, INTERVAL 3 DAY), DATE_SUB(NOW(), INTERVAL 3 DAY));

-- 8. Insert Payment Record for Invoice 1
INSERT INTO payment_records (payment_id, invoice_id, amount, payment_method, payment_reference, payment_date, payment_status) VALUES
(1, 1, 1298.00, 'UPI', 'UPI-TXN-9874561230', DATE_SUB(NOW(), INTERVAL 3 DAY), 'SUCCESS');
