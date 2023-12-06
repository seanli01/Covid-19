import pyodbc
import datetime

targetData = pyodbc.connect(
    "Driver={SQL Server};"
    "Server=hongbo;"
    "Database=datawarehousesample;"
    "Trusted_Connection =yes;"

)


def logging(conn, logging_info, cursor):
    insert_q = '''
            INSERT INTO [datawarehousesample].[logs].[Log_Examples_Task](ETL_ID,ETL_Task_Name, StartTime, EndTime,Error_Flag
            ,Error_msg)
            VALUES (?,?,?,?,?,?);'''
    values = (logging_info['ETL_ID'], logging_info['ETL_Task_Name'], logging_info['StartTime'],
              logging_info['EndTime'], logging_info['Error_Flag'], logging_info['Error_msg'])

    cursor.execute(insert_q, values)

    conn.commit()

def dropKey(conn, etl_id):
    logging_info = {'ETL_ID': etl_id}
    logging_info['ETL_Task_Name'] = 'Dropping Keys'
    logging_info['StartTime'] = (datetime.datetime.now())
    cursor = conn.cursor()
    try:
        print("Dropping foreign keys")
        sqlFile=open("removeConstraints.sql")
        stringSql =sqlFile.read()
        cursor.execute(stringSql)
        logging_info['EndTime'] = (datetime.datetime.now())
        logging_info['Error_Flag'] = False
        logging_info['Error_msg'] = ""

        logging(conn,logging_info,cursor)


    except Exception as errors:

        logging_info['EndTime'] = (datetime.datetime.now())
        logging_info['Error_Flag'] = True
        logging_info["Error_msg"] = str(errors)
        logging(conn, logging_info, cursor)



    return logging_info


def truncate(conn,etl_id):
    logging_info = {'ETL_ID': etl_id}
    logging_info['ETL_Task_Name'] = 'Truncating Tables'
    logging_info['StartTime'] = (datetime.datetime.now())
    cursor = conn.cursor()
    try:
        print('Truncating tables')
        sqlFile = open("truncateTables.sql")
        stringSql = sqlFile.read()
        cursor.execute(stringSql)
        logging_info['EndTime'] = (datetime.datetime.now())
        logging_info['Error_Flag'] = False
        logging_info['Error_msg'] = ""

        logging(conn, logging_info, cursor)

    except Exception as errors:
        logging_info['EndTime'] = (datetime.datetime.now())
        logging_info['Error_Flag'] = True
        logging_info["Error_msg"] = str(errors)
        logging(conn, logging_info, cursor)
    return logging_info

def dimDates(conn,etl_id):
    logging_info = {'ETL_ID': etl_id}
    logging_info['ETL_Task_Name'] = 'DimensionDates'
    logging_info['StartTime'] = (datetime.datetime.now())
    cursor = conn.cursor()
    try:
        print('Populating dimDates table')
        sqlFile = open("dateWhileLoop.sql")
        stringSql = sqlFile.read()
        cursor.execute(stringSql)
        logging_info['EndTime'] = (datetime.datetime.now())
        logging_info['Error_Flag'] = False
        logging_info['Error_msg'] = ""

        logging(conn, logging_info, cursor)

    except Exception as errors:
        logging_info['EndTime'] = (datetime.datetime.now())
        logging_info['Error_Flag'] = True
        logging_info["Error_msg"] = str(errors)
        logging(conn, logging_info, cursor)
    return logging_info


def unknownDates(conn,etl_id):
    logging_info = {'ETL_ID': etl_id}
    logging_info['ETL_Task_Name'] = 'Accounting for unknown dates'
    logging_info['StartTime'] = (datetime.datetime.now())
    cursor = conn.cursor()
    try:
        print('Unknown Dates')
        sqlFile = open("addingUnknownDate.sql")
        stringSql = sqlFile.read()
        cursor.execute(stringSql)
        logging_info['EndTime'] = (datetime.datetime.now())
        logging_info['Error_Flag'] = False
        logging_info['Error_msg'] = ""

        logging(conn, logging_info,cursor)

    except Exception as errors:
        logging_info['EndTime'] = (datetime.datetime.now())
        logging_info['Error_Flag'] = True
        logging_info["Error_msg"] = str(errors)
        logging(conn, logging_info, cursor)

    return logging_info

def dimAuthors(conn, etl_id):
    logging_info = {'ETL_ID': etl_id}
    logging_info['ETL_Task_Name'] = 'Populating dimAuthors table'
    logging_info['StartTime'] = (datetime.datetime.now())
    cursor = conn.cursor()
    try:
        print('Populating dimAuthors table')
        sqlFile = open("PopDimAuthor5.sql")
        stringSql = sqlFile.read()
        cursor.execute(stringSql)
        logging_info['EndTime'] = (datetime.datetime.now())
        logging_info['Error_Flag'] = False
        logging_info['Error_msg'] = ""

        logging(conn, logging_info, cursor)

    except Exception as errors:
        logging_info['EndTime'] = (datetime.datetime.now())
        logging_info['Error_Flag'] = True
        logging_info["Error_msg"] = str(errors)
        logging(conn, logging_info, cursor)

    return logging_info

def dimPub(conn,etl_id):
    logging_info = {'ETL_ID': etl_id}
    logging_info['ETL_Task_Name'] = 'Populating dimPub table'
    logging_info['StartTime'] = (datetime.datetime.now())
    cursor = conn.cursor()
    try:

        print('Populating dimPub table')
        sqlFile = open("PopDimPub6.sql")
        stringSql = sqlFile.read()
        cursor.execute(stringSql)
        logging_info['EndTime'] = (datetime.datetime.now())
        logging_info['Error_Flag'] = False
        logging_info['Error_msg'] = ""
        logging(conn, logging_info, cursor)

    except Exception as errors:
        logging_info['EndTime'] = (datetime.datetime.now())
        logging_info['Error_Flag'] = True
        logging_info["Error_msg"] = str(errors)
        logging(conn, logging_info, cursor)


    return logging_info

def dimTitles(conn,etl_id):
    logging_info = {'ETL_ID': etl_id}
    logging_info['ETL_Task_Name'] = 'Populating dimTitles table'
    logging_info['StartTime'] = (datetime.datetime.now())
    cursor = conn.cursor()
    try:
        print('Populating dimTitles table')
        sqlFile = open("PopDimTitles7.sql")
        stringSql = sqlFile.read()
        cursor.execute(stringSql)
        logging_info['EndTime'] = (datetime.datetime.now())
        logging_info['Error_Flag'] = False
        logging_info['Error_msg'] = ""
        logging(conn, logging_info, cursor)

    except Exception as errors:
        logging_info['EndTime'] = (datetime.datetime.now())
        logging_info['Error_Flag'] = True
        logging_info["Error_msg"] = str(errors)
        logging(conn, logging_info, cursor)


    return logging_info

def dimStores(conn, etl_id):
    logging_info = {'ETL_ID': etl_id}
    logging_info['ETL_Task_Name'] = 'Populating dimStores table'
    logging_info['StartTime'] = (datetime.datetime.now())
    cursor = conn.cursor()
    try:
        print('Populating dimStores table')
        sqlFile = open("PopDimStores8.sql")
        stringSql = sqlFile.read()
        cursor.execute(stringSql)
        logging_info['EndTime'] = (datetime.datetime.now())
        logging_info['Error_Flag'] = False
        logging_info['Error_msg'] = ""
        logging(conn, logging_info, cursor)

    except Exception as errors:
        logging_info['EndTime'] = (datetime.datetime.now())
        logging_info['Error_Flag'] = True
        logging_info["Error_msg"] = str(errors)
        logging(conn, logging_info, cursor)
    return logging_info

def factTitlesAuthorsSales(conn,etl_id):
    logging_info = {'ETL_ID': etl_id}
    logging_info['ETL_Task_Name'] = 'Populating fact tables'
    logging_info['StartTime'] = (datetime.datetime.now())
    cursor = conn.cursor()
    try:

        print('Populating fact tables')
        sqlFile = open("PopFactTitlesAuthorAndSales910.sql")
        stringSql = sqlFile.read()
        cursor.execute(stringSql)
        logging_info['EndTime'] = (datetime.datetime.now())
        logging_info['Error_Flag'] = False
        logging_info['Error_msg'] = ""
        logging(conn, logging_info, cursor)

    except Exception as errors:
        logging_info['EndTime'] = (datetime.datetime.now())
        logging_info['Error_Flag'] = True
        logging_info["Error_msg"] = str(errors)
        logging(conn, logging_info, cursor)


    return logging_info






targetData.close()