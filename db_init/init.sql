--- ROLE TABLE 
CREATE TABLE role (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL
);

--- USER TABLE for staff
CREATE TABLE "user" (
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
    user_id INT NOT NULL REFERENCES "user"(user_id),
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
---ADD INDEX TO PATIENT TABLE FOR FAST SEARCH
CREATE INDEX idx_patient_nic ON patient(nic);
CREATE INDEX idx_patient_phin ON patient(phin);

---QUEUE_TOKEN
CREATE TABLE queue_token (
    token_id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL REFERENCES patient(patient_id) ON DELETE CASCADE,
    doctor_id INT REFERENCES "user"(user_id),
    token_number VARCHAR(20) NOT NULL,
    token_date DATE NOT NULL DEFAULT CURRENT_DATE,
    status VARCHAR(20) DEFAULT 'WAITING',  -- 'WAITING', 'CALLED', 'COMPLETED'
    issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    called_at TIMESTAMP,
    completed_at TIMESTAMP
);

---TRIAGE TABLE
CREATE TABLE triage(
    triage_id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL REFERENCES patient(patient_id) ON DELETE CASCADE,
    token_id INT NOT NULL REFERENCES queue_token(token_id) ON DELETE CASCADE,
    recorded_by INT NOT NULL REFERENCES "user"(user_id),
    temperature DECIMAL(4,1),
    blood_pressure VARCHAR(20),
    pulse_rate INT,
    symptoms TEXT,
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

---CONSULTATION TABLE
CREATE TABLE consultation (
    consultation_id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL REFERENCES patient(patient_id) ON DELETE CASCADE,
    doctor_id INT NOT NULL REFERENCES "user"(user_id),
    token_id INT REFERENCES queue_token(token_id),
    symptoms TEXT,
    diagnosis TEXT NOT NULL,
    clinical_notes TEXT,
    consultation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

---CREATE TABLE (Pharmacy inventory)
CREATE TABLE medication (
    medication_id SERIAL PRIMARY KEY,
    medication_name VARCHAR(100) NOT NULL,
    strength VARCHAR(50), --- '50mg'
    form VARCHAR(50),   --- 'Tablet', 'Syrup', 'Injection'
    stock_quantity INT NOT NULL DEFAULT 0
);

--- PRESCRIPTION TABLE
CREATE TABLE prescription (
    prescription_id SERIAL PRIMARY KEY,
    consultation_id INT NOT NULL REFERENCES consultation(consultation_id) ON DELETE CASCADE,
    patient_id INT NOT NULL REFERENCES patient(patient_id),
    doctor_id INT NOT NULL REFERENCES "user"(user_id),
    status VARCHAR(20) DEFAULT 'PENDING', -- 'PENDING', 'DISPENSED', 'CANCELLED'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--- PRESCRIPTION ITEM TABLE
CREATE TABLE prescription_item (
    prescription_item_id SERIAL PRIMARY KEY,
    prescription_id INT NOT NULL REFERENCES prescription(prescription_id) ON DELETE CASCADE,
    medication_id INT NOT NULL REFERENCES medication(medication_id),
    dosage VARCHAR(50) NOT NULL,     -- e.g., '1 Tablet'
    frequency VARCHAR(50) NOT NULL,  -- e.g., 'TDS (3 times a day)'
    duration_days INT NOT NULL,  
    quantity INT NOT NULL
);

--- DISPENSING TABLE
CREATE TABLE dispensing (
    dispensing_id SERIAL PRIMARY KEY,
    prescription_id INT NOT NULL REFERENCES prescription(prescription_id),
    pharmacist_id INT NOT NULL REFERENCES "user"(user_id),
    dispensed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'COMPLETED'
);

--- VACCINE TABLE
CREATE TABLE vaccine (
    vaccine_id SERIAL PRIMARY KEY,
    vaccine_name VARCHAR(100) NOT NULL,
    regimen TEXT NOT NULL                -- e.g., 'Day 0, Day 3, Day 7, Day 14, Day 28'
);

---VACCINATION TABLE (Patient Immunization History)
CREATE TABLE vaccination (
    vaccination_id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL REFERENCES patient(patient_id) ON DELETE CASCADE,
    vaccine_id INT NOT NULL REFERENCES vaccine(vaccine_id),
    administered_by INT NOT NULL REFERENCES "user"(user_id),
    dose_number INT NOT NULL,
    administered_date DATE NOT NULL DEFAULT CURRENT_DATE,
    next_dose_date DATE
);

--- INSERT INITIAL ROLS TO ROLE
INSERT INTO role(role_name) VALUES
('Receptionist'),
('Medical Officer'),
('Pharmacist'),
('DMO_Administrator');