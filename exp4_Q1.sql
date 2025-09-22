-- --question A
-- Step 1: Create the table
CREATE TABLE FeePayments (
    payment_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    amount DECIMAL(10,2) CHECK (amount > 0),
    payment_date DATE NOT NULL
);
START TRANSACTION;

INSERT INTO FeePayments (payment_id, student_name, amount, payment_date)
VALUES 
(1, 'Ashish', 5000.00, '2024-06-01'),
(2, 'Smaran', 4500.00, '2024-06-02'),
(3, 'Vaibhav', 5500.00, '2024-06-03');

COMMIT;

SELECT * FROM FeePayments;

-- --question B

START TRANSACTION;
 INSERT INTO FeePayments (payment_id, student_name, amount, payment_date)
VALUES 
(7, 'Kiran', 6000.00, '2024-06-04'),
(8, 'Ashish', 3000.00, '2024-06-05'); 
 
ROLLBACK;
 
SELECT * FROM FeePayments;
