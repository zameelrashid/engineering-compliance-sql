-- sample_data.sql
-- Fictional sample data for practice purposes only.

INSERT INTO engineers (engineer_id, full_name, department, hire_date) VALUES
(1, 'Alex Morgan',    'Mechanical', '2022-03-01'),
(2, 'Priya Nair',     'Electrical', '2021-07-15'),
(3, 'Sam Whitfield',  'Mechanical', '2023-01-10'),
(4, 'Jordan Blake',   'Software',   '2020-11-20'),
(5, 'Casey Adeyemi',  'Electrical', '2023-06-05'),
(6, 'Riley Chen',     'Mechanical', '2019-09-12'),
(7, 'Morgan Patel',   'Software',   '2022-12-01');

INSERT INTO projects (project_id, project_name, start_date, status) VALUES
(101, 'Turbine Efficiency Upgrade',   '2024-01-15', 'active'),
(102, 'Grid Sensor Rollout',          '2024-03-01', 'active'),
(103, 'Legacy Control Panel Refresh', '2023-08-01', 'completed'),
(104, 'Substation Automation Pilot',  '2024-05-10', 'on_hold');

INSERT INTO trainings (training_id, training_name, required_for) VALUES
(1, 'High Voltage Safety',        'Electrical'),
(2, 'Confined Space Entry',       'Mechanical'),
(3, 'Secure Code Review',         'Software'),
(4, 'General Site Induction',     NULL); -- required for everyone

-- Note: NOT every engineer has a completed record for every required
-- training. This is intentional — it's what the LEFT JOIN/NULL queries
-- in queries.sql are designed to surface.
INSERT INTO training_records (record_id, engineer_id, training_id, completed_date) VALUES
(1, 1, 2, '2023-04-01'),
(2, 1, 4, '2022-03-05'),
(3, 2, 1, '2021-08-01'),
(4, 2, 4, '2021-07-20'),
(5, 4, 3, '2021-01-15'),
(6, 4, 4, '2020-11-25'),
(7, 6, 2, '2019-10-01'),
(8, 6, 4, '2019-09-15'),
(9, 5, 4, '2023-06-10');
-- Notice: engineer 3 (Sam Whitfield) has NO training records at all.
-- Engineer 5 (Casey Adeyemi) has only completed General Site Induction,
-- not the required High Voltage Safety.
-- Engineer 7 (Morgan Patel) has no records at all either.

INSERT INTO project_allocations (allocation_id, project_id, engineer_id, allocated_date) VALUES
(1, 101, 1, '2024-01-15'),
(2, 101, 6, '2024-01-20'),
(3, 102, 2, '2024-03-01'),
(4, 102, 5, '2024-03-05'),
(5, 103, 4, '2023-08-01'),
(6, 104, 7, '2024-05-10'),
(7, 101, 3, '2024-02-01');
