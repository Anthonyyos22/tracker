-- Create the database with check for existing
DROP DATABASE IF EXISTS expense_tracker;
CREATE DATABASE expense_tracker;
USE expense_tracker;

-- Create tables for the expense tracker
CREATE TABLE IF NOT EXISTS categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    description TEXT
);

CREATE TABLE IF NOT EXISTS expenses (
    expense_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT,
    amount DECIMAL(10, 2) NOT NULL,
    description VARCHAR(255),
    expense_date DATE NOT NULL,
    payment_method VARCHAR(50),
    is_recurring BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Insert sample data
INSERT INTO categories (category_name, description) VALUES
('Food', 'Groceries and dining out'),
('Transportation', 'Public transport, fuel, etc.'),
('Utilities', 'Electricity, water, internet bills'),
('Entertainment', 'Movies, concerts, hobbies'),
('Housing', 'Rent or mortgage payments');

INSERT INTO expenses (category_id, amount, description, expense_date, payment_method, is_recurring) VALUES
(1, 45.50, 'Weekly groceries', '2023-10-15', 'Credit Card', FALSE),
(1, 28.75, 'Dinner with friends', '2023-10-18', 'Debit Card', FALSE),
(2, 60.00, 'Monthly bus pass', '2023-10-01', 'Cash', TRUE),
(3, 120.50, 'Electricity bill', '2023-10-05', 'Bank Transfer', TRUE),
(4, 35.00, 'Movie tickets', '2023-10-20', 'Credit Card', FALSE),
(5, 950.00, 'Apartment rent', '2023-10-01', 'Bank Transfer', TRUE),
(1, 15.25, 'Coffee shop', '2023-10-22', 'Mobile Payment', FALSE);

-- Example SELECT queries with wildcards, comparison operators, and WHERE clauses

-- 1. Get all expenses greater than $50
SELECT e.expense_id, c.category_name, e.amount, e.description, e.expense_date
FROM expenses e
JOIN categories c ON e.category_id = c.category_id
WHERE e.amount > 50
ORDER BY e.amount DESC;

-- 2. Find food-related expenses in October 2023
SELECT e.expense_id, e.amount, e.description, e.expense_date
FROM expenses e
JOIN categories c ON e.category_id = c.category_id
WHERE c.category_name = 'Food'
AND e.expense_date BETWEEN '2023-10-01' AND '2023-10-31'
ORDER BY e.expense_date;

-- 3. Search for expenses containing "bill" in description
SELECT e.expense_id, c.category_name, e.amount, e.description
FROM expenses e
JOIN categories c ON e.category_id = c.category_id
WHERE e.description LIKE '%bill%'
ORDER BY c.category_name;

-- 4. Find recurring payments OR payments over $100
SELECT e.expense_id, c.category_name, e.amount, e.description, e.payment_method
FROM expenses e
JOIN categories c ON e.category_id = c.category_id
WHERE e.is_recurring = TRUE OR e.amount > 100
ORDER BY e.is_recurring DESC, e.amount DESC;

-- 5. Get non-food expenses paid by credit card
SELECT e.expense_id, c.category_name, e.amount, e.description
FROM expenses e
JOIN categories c ON e.category_id = c.category_id
WHERE c.category_name != 'Food'
AND e.payment_method = 'Credit Card'
ORDER BY e.expense_date;