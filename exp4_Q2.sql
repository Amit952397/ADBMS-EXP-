-- PArt A

CREATE TABLE StudentEnrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(100) NOT NULL,
    course_id VARCHAR(10) NOT NULL,
    enrollment_date DATE NOT NULL,
    UNIQUE (student_name, course_id)  -- Unique pair to prevent duplicates
);
INSERT INTO StudentEnrollments (student_name, course_id, enrollment_date)
VALUES
('Ashish', 'CSE101', '2024-07-01'),
('Smaran', 'CSE102', '2024-07-01'),
('Vaibhav', 'CSE101', '2024-07-01');
START TRANSACTION;

INSERT INTO StudentEnrollments (student_name, course_id, enrollment_date)
VALUES ('Ashish', 'CSE101', CURDATE());
 
COMMIT;
START TRANSACTION;

INSERT INTO StudentEnrollments (student_name, course_id, enrollment_date)
VALUES ('Ashish', 'CSE101', CURDATE());
 
COMMIT;

-- part B-- 

START TRANSACTION;

-- Lock the row for student 'Ashish' in course 'CSE101'
SELECT * FROM StudentEnrollments
WHERE student_name = 'Ashish' AND course_id = 'CSE101'
FOR UPDATE;
 START TRANSACTION;

UPDATE StudentEnrollments
SET enrollment_date = '2024-07-02'
WHERE student_name = 'Ashish' AND course_id = 'CSE101';
COMMIT;


-- part c


START TRANSACTION;

-- Reads current data
SELECT enrollment_date FROM StudentEnrollments WHERE enrollment_id = 1;

-- Updates to '2024-07-05'
UPDATE StudentEnrollments SET enrollment_date = '2024-07-05' WHERE enrollment_id = 1;

COMMIT;
START TRANSACTION;

-- Reads the same old data at the same time
SELECT enrollment_date FROM StudentEnrollments WHERE enrollment_id = 1;

-- Updates to '2024-07-10'
UPDATE StudentEnrollments SET enrollment_date = '2024-07-10' WHERE enrollment_id = 1;

COMMIT;

START TRANSACTION;

-- Lock the row
SELECT * FROM StudentEnrollments WHERE enrollment_id = 1 FOR UPDATE;

-- Perform update
UPDATE StudentEnrollments SET enrollment_date = '2024-07-05' WHERE enrollment_id = 1;

COMMIT;

START TRANSACTION;

-- Try to lock the same row
SELECT * FROM StudentEnrollments WHERE enrollment_id = 1 FOR UPDATE;

SELECT * FROM StudentEnrollments;
