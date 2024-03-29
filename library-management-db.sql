CREATE DATABASE IF NOT EXISTS library;
USE library;

# Table to store user info
CREATE TABLE IF NOT EXISTS lib_user(
	id_user INT AUTO_INCREMENT NOT NULL,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    date_of_birth DATE,
    occupation VARCHAR(30),
    domicile VARCHAR(30),
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_user PRIMARY KEY (id_user)
);

# Table to store book info
CREATE TABLE IF NOT EXISTS book(
	id_book INT AUTO_INCREMENT NOT NULL,
    title VARCHAR(100) NOT NULL,
    year_published YEAR,
    pages INT NOT NULL,
    _language ENUM('Bahasa','English','Deutch','Japan'),
    author VARCHAR(40),
	category ENUM('novel','comic','dictionary','scientific','biography','encyclopedia','thesis','magazine','history'),
    stock INT NOT NULL,
    CONSTRAINT pk_book PRIMARY KEY (id_book)               
)AUTO_INCREMENT=1000;

# Table to store loan info
CREATE TABLE IF NOT EXISTS loan(
	transaction_id INT AUTO_INCREMENT NOT NULL,
	id_user INT, 
    id_book INT,
    user_name VARCHAR(20),
    book_title VARCHAR(100),
    loan_date DATE,    # will be filled with default date of loan_function called
    supposed_return_date DATE,    # will be filled with loan_duration_function
    returned ENUM('YES','NOT YET') DEFAULT 'NOT YET',    # will be filled with return_function
    returned_date DATE DEFAULT '1990-11-11',    # will be filled with default date of return_function called
    CONSTRAINT pk_loan PRIMARY KEY (transaction_id),
    CONSTRAINT fk_id_user FOREIGN KEY (id_user) REFERENCES lib_user(id_user),
	CONSTRAINT fk_id_book FOREIGN KEY (id_book) REFERENCES book(id_book)
)AUTO_INCREMENT=100;


# function loan_days ==> return how many days should the book borrowed
DELIMITER $$
CREATE FUNCTION loan_duration(pages INT)
RETURNS INT
DETERMINISTIC
BEGIN
	CASE
		WHEN pages < 100 THEN RETURN 3;
        WHEN pages < 300 THEN RETURN 5;
        WHEN pages < 500 THEN RETURN 7;
        ELSE RETURN 10;
	END CASE;
END $$
DELIMITER ;

# procedure show_list_user ==> procedure to get list of user
DELIMITER $$
CREATE PROCEDURE show_users()
BEGIN
	SELECT * FROM lib_user ORDER BY id_user;
END $$
DELIMITER ;

# procedure show_book ==> procedure to get list of book
DELIMITER $$
CREATE PROCEDURE show_books()
BEGIN
	SELECT * FROM book ORDER BY id_book;
END $$
DELIMITER ;

# procedure show_loan ==> procedure to get list of loan
DELIMITER $$
CREATE PROCEDURE show_loans()
BEGIN
	SELECT * FROM loan ORDER BY transaction_id;
END $$
DELIMITER ;

# procedure show_returns ==> procedure to get returned book data
DELIMITER $$
CREATE PROCEDURE show_returns()
BEGIN
	SELECT  transaction_id, id_user, id_book, user_name, book_title, loan_date, returned_date
    FROM loan
    WHERE returned='YES';
END $$
DELIMITER ;

# procedure search_user ==> procedure to show data about certain user
DELIMITER $$
CREATE PROCEDURE search_user_by_name(user_name VARCHAR(20))
BEGIN
	SELECT * FROM lib_user
    WHERE first_name REGEXP user_name OR last_name REGEXP user_name;
END $$
DELIMITER ;

# procedure seach_book ==> procedure to show data about certain book
DELIMITER $$
CREATE PROCEDURE search_book_by_title(book_title VARCHAR(100))
BEGIN
	SELECT * FROM book
    WHERE title REGEXP book_title;
END $$
DELIMITER ;

# procedure loan_book ==> procedure to fill table loan
DELIMITER $$
CREATE PROCEDURE loan_book(user_id INT, book_id INT)
BEGIN
	INSERT INTO loan (id_user, id_book, user_name, book_title, loan_date, supposed_return_date)
	WITH source_table AS(
		SELECT lb.id_user, bk.id_book, CONCAT(lb.first_name," ",lb.last_name) AS user_name, bk.title, curdate() as loan_date, DATE_ADD(curdate(), INTERVAL loan_duration(bk.pages) DAY) as supposed_returned_date
        FROM lib_user AS lb, book AS bk 
        WHERE lb.id_user = user_id AND bk.id_book = book_id
    )SELECT * FROM source_table;
	UPDATE book SET stock = stock-1 WHERE id_book = book_id;
END $$
DELIMITER ;

# procedure return_book ==> procedure to update table loan
DELIMITER $$
CREATE PROCEDURE return_book(user_id INT, book_id INT)
BEGIN
	UPDATE loan SET returned='YES', returned_date=curdate() WHERE id_user = user_id AND id_book = book_id;
    UPDATE book SET stock = stock+1 WHERE id_book = book_id;
END $$
DELIMITER ;

# procedure exit_user ==> procedure to update table user, delete user
DELIMITER $$
CREATE PROCEDURE exit_user(user_id INT)
BEGIN
	SET FOREIGN_KEY_CHECKS=0;
	IF (SELECT EXISTS (SELECT returned FROM loan WHERE id_user=user_id AND returned='NOT YET') AS isTest) = 0 THEN
		DELETE FROM lib_user WHERE id_user = user_id;
	ELSE
		SELECT 'Cannot delete user';
	END IF;
    SET FOREIGN_KEY_CHECKS=1;
END $$
DELIMITER ;

# procedure input_user ==> to add user in the library
DELIMITER $$
CREATE PROCEDURE input_user(first_name VARCHAR(20), last_name VARCHAR(20), date_of_birth DATE, occupation VARCHAR(30), domicile VARCHAR(30))
BEGIN
	INSERT INTO lib_user (first_name, last_name, date_of_birth, occupation, domicile) VALUES (first_name, last_name, date_of_birth, occupation, domicile);
END $$
DELIMITER  ;

# procedure input_book ==> to add books in the library
DELIMITER $$
CREATE PROCEDURE input_book(title VARCHAR(100), year_published YEAR, pages INT, _language ENUM('Bahasa','English','Deutch','Japan'), author VARCHAR(40), category ENUM('novel','comic','dictionary','scientific','biography','encyclopedia','thesis','magazine','history'), stock INT)
BEGIN
	INSERT INTO book (title, year_published, pages, _language, author, category, stock) VALUES (title, year_published, pages, _language, author, category, stock) ;
END $$
DELIMITER  ;

# Dummy data for user
INSERT INTO lib_user (first_name, last_name, date_of_birth, occupation, domicile) VALUES ('ahmad', 'kurniawan', '1996-05-16', 'office worker', 'bandung');
INSERT INTO lib_user (first_name, last_name, date_of_birth, occupation, domicile) VALUES ('ilham', 'budi', '1992-04-22', 'mine workter', 'tebet');
INSERT INTO lib_user (first_name, last_name, date_of_birth, occupation, domicile) VALUES ('ratih', 'pratiwi', '1988-07-24', 'house wife', 'depok');
INSERT INTO lib_user (first_name, last_name, date_of_birth, occupation, domicile) VALUES ('nurul', 'putra', '1997-11-21', 'student', 'semarang');
INSERT INTO lib_user (first_name, last_name, date_of_birth, occupation, domicile) VALUES ('wulandari', 'kartika', '1967-09-12', 'banker', 'cimahi');
INSERT INTO lib_user (first_name, last_name, date_of_birth, occupation, domicile) VALUES ('anita', 'handayani', '2008-11-01', 'sales', 'soreang');
INSERT INTO lib_user (first_name, last_name, date_of_birth, occupation, domicile) VALUES ('retno', 'kurnia', '2005-12-25', 'teacher', 'andir');
INSERT INTO lib_user (first_name, last_name, date_of_birth, occupation, domicile) VALUES ('agustina', 'amalia', '2000-05-24', 'mechanic', 'sleman');
INSERT INTO lib_user (first_name, last_name, date_of_birth, occupation, domicile) VALUES ('intan', 'maya', '1999-01-06', 'programmer', 'karanganyar');
INSERT INTO lib_user (first_name, last_name, date_of_birth, occupation, domicile) VALUES ('widya', 'ade', '1989-08-13', 'service cleaner', 'BSD');
INSERT INTO lib_user (first_name, last_name, date_of_birth, occupation, domicile) VALUES ('surya', 'hidayat', '1966-07-15', 'athlete', 'surabaya');
INSERT INTO lib_user (first_name, last_name, date_of_birth, occupation, domicile) VALUES ('diana', 'nur', '2010-09-15', 'marketer', 'gunung kidul');
INSERT INTO lib_user (first_name, last_name, date_of_birth, occupation, domicile) VALUES ('novi', 'anggraini', '2007-04-23', 'researcher', 'cimindi');
INSERT INTO lib_user (first_name, last_name, date_of_birth, occupation, domicile) VALUES ('irma', 'astuti', '1987-12-01', 'farmer', 'lembang');
INSERT INTO lib_user (first_name, last_name, date_of_birth, occupation, domicile) VALUES ('aulia', 'saputra', '1999-09-11', 'office worker', 'purwakarta');
INSERT INTO lib_user (first_name, last_name, date_of_birth, occupation, domicile) VALUES ('eva', 'amelia', '2003-02-09', 'stident', 'cirebon');
INSERT INTO lib_user (first_name, last_name, date_of_birth, occupation, domicile) VALUES ('hidayat', 'saputra', '2005-04-16', 'mechanic', 'kuningan');
INSERT INTO lib_user (first_name, last_name, date_of_birth, occupation, domicile) VALUES ('setiawan', 'arief', '1997-06-28', 'office worker', 'jakarta selatan');
INSERT INTO lib_user (first_name, last_name, date_of_birth, occupation, domicile) VALUES ('wahyuni', 'munaroh', '1976-06-22', 'constructor', 'serpong');
INSERT INTO lib_user (first_name, last_name, date_of_birth, occupation, domicile) VALUES ('bagus', 'eko', '2009-06-07', 'architec', 'rangkasbitung');

# Dummay data for book
INSERT INTO book (title, year_published, pages, _language, author, category, stock) VALUES ('Laskar Pelangi', '2010', '529', 'Bahasa', 'andrea hirata', 'novel', 5);
INSERT INTO book (title, year_published, pages, _language, author, category, stock) VALUES ('Boruto Comic', '2021', '50', 'Japan', 'Masashi Kishimoto', 'comic', 15);
INSERT INTO book (title, year_published, pages, _language, author, category, stock) VALUES ('One Piece Comic', '2021', '59', 'Japan', 'Oda Sensei', 'comic', 15);
INSERT INTO book (title, year_published, pages, _language, author, category, stock) VALUES ('Harry Potter and The Order Of The Phoenix', '2003', '1000', 'English', 'JK Rowling', 'novel', 1);
INSERT INTO book (title, year_published, pages, _language, author, category, stock) VALUES ('Sepatu Dahlan', '2015', '369', 'Bahasa', 'Tiar Yuniar', 'novel', 3);
INSERT INTO book (title, year_published, pages, _language, author, category, stock) VALUES ('Sang Pemimpi', '2003', '248', 'Bahasa', 'Nurul Padmasari', 'novel', 2);
INSERT INTO book (title, year_published, pages, _language, author, category, stock) VALUES ('Ensiklopedia Luar Angkasa', '2010', '258', 'English', 'Space Station', 'encyclopedia', 10);
INSERT INTO book (title, year_published, pages, _language, author, category, stock) VALUES ('Trik Jitu Saham', '2019', '100', 'Bahasa', 'Vanya Farida', 'magazine', 9);
INSERT INTO book (title, year_published, pages, _language, author, category, stock) VALUES ('Fairy Tail Comic', '1986', '255', 'Japan', 'Yulia Purwanti', 'comic', 12);
INSERT INTO book (title, year_published, pages, _language, author, category, stock) VALUES ('What is a Car', '1989', '59', 'Deutch', 'Karimah Wijayanti', 'scientific', 25);
INSERT INTO book (title, year_published, pages, _language, author, category, stock) VALUES ('Sejarah G30SPKI', '2006', '309', 'Bahasa', 'Uchita Wulandari', 'history', 10);
INSERT INTO book (title, year_published, pages, _language, author, category, stock) VALUES ('Enistein Biography', '2008', '485', 'English', 'Padmi Hariyah', 'biography', 5);
INSERT INTO book (title, year_published, pages, _language, author, category, stock) VALUES ('Hari itu Kelam', '2009', '256', 'English', 'Lurhur Waluyo', 'novel', 1);
INSERT INTO book (title, year_published, pages, _language, author, category, stock) VALUES ('How To Create Factory', '2017', '126', 'Japan', 'Vicky Yuniar', 'thesis', 2);
INSERT INTO book (title, year_published, pages, _language, author, category, stock) VALUES ('Tesla Biography', '2015', '453', 'Deutch', 'Nilam Puspita', 'biography', 5);
INSERT INTO book (title, year_published, pages, _language, author, category, stock) VALUES ('Famous Person Dictionary', '1989', '55', 'English', 'Legawa Utama', 'dictionary', 16);
INSERT INTO book (title, year_published, pages, _language, author, category, stock) VALUES ('Marvel Comic', '1996', '259', 'English', 'Indah Prastuti', 'comic', 30);
INSERT INTO book (title, year_published, pages, _language, author, category, stock) VALUES ('Biografi Dahlan Iskan', '2009', '357', 'Bahasa', 'Lukita Tamba', 'biography', 9);
INSERT INTO book (title, year_published, pages, _language, author, category, stock) VALUES ('Perancangan Pabrik Kimia', '2021', '155', 'Bahasa', 'Siti Kuswandari', 'thesis', 25);
INSERT INTO book (title, year_published, pages, _language, author, category, stock) VALUES ('Sejarah Kota Bandung', '2018', '173', 'Bahasa', 'Faizah Yulianti', 'history', 13);

# Dummy data for loan
CALL loan_book(1, 1015);
CALL loan_book(18, 1009);
CALL loan_book(5, 1001);
CALL loan_book(7, 1001);
CALL loan_book(9, 1008);
CALL loan_book(1, 1009);
CALL loan_book(3, 1019);
CALL loan_book(1, 1015);
CALL loan_book(3, 1018);
CALL loan_book(15, 1018);
CALL loan_book(16, 1008);
CALL loan_book(14, 1013);
CALL loan_book(13, 1007);
CALL loan_book(9, 1008);
CALL loan_book(8, 1010);
CALL loan_book(7, 1011);
CALL loan_book(4, 1011);
CALL loan_book(3, 1004);
CALL loan_book(2, 1005);
CALL loan_book(1, 1000);