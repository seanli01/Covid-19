import pyodbc
import time

targetData = pyodbc.connect(
    "Driver={SQL Server};"
    "Server=hongbo;"
    "Database=datawarehousesample;"
    "Trusted_Connection =yes;"

)
def dropKey(conn):
    print("Dropping foreign keys")
    sqlFile=open("removeConstraints.sql")
    cursor = conn.cursor()
    stringSql =sqlFile.read()
    cursor.execute(stringSql)

def truncate(conn):
    print('Truncating tables')
    sqlFile = open("truncateTables.sql")
    cursor = conn.cursor()
    stringSql = sqlFile.read()
    cursor.execute(stringSql)

def dimDates(conn):
    print('Populating dimDates table')
    sqlFile = open("dateWhileLoop.sql")
    cursor = conn.cursor()
    stringSql = sqlFile.read()
    cursor.execute(stringSql)

def unknownDates(conn):
    print('Unknown Dates')
    sqlFile = open("addingUnknownDate.sql")
    cursor = conn.cursor()
    stringSql = sqlFile.read()
    cursor.execute(stringSql)

def dimAuthors(conn):
    print('Populating dimAuthors table')
    sqlFile = open("PopDimAuthor5.sql")
    cursor = conn.cursor()
    stringSql = sqlFile.read()
    cursor.execute(stringSql)

def dimPub(conn):
    print('Populating dimPub table')
    sqlFile = open("PopDimPub6.sql")
    cursor = conn.cursor()
    stringSql = sqlFile.read()
    cursor.execute(stringSql)

def dimTitles(conn):
    print('Populating dimTitles table')
    sqlFile = open("PopDimTitles7.sql")
    cursor = conn.cursor()
    stringSql = sqlFile.read()
    cursor.execute(stringSql)

def dimStores(conn):
    print('Populating dimStores table')
    sqlFile = open("PopDimStores8.sql")
    cursor = conn.cursor()
    stringSql = sqlFile.read()
    cursor.execute(stringSql)

def factTitlesAuthorsSales(conn):
    print('Populating fact tables')
    sqlFile = open("PopFactTitlesAuthorAndSales910.sql")
    cursor = conn.cursor()
    stringSql = sqlFile.read()
    cursor.execute(stringSql)

factTitlesAuthorsSales(targetData)

targetData.close()