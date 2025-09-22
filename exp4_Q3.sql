-- Part A: Simulating a Deadlock Between Two Transactions-- 

CREATE DATABASE concurrency_demo;
USE concurrency_demo;

CREATE TABLE StudentEnrollments (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    course_id VARCHAR(10),
    enrollment_date DATE
);
INSERT INTO StudentEnrollments VALUES
(1, 'Ashish', 'CSE101', '2024-06-01'),
(2, 'Smaran', 'CSE102', '2024-06-01'),
(3, 'Vaibhav', 'CSE103', '2024-06-01');
START TRANSACTION;

-- Step 1: Lock Row with student_id = 1
UPDATE StudentEnrollments
SET course_id = 'CSE201'
WHERE student_id = 1;
START TRANSACTION;

-- Step 2: Lock Row with student_id = 2
UPDATE StudentEnrollments
SET course_id = 'CSE202'
WHERE student_id = 2;
-- Step 3: Attempt to lock student_id = 2
UPDATE StudentEnrollments
SET course_id = 'CSE301'
WHERE student_id = 2;
-- This will WAIT because Session 2 holds a lock on student_id = 2
-- Step 4: Attempt to lock student_id = 1
UPDATE StudentEnrollments
SET course_id = 'CSE302'
WHERE student_id = 1;
-- Deadlock occurs here!
UPDATE StudentEnrollments
SET course_id = 'CSE400'
WHERE student_id IN (1, 2)
ORDER BY student_id;
SET innodb_lock_wait_timeout = 5;
SELECT * FROM StudentEnrollments WHERE student_id = 1;
-- Output: enrollment_date = '2024-06-01'

-- Part B: Applying MVCC to Prevent Conflicts During Concurrent Reads/Writes-- 


SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;

-- User A starts reading
SELECT enrollment_date
FROM StudentEnrollments
WHERE student_id = 1;
-- Output: 2024-06-01
START TRANSACTION;

-- User B updates the same row
UPDATE StudentEnrollments
SET enrollment_date = '2024-07-10'
WHERE student_id = 1;

COMMIT;
-- User A re-reads without committing
SELECT enrollment_date
FROM StudentEnrollments
WHERE student_id = 1;
-- Output STILL shows: 2024-06-01
COMMIT;

-- Now, read the latest value
SELECT enrollment_date
FROM StudentEnrollments
WHERE student_id = 1;
-- Output: 2024-07-10
START TRANSACTION;

SELECT enrollment_date
FROM StudentEnrollments
WHERE student_id = 1
FOR UPDATE;
-- Row is locked for writing
SELECT enrollment_date
FROM StudentEnrollments
WHERE student_id = 1;
-- BLOCKED until Session 1 COMMITs
UPDATE StudentEnrollments
SET enrollment_date = '2024-08-15'
WHERE student_id = 1;

COMMIT;
START TRANSACTION;

UPDATE StudentEnrollments
SET enrollment_date = '2024-09-01'
WHERE student_id = 1;
-- Session 1 hasn't committed yet

-- Part C: Comparing Behavior With and Without MVCC in High-Concurrency


SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;

SELECT enrollment_date
FROM StudentEnrollments
WHERE student_id = 1;
-- Output: 2024-08-15 (old value, consistent snapshot)
COMMIT;
SELECT enrollment_date
FROM StudentEnrollments
WHERE student_id = 1;
-- STILL shows: 2024-08-15 until Session 2 commits
