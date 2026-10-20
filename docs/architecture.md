# System Architecture & Design

### 1. High-Level MVC Architecture
The system demonstrates strict separation of concerns using the classic 3-Tier Model-View-Controller (MVC) architecture:

```mermaid
flowchart TD
    subgraph ClientLayer ["Client Presentation Layer (Browser)"]
        Browser["Desktop & Mobile Browsers<br>(HTML5, CSS3, Bootstrap 5, Bootstrap Icons)"]
    end

    subgraph ControllerLayer ["Web & Security Controller Layer (Jakarta Servlet)"]
        Filter["AuthenticationFilter<br>(RBAC & CSRF Protection)"]
        AuthServ["AuthServlet<br>(/login, /register, /logout)"]
        CustServ["CustomerServlet<br>(/customer/*)"]
        AdminServ["AdminServlet<br>(/admin/*)"]
        HomeServ["HomeServlet<br>(/, /services, /about)"]
    end

    subgraph BusinessLayer ["Business Logic & Transaction Layer"]
        ServiceLayer["VehicleService<br>(Business rules, Slot capacity, Invoicing)"]
        SecUtil["SecurityUtil<br>(BCrypt Cost-12, Token Gen)"]
    end

    subgraph DataAccessLayer ["Data Access Layer (JDBC DAO)"]
        UserDAO["UserDAO"]
        VehicleDAO["VehicleDAO"]
        ServiceDAO["ServiceDAO"]
        ApptDAO["AppointmentDAO"]
        ProgDAO["ServiceProgressDAO"]
        RecordDAO["ServiceRecordDAO"]
        InvDAO["InvoiceDAO"]
        PayDAO["PaymentDAO"]
        DBC["DBConnection<br>(DriverManager / Connection Pooling)"]
    end

    subgraph DatabaseLayer ["Persistent Storage Layer"]
        MySQL[("MySQL 8.x Database<br>(vehicle_management_db)")]
        H2[("Embedded H2 Fallback Engine<br>(Memory / Unit Testing)")]
    end

    Browser <-->|HTTP / HTTPS Requests| Filter
    Filter --> AuthServ
    Filter --> CustServ
    Filter --> AdminServ
    Filter --> HomeServ

    AuthServ --> ServiceLayer
    CustServ --> ServiceLayer
    AdminServ --> ServiceLayer
    HomeServ --> ServiceLayer

    ServiceLayer --> SecUtil
    ServiceLayer --> UserDAO
    ServiceLayer --> VehicleDAO
    ServiceLayer --> ServiceDAO
    ServiceLayer --> ApptDAO
    ServiceLayer --> ProgDAO
    ServiceLayer --> RecordDAO
    ServiceLayer --> InvDAO
    ServiceLayer --> PayDAO

    UserDAO --> DBC
    VehicleDAO --> DBC
    ServiceDAO --> DBC
    ApptDAO --> DBC
    ProgDAO --> DBC
    RecordDAO --> DBC
    InvDAO --> DBC
    PayDAO --> DBC

    DBC --> MySQL
    DBC -.->|Automated Fallback| H2
```

---

### 2. Appointment Booking & Service Lifecycle Workflow
```mermaid
stateDiagram-v2
    [*] --> PENDING : Customer books appointment
    PENDING --> CONFIRMED : Admin accepts & schedules bay
    PENDING --> REJECTED : Admin rejects slot (Capacity / Incompatible)
    PENDING --> CANCELLED : Customer cancels before confirmation
    CONFIRMED --> CANCELLED : Customer cancels prior to bay arrival
    CONFIRMED --> IN_PROGRESS : Vehicle received at service bay
    IN_PROGRESS --> Inspection : Milestone logged
    Inspection --> RepairWork : Milestone logged
    RepairWork --> COMPLETED : Technician finishes work
    COMPLETED --> Invoicing : Subtotal + Parts + Labor + 18% GST generated
    Invoicing --> PAID : Customer simulates digital payment (UPI/Card)
    PAID --> [*]
```
