import pyodbc


conn = pyodbc.connect(
    "Driver={SQL Server};"
    "Server=hongbo;"
    "Database=pubs;"
    "Trusted_Connection =yes;"
)

con = pyodbc.connect(
    "Driver={SQL Server};"
    "Server=hongbo;"
    "Database=pubs;"
    "Trusted_Connection =yes;"
)

def read(conn):
    print("read")

    cursor = conn.cursor()
    cursor.execute('select * from stores')
    for row in cursor:
        print(row)






read(conn)

conn.close()