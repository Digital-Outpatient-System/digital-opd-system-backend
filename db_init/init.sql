--- ROLE TABLE 
CREATE TABLE role (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL
);

--- USER TABLE for staff
CREATE TABLE user (
    user_id SERIAL PRIMARY KEY,
    role_id INT NOT NULL REFERENCES role(role_id),
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    status VARCHAR(20) DEFAULT 'ACTIVE'
);

--- CREATE AUDIT LOGS
CREATE TABLE audit_log (
    audit_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES user(user_id),
    action VARCHAR(100) NOT NULL,
    entity_name VARCHAR(50) NOT NULL,
    entity_id INT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--- PATIENT TABLE
CREATE TABLE patient (
    patient_id SERIAL PRIMARY KEY,
    nic VARCHAR(20) UNIQUE,
    phin VARCHAR(30) UNIQUE, ---personal health identify number
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(25) NOT NULL,
    address TEXT,
    phone VARCHAR(50),
    allergies TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

---
---

---QUEUE_TOKEN
CREATE TABLE queue_token (
    token_id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL REFERENCES patient(patient_id) ON DELETE CASCADE,
    doctor_id INT REFERENCES user(user_id),
    token_number VARCHAR(20) NOT NULL,
    token_date DATE NOT NULL DEFAULT CURRENT_DATE,
    status VARCHAR(20) DEFAULT 'WAITING',  -- 'WAITING', 'CALLED', 'COMPLETED'
    issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    called_at TIMESTAMP,
    completed_at TIMESTAMP
);
