# Database Design & Entity Relationship (ER) Diagram

### Database Specifications
- **Database Engine:** MySQL 8.x InnoDB
- **Character Set:** `utf8mb4`
- **Collation:** `utf8mb4_unicode_ci`

---

### Entity Relationship (ER) Diagram
```mermaid
erDiagram
    USERS ||--o{ VEHICLES : owns
    USERS ||--o{ APPOINTMENTS : books
    USERS ||--o{ SERVICE_PROGRESS : updates
    VEHICLES ||--o{ APPOINTMENTS : undergoes
    SERVICES ||--o{ APPOINTMENTS : categorizes
    APPOINTMENTS ||--o{ SERVICE_PROGRESS : tracks
    APPOINTMENTS ||--|| SERVICE_RECORDS : completes
    APPOINTMENTS ||--|| INVOICES : bills
    INVOICES ||--o{ PAYMENT_RECORDS : settles

    USERS {
        int user_id PK
        string full_name
        string email UK
        string phone
        string password_hash
        string role
        boolean active
        timestamp created_at
    }

    VEHICLES {
        int vehicle_id PK
        int user_id FK
        string registration_no UK
        string vehicle_type
        string brand
        string model
        int manufacturing_year
        string fuel_type
        string chassis_no
        int odometer_reading
        timestamp created_at
    }

    SERVICES {
        int service_id PK
        string service_name
        text description
        string vehicle_type
        decimal base_price
        string estimated_duration
        boolean active
        timestamp created_at
    }

    APPOINTMENTS {
        int appointment_id PK
        int user_id FK
        int vehicle_id FK
        int service_id FK
        date appointment_date
        string time_slot
        text issue_description
        decimal estimated_cost
        string status
        text admin_remarks
        timestamp created_at
        timestamp updated_at
    }

    SERVICE_PROGRESS {
        int progress_id PK
        int appointment_id FK
        int admin_id FK
        string status
        text description
        timestamp created_at
    }

    SERVICE_RECORDS {
        int record_id PK
        int appointment_id FK
        text work_description
        decimal parts_cost
        decimal labor_cost
        text remarks
        date completion_date
        timestamp created_at
    }

    INVOICES {
        int invoice_id PK
        string invoice_number UK
        int appointment_id FK
        decimal subtotal
        decimal discount
        decimal tax_rate
        decimal tax_amount
        decimal total_amount
        string payment_status
        date invoice_date
        timestamp created_at
    }

    PAYMENT_RECORDS {
        int payment_id PK
        int invoice_id FK
        decimal amount
        string payment_method
        string payment_reference
        timestamp payment_date
        string payment_status
    }
```

---

### Primary & Foreign Key Constraints Explained
1. **`users` (`user_id` PK)**: Stores unique accounts with unique email constraint (`UNIQUE(email)`).
2. **`vehicles` (`vehicle_id` PK, `user_id` FK)**: References `users(user_id)`. The `registration_no` is strictly unique (`UNIQUE(registration_no)`).
3. **`services` (`service_id` PK)**: Catalog of active and legacy services.
4. **`appointments` (`appointment_id` PK, `user_id` FK, `vehicle_id` FK, `service_id` FK)**: Connects customer, vehicle, and service package. Enforces a compound unique check (`UNIQUE(vehicle_id, appointment_date, time_slot)`) to prevent duplicate bookings for the same vehicle.
5. **`service_progress` (`progress_id` PK, `appointment_id` FK, `admin_id` FK)**: Chronological milestone tracker referencing `appointments` and the updating administrator.
6. **`service_records` (`record_id` PK, `appointment_id` FK UNIQUE)**: Stores permanent work descriptions and parts/labor logs.
7. **`invoices` (`invoice_id` PK, `invoice_number` UK, `appointment_id` FK UNIQUE)**: Guarantees exactly one final tax invoice per completed service.
8. **`payment_records` (`payment_id` PK, `invoice_id` FK)**: Audit trail of simulated payments against invoices.
