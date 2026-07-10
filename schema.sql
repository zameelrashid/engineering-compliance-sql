-- schema.sql
-- Fictional "Engineering Compliance Tracker" database
-- Models a training/project-allocation system similar in spirit to
-- real-world compliance reporting (all data below is invented for practice).

CREATE TABLE engineers (
    engineer_id     INTEGER PRIMARY KEY,
    full_name       TEXT NOT NULL,
    department      TEXT NOT NULL,
    hire_date       DATE NOT NULL
);

CREATE TABLE projects (
    project_id      INTEGER PRIMARY KEY,
    project_name    TEXT NOT NULL,
    start_date      DATE NOT NULL,
    status          TEXT NOT NULL          -- 'active', 'completed', 'on_hold'
);

CREATE TABLE trainings (
    training_id     INTEGER PRIMARY KEY,
    training_name   TEXT NOT NULL,
    required_for    TEXT                    -- department the training is mandatory for
);

-- Which engineer completed which training, and when.
-- Not every engineer has a row for every required training —
-- this gap is what the LEFT JOIN queries are built to expose.
CREATE TABLE training_records (
    record_id       INTEGER PRIMARY KEY,
    engineer_id     INTEGER NOT NULL,
    training_id     INTEGER NOT NULL,
    completed_date  DATE,
    FOREIGN KEY (engineer_id) REFERENCES engineers(engineer_id),
    FOREIGN KEY (training_id) REFERENCES trainings(training_id)
);

-- Which engineers are allocated to which projects.
CREATE TABLE project_allocations (
    allocation_id   INTEGER PRIMARY KEY,
    project_id      INTEGER NOT NULL,
    engineer_id     INTEGER NOT NULL,
    allocated_date  DATE NOT NULL,
    FOREIGN KEY (project_id) REFERENCES projects(project_id),
    FOREIGN KEY (engineer_id) REFERENCES engineers(engineer_id)
);
