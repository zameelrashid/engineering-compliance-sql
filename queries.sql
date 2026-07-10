-- queries.sql
-- A set of practice queries against the compliance tracker schema,
-- organised from fundamentals to more advanced concepts.
-- Run these against schema.sql + sample_data.sql (SQLite syntax).

-- =====================================================================
-- 1. INNER JOIN vs LEFT JOIN — and why NULL matters
-- =====================================================================

-- 1a. INNER JOIN: only returns engineers who HAVE a training record.
-- Engineers with zero training records (Sam, Morgan) are silently
-- dropped from the results entirely.
SELECT e.full_name, t.training_name, tr.completed_date
FROM engineers e
INNER JOIN training_records tr ON e.engineer_id = tr.engineer_id
INNER JOIN trainings t ON tr.training_id = t.training_id;

-- 1b. LEFT JOIN: keeps every engineer, even those with no matching
-- training record. Where there's no match, every column pulled from
-- the right-hand tables (trainings, training_records) comes back as
-- NULL — not 0, not an empty string. NULL means "no matching row",
-- which is a different thing from "a matching row with a value of 0".
SELECT e.full_name, t.training_name, tr.completed_date
FROM engineers e
LEFT JOIN training_records tr ON e.engineer_id = tr.engineer_id
LEFT JOIN trainings t ON tr.training_id = t.training_id;

-- 1c. This is the classic mistake: using COUNT(column) vs COUNT(*)
-- after a LEFT JOIN. COUNT(tr.record_id) ignores NULLs and gives the
-- true count of completed trainings per engineer. COUNT(*) would
-- count every row returned by the join, including the NULL placeholder
-- rows for engineers with no records — which would overcount here.
SELECT
    e.full_name,
    COUNT(tr.record_id) AS trainings_completed   -- NULLs not counted
FROM engineers e
LEFT JOIN training_records tr ON e.engineer_id = tr.engineer_id
GROUP BY e.full_name
ORDER BY trainings_completed ASC;

-- 1d. Explicitly finding engineers with NO training records at all —
-- this only works because LEFT JOIN preserves them as NULL rows.
-- Filtering on `tr.record_id = 0` here would return nothing, because
-- no row ever actually has a record_id of 0 — the correct check is
-- IS NULL.
SELECT e.full_name, e.department
FROM engineers e
LEFT JOIN training_records tr ON e.engineer_id = tr.engineer_id
WHERE tr.record_id IS NULL;

-- =====================================================================
-- 2. Compliance report: engineers missing a training required for
--    their department (this mirrors the kind of monthly compliance
--    report described in the CV's Alteryx bullet)
-- =====================================================================
SELECT e.full_name, e.department, t.training_name
FROM engineers e
JOIN trainings t
    ON t.required_for = e.department OR t.required_for IS NULL
LEFT JOIN training_records tr
    ON tr.engineer_id = e.engineer_id AND tr.training_id = t.training_id
WHERE tr.record_id IS NULL
ORDER BY e.full_name;

-- =====================================================================
-- 3. GROUP BY + HAVING — departments with more than 1 engineer
--    lacking their required training
-- =====================================================================
SELECT e.department, COUNT(*) AS engineers_missing_training
FROM engineers e
JOIN trainings t
    ON t.required_for = e.department OR t.required_for IS NULL
LEFT JOIN training_records tr
    ON tr.engineer_id = e.engineer_id AND tr.training_id = t.training_id
WHERE tr.record_id IS NULL
GROUP BY e.department
HAVING COUNT(*) > 1;

-- =====================================================================
-- 4. Subquery — engineers allocated to an active project who are
--    NOT fully trained (should be flagged before project start,
--    similar to the compliance-before-allocation bullet on the CV)
-- =====================================================================
SELECT DISTINCT e.full_name, p.project_name
FROM project_allocations pa
JOIN engineers e ON e.engineer_id = pa.engineer_id
JOIN projects p ON p.project_id = pa.project_id
WHERE p.status = 'active'
  AND e.engineer_id IN (
        SELECT e2.engineer_id
        FROM engineers e2
        JOIN trainings t ON t.required_for = e2.department OR t.required_for IS NULL
        LEFT JOIN training_records tr
            ON tr.engineer_id = e2.engineer_id AND tr.training_id = t.training_id
        WHERE tr.record_id IS NULL
  );

-- =====================================================================
-- 5. UNION vs UNION ALL
-- =====================================================================

-- 5a. UNION removes duplicate rows across the two result sets.
SELECT full_name FROM engineers WHERE department = 'Mechanical'
UNION
SELECT full_name FROM engineers WHERE hire_date < '2022-01-01';

-- 5b. UNION ALL keeps duplicates — faster, and correct when you
-- actually want every row counted (e.g. totals), not a deduplicated set.
SELECT full_name FROM engineers WHERE department = 'Mechanical'
UNION ALL
SELECT full_name FROM engineers WHERE hire_date < '2022-01-01';

-- =====================================================================
-- 6. Window function — rank engineers by tenure within department
-- =====================================================================
SELECT
    full_name,
    department,
    hire_date,
    RANK() OVER (PARTITION BY department ORDER BY hire_date ASC) AS tenure_rank
FROM engineers;
