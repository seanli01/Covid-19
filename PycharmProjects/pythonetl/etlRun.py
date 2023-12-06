import etlFunctions as e
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
            INSERT INTO [datawarehousesample].[logs].[Log_Examples_ETL](Source_ID,Source_Type, StartTime, EndTime,
            Error_Flag)
            VALUES (?,?,?,?,?);'''
    values = (logging_info['Source_ID'], logging_info['Source_Type'], logging_info['StartTime'],
              logging_info['EndTime'], logging_info['Error_Flag'])

    cursor.execute(insert_q, values)

    conn.commit()


def etl(conn):
    logging_info ={}
    logging_info['StartTime'] = (datetime.datetime.now())
    logging_info['Source_ID'] = 1
    logging_info['Source_Type'] = 'database'
    cursor = conn.cursor()
    cursor.execute('select max(ETL_ID) from [datawarehousesample].[logs].[Log_Examples_ETL]'
                   )
    counter = 0
    for row in cursor:
        counter = row
    id = counter[0]


    if id is None:
        id = 1

    else:
        id = int(id) + 1
    try:
        task = e.dropKey(conn,id)
        if task['Error_Flag'] == True:
            fail = 1/0
        task = e.truncate(conn,id)
        if task['Error_Flag'] == True:
            fail = 1/0

        task = e.dimDates(conn,id)
        if task['Error_Flag'] == True:
            fail = 1/0
        task = e.unknownDates(conn,id)
        if task['Error_Flag'] == True:
            fail = 1/0
        task = e.dimAuthors(conn,id)
        if task['Error_Flag'] == True:
            fail = 1/0
        task = e.dimPub(conn,id)
        if task['Error_Flag'] == True:
            fail = 1/0
        task = e.dimTitles(conn,id)
        if task['Error_Flag'] == True:
            fail = 1/0
        task = e.dimStores(conn,id)
        if task['Error_Flag'] == True:
            fail = 1/0
        task = e.factTitlesAuthorsSales(conn,id)
        if task['Error_Flag'] == True:
            fail = 1/0
        logging_info['Error_Flag'] = False
        logging_info['EndTime'] = (datetime.datetime.now())
        logging(conn, logging_info, cursor)

    except Exception:
        logging_info['Error_Flag'] = True
        logging_info['EndTime'] = (datetime.datetime.now())
        logging(conn, logging_info, cursor)






etl(targetData)


targetData.close()