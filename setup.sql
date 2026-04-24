CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    nationality VARCHAR(50)
);

CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author_id INT REFERENCES authors(author_id),
    published_year INT,
    available_copies INT DEFAULT 5,
    last_updated TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE borrowers (
    borrower_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE
);

CREATE TABLE loans (
    loan_id SERIAL PRIMARY KEY,
    book_id INT REFERENCES books(book_id),
    borrower_id INT REFERENCES borrowers(borrower_id),
    loan_date DATE DEFAULT CURRENT_DATE,
    return_date DATE,
    fine_amount DECIMAL(10, 2) DEFAULT 0.00
);

INSERT INTO authors (name, nationality) VALUES 
('J.K. Rowling', 'British'),
('George R.R. Martin', 'American'),
('J.R.R. Tolkien', 'British');

INSERT INTO books (title, author_id, published_year, available_copies) VALUES 
('Harry Potter and the Philosopher''s Stone', 1, 1997, 10),
('A Game of Thrones', 2, 1996, 5),
('The Hobbit', 3, 1937, 8);

INSERT INTO borrowers (name, email) VALUES 
('John Doe', 'john@example.com'),
('Jane Smith', 'jane@example.com');

SELECT b.title, a.name AS author_name
FROM books b
INNER JOIN authors a ON b.author_id = a.author_id;

SELECT a.name, b.title
FROM authors a
LEFT JOIN books b ON a.author_id = b.author_id;

CREATE OR REPLACE FUNCTION calculate_late_fee(loan_day DATE, return_day DATE) 
RETURNS DECIMAL AS $$
DECLARE
    days_overdue INTEGER;
    fine DECIMAL := 0;
BEGIN
    days_overdue := return_day - (loan_day + INTERVAL '14 days');
    IF days_overdue > 0 THEN
        fine := days_overdue * 0.50;
    END IF;
    RETURN fine;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION manage_book_inventory()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        UPDATE books SET available_copies = available_copies - 1 
        WHERE book_id = NEW.book_id;
    ELSIF (TG_OP = 'UPDATE') THEN
        IF NEW.return_date IS NOT NULL AND OLD.return_date IS NULL THEN
            UPDATE books SET available_copies = available_copies + 1 
            WHERE book_id = NEW.book_id;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_inventory_update
AFTER INSERT OR UPDATE ON loans
FOR EACH ROW
EXECUTE FUNCTION manage_book_inventory();

INSERT INTO loans (book_id, borrower_id, loan_date) VALUES (1, 1, CURRENT_DATE);

SELECT title, available_copies FROM books WHERE book_id = 1;
