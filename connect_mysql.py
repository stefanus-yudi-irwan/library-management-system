import mysql.connector
from mysql.connector import Error


def sql_execute(statement, host_name, user_name, password, db):
    """
    function to execute procedure listed in library database

    Args :
        statement : the procedure 
        host_name : host name, will be set to localhost
        user_name : database_user_name
        password : database_password
        db : database name, will be set to library
    
    Returns : None
    """
    mydb = mysql.connector.connect(host=host_name, user=user_name, passwd=password, database=db)
    mycursor = mydb.cursor()
    mycursor.execute(statement)
    mydb.commit()
    mycursor.close()


def retrieve_table(procedure, host_name, user_name, password, db):
    """
    function to retrieve table from database by executing procedure 
    inside the library database

    Args :
        statement : the procedure 
        host_name : host name, will be set to localhost
        user_name : database_user_name
        password : database_password
        db : database name, will be set to library

    Returns : 
        content_table : list of tuple containing table header[0] and content[1:]
    """
    mydb = mysql.connector.connect(host=host_name, user=user_name, passwd=password, database=db)
    mycursor = mydb.cursor()
    mycursor.execute(f"CALL {procedure}")
    headers = []
    for header in mycursor.description:
        headers.append(header[0])
    content_table = mycursor.fetchall()
    content_table.insert(0,tuple(headers))
    mycursor.close()
    return content_table


def retrieve_id_user(host_name, user_name, password, db):
    """
    function to retrieve id_user and full_name from lib_user table

    Args :
        host_name : host name, will be set to localhost
        user_name : database_user_name
        password : database_password
        db : database name, will be set to library

    Returns :
        id_user : list of string "id_user-full_name"
    """
    mydb = mysql.connector.connect(host=host_name, user=user_name, passwd=password, database=db)
    mycursor = mydb.cursor()
    mycursor.execute('SELECT id_user, CONCAT(first_name," ",last_name) AS full_name FROM lib_user')
    id_user = []
    for id_u, name_u in mycursor.fetchall():
        id_user.append(f"{id_u}-{name_u}")
    mycursor.close()
    return id_user


def retrieve_id_book(host_name, user_name, password, db):
    """
    function to retrieve id_book and title from book table where available

    Args : 
        host_name : host name, will be set to localhost
        user_name : database_user_name
        password : database_password
        db : database name, will be set to library

    Returns : 
        id_book : list of string "id_book-book_tile"
    """
    mydb = mysql.connector.connect(host=host_name, user=user_name, passwd=password, database=db)
    mycursor = mydb.cursor()
    mycursor.execute('SELECT id_book, title FROM book WHERE stock > 0')
    id_book = []
    for id_b, tit_b in mycursor.fetchall():
        id_book.append(f"{id_b}-{tit_b}")
    mycursor.close()
    return id_book


def retrieve_id_user_loan(host_name, user_name, password, db):
    """
    function to retrieve id_user and full_name from loan table

    Args :
        host_name : host name, will be set to localhost
        user_name : database_user_name
        password : database_password
        db : database name, will be set to library

    Returns : 
        id_user : list of string "id_user-full_name"
    """
    mydb = mysql.connector.connect(host=host_name, user=user_name, passwd=password, database=db)
    mycursor = mydb.cursor()
    mycursor.execute("SELECT DISTINCT id_user, user_name FROM loan WHERE returned='NOT YET'")
    id_user = []
    for id_u,name_u in mycursor.fetchall():
        id_user.append(f"{id_u}-{name_u}")
    mycursor.close()
    return id_user


def retrieve_id_book_loan(id_user, host_name, user_name, password, db):
    """
    function to retrive id_book and book_title from loan table for specific user

    Args :
        id_user : id_user of the library member 
        host_name : host name, will be set to localhost
        user_name : database_user_name
        password : database_password
        db : database name, will be set to library

    Returns : 
        id_book : list of string "id_book-book_tile"
    """
    mydb = mysql.connector.connect(host=host_name, user=user_name, passwd=password, database=db)
    mycursor = mydb.cursor()
    mycursor.execute(f"SELECT id_book, book_title FROM loan WHERE id_user={id_user} AND returned='NOT YET'")
    id_book = []
    for id_b, tit_b in mycursor.fetchall():
        id_book.append(f"{id_b}-{tit_b}")
    mycursor.close()
    return id_book
