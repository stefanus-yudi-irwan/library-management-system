<p align="center"><img width=1000 src="sat_lms.png"></p>
<p align="center"><text>Stefanus Yudi Irwan | Pacmann User Name : stefanus-flri</text></p>

__`SAT Library Management System`__ is an application for helping librarian do the job. This app was designed using `python` as basic programming language and `mysql` as database. [`Tkinter`](https://pypi.org/project/tk/), [`Pillow`](https://pypi.org/project/Pillow/), and [`MySQLConnector`](https://pypi.org/project/mysql-connector-python/) are the third party library use to create this app. This app was developed using windows, compatibility with UNIX operation system need to be tested for futher development. 

<p align="center">
<img height=125 src="image/tkinter_logo.jpg">
<img height=125 src="image/pillow_logo.jpg">
<img height=125 src="image/mysql_logo.jpg">
</P>

__`SAT Library Management System`__ app capability such as :
 - library member and book data storage
 - transaction such as loan or return books
 - search registered book and user inside the library database
 - show list of stored user data, book data, and transaction data 

## Project purpose
This project purpose is to develop an application to help librarian do his/her task. This app could become helper for librarian to manage his/her library data. This app main function is to become user interface for librarian to input data to library database and to store library data. Further this project also able to be `building block` for another project which will use `mysql database` and `python gui` in particular, or `database` and more `shopisticated gui` in common. The code structure of this project could become reference if reader want to build an app based on just python and mysql. Its free to use enjoy. 

## Project step by step
### 1. Define requirements menu for this application<br>
> For the sake of librarian ease, the appllication was designed with this following capability : 
> - data input for library new member ,new book collection, and book transaction (loan or returned)
> - data show and storage for library users, book, loaned book, and returned book
> - data registered search for user, book, and transaction

### 2. Create the database Structure<br>
> Based on requirement, database then designed comprises of three table with following relation. MySQL workbench in windows OS was used to create the database and these three table

> <p align="center"><img width=600 src="image/erd_database.jpg"></p>

>**Table 1** : `lib_user` table designed to store the library member data, this table comprises of field :
> | id_user | first_name | last_name | date_of_birth | occupation | domicile | registration_date |
>|:---:|:---:|:---:|:---:|:---:|:---:|:---:|

> `id_user` and `registration_date` designed to be autofilled by mysql

>**Table 2** : `book` table designed to store the library book data, this table comprises of field:
>| id_book | title | year_published | pages | _language | author | category | stock |
>|:---|:---:|:---:|:---:|:---:|:---:|:---:|---:|

> `id_book` designed to be autodilled by mysql. `pages` field are very necessary for book data, because value from this field will determine how many days does the library user could borrow the book. Some calculation are designed based on this `pages`value. `stock` field represent the book amount stored in the library. If user borrow a book, then this stock value will decrease, otherwise if someone return book, stock value will increase. After the book stock was zero, no one can borrow the book. 

>**Table 3** : `loan` table designed to store book transaction data (loan and return), this table comprises of field : 
> | transaction_id | id_user | id_book | user_name | book_title | loan_date | supposed_return_date | returned | return_date |
> |:---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|--:|

> - `id_user`,`id_book`, `user_name`, and `book_title`, will be autofilled from table `lib_user` and `book`.
> - `loan_date` will be auto-filled with transaction date.
> - `supposed_return_date` will be filled by output `function loan_duration` which count loan days based on book pages. The book has page, the more days user can borrow it.
> - `returned` will be auto-filled with value `YES` or `NO` describing if the user has returned the book or not.
> - `return_date` will be auto-filled with returned transaction date. 

### 3. Create function and Procedure for the database
> Because the activity of this application is limited, it is a good idea to make `procedures` and `function` inside the database. This also will make the python side more simple to code. Based on defined requirement,  following is the list of designed function and procedure to interact with library database.

>|Procedure|input_user, show_users, show_books, show_loans, show_returns, search_user_by_name, search_book_by_title, loan_book, return_book, exit_user|
>|:---:|:---|
>|Function|loan_duration|
 
#### Note : Tables, procedures, and functions was encapsulated inside mysql script file `library-management-db.sql` 

### 4. Create connector for database to python
> Connector function to connect mysql database to python GUI. This connector designed by using `mysql.Connector`, third party python library use to connect python program to mysql-server database. For this project `connect_mysql.py` files contain necesarry function to connect `library database` to `library app GUI`. It is made separated from GUI python code to maintain code modularity. This file later imported to GUI python code `lib-management-gui-app.py` to fully function. 

### 5. Create GUI for every menu defined

> Graphical User Interface was designed for the sake of librarian ease. Third party library `tkinter` and `pillow` serve as building block for this app GUI. `Tkinter` is GUI builder which comprises of `frame or canvas` and `children or widget` which arraged using `layout manager` method, and `pillow` was use so we could insert some image to the GUI.<br>

>`Object Oriented Program` style was mainly used to develop this GUI app. Every `menu group` in this app designed to be encapsulated into one class, then every `menu` will be act as instance of this class. Inside every class, `frame` and `widget` are arranged to construct GUI, function from connector then embeded to specific `widget` to connect GUI to database. Here is the list of class and instance in `lib-management-gui-app.py`
<p align=center>
<table>
    <thead>
        <tr>
            <th>Class</th>
            <th>Instance</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>LoginPage</td>
            <td>app</td>
        </tr>
        <tr>
            <td>StartPage</td>
            <td>start_page</td>
        </tr>
        <tr>
            <td>UserRegistration</td>
            <td>user_registration</td>
        </tr>
        <tr>
            <td>BookRegistration</td>
            <td>book_registration</td>
        </tr>
        <tr>
            <td rowspan=4>Show</td>
            <td>show_users</td>
        </tr>
        <tr>
            <td>show_books</td>
        </tr>
                <tr>
            <td>show_loans</td>
        </tr>
                <tr>
            <td>show_returns</td>
        </tr>
        <tr>
            <td rowspan=2>Search</td>
            <td>search_user</td>
        </tr>
        <tr>
            <td>search_book</td>
        </tr>
        <tr>
            <td rowspan=2>BookTransaction</td>
            <td>loan_book</td>
        </tr>
        <tr>
            <td>return_book</td>
        </tr>
        <tr>
            <td rowspan=2>DeleteUser</td>
            <td>delete_user</td>
        </tr>
    </tbody>
</table>
</p>

### 6. Test, correct, update, and enhance the code defense
>After GUI, connector, and database finish and whole program can be executed, then development continued to test the application. Several error was foound when developing, but that was good to enhance the application defence to false input from the user, and make sure the application function as intended. After this step every menu now have a `good defense` if librarian fail to input necessary data to the database. 

### 7. Create the executable file
<p align="center"><img height=150 src="image/pyinstaller.jpg"></p>

>`PyInstaller` them utilized to create the executable file for the `SAT Library Manager System` application. This third party library convert `.py` file into `.exe` file. It is suitable for this app development. The output then become fully operational application `lib-management-app.exe`.  

## Application Menu
### 1. Login Page
> <p align="center"><img width=500 src="image/login_page.jpg"></p>

> `Login page` require to input your installed mysql database credential (username and password). After you click login then you will move to the main page, and in you click `Log Off` at main page, you will be back into this `login page`. 

### 2. Main Page
> <p align="center"><img width=500 src="image/start_page.jpg"></p>

> `Main page` contains all menu. This menu is the result of defined requirement for the application. From this page you can navigate to any other page by clicking menu button. To go back to this page after entering another page, you can click `Back` button in every page.   

### 3. New User Registration
><p align="center"><img width=500 src="image/user_regis.jpg"></p>

> `User Registration` page is use to input new libary member data. This page will fill `lib_user` table inside the `library` database through button `submit`. Librarian have to fill the label with * button, if not the data wont enter the database. `Clear` button use to clear the entry registration that hasn't been sumbitted. Every `Clearn` button behave similar for every page in this app.  

### 4. New Book Registration
><p align="center"><img width=500 src="image/book_regis.jpg"></p>

> `Book Registration` page is use to input library new book data. This page will fill `book` table inside the `library` database. Behaviour of this page similar to `New User Registration` page.

### 5. Show List of User
><p align="center"><img width=500 src="image/user_list.jpg"></p>

> `List User` page shows list of user data registered to the library. This page take data from `lib_user` table in the `library` database.   

### 6. Show List of Book
><p align="center"><img width=500 src="image/book_list.jpg"></p>

> `List Book` page shows list of book data registered to the library. This page take data from `book` table in the `library` database.

### 7. Show List of Loan
><p align="center"><img width=500 src="image/loan_list.jpg"></p>

> `List Loan` page shows list of loaned book and it's status, whether it is has been returned or not. This page take data from `loan` table in the `library` database.

### 8. Show List of Return
><p align="center"><img width=500 src="image/returned_book.jpg"></p>

>`List Return` page shows returned book to library. This page take data from `loan` table with some filter in the querry.

### 9. Search User by Name
><p align="center"><img width=500 src="image/search_user.jpg"></p>

>`Search user by name` page function as search menu to registered user data in the library. Using `regex` we could search user by its name in the list of user registered. If librarian false to input the keyword, if will prompt error on the page, tell the librarian that the input is wrong. 

### 10. Seach Book by Name
><p align="center"><img width=500 src="image/search_book.jpg"></p>

>`Search book by name` page function as seach menu to registered book in the library. This page behaves similarly to `Search book by name` page.

### 11. Loan Book
><p align="center"><img width=500 src="image/loan_menu.jpg"></p>

>`Loan book` page is use if any member want to loan book from the library. This page will input data to `loan` table in the database. Librarian need to select `user_id` and `book_id` for this page. Fail to input this id, page will prompt error to librarian.

### 12. Return Book
><p align="center"><img width=500 src="image/return_book.jpg"></p>

>`Return book` page is use if any member want to return the book to the library. The book list will show only the book that borrowed by the library member. Fail to input this id, page will prompt error to librarian.

### 13. Clear User
><p align="center"><img width=500 src="image/clear_user.jpg"></p>

> `Clear user` page is use if anyone want to exit from library user and librarian need to erase user data from the library. First to note that the member have to be `returned all the book` first, unless the member data cannot be erased from the database. Fail to input this id, page will prompt error to librarian.

## How to Use This Program
1. make sure you have `python`, `pip`, and `mysql` inside your local system
2. install third party module prequisit for the application : `Tkinter`, `pillow`, and `MySQL Connector` from local terminal : 
> - Tkinter : `pip install tk`
> - Pillow : `pip install Pillow`
> - MySQL Connector : `pip install mysql-connector-python`
3. clone this repository into local device, you will get `Library-Management-System` folder 
4. execute the `library-management-db.sql` script inside your mysql workbench to create the database, table and dummy data for this application.
5. execute the library-management-gui-app.py from the terminal using python from `Library-Management-System` folder 
> - `python library-management-gui-app.py`
6. then you will get this application fully operational
7. or just clone this repository, execute the `library-management-db.sql` in mysql, and run the `SAT-LMS-App.exe` in your local device for windows OS user. Or you can get [`Wine`](https://www.wikihow.com/Can-Linux-Run-Exe) for Unix based OS. Note there will be secority prompt to run this .exe file on windows, not tested on unix.

## Suggestion
It will be interesting if development continued by using UI/UX app such as [`figma`](https://www.figma.com/) or [`sketch`](https://www.sketch.com/). Also it will be very powerfull if the data is already huge, the development can be continued to analysis the transaction data, to know the user characteristic about certain book category. Just my opinion

If you have any other comment you can email-me on yudi.stefanus22@gmail.com or contact me through [my Linkedin](https://www.linkedin.com/in/stefanusyudi22/). Enjoyy....


