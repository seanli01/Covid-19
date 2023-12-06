import pyodbc
import CovidEtlFunctions as covid
import datetime


conn = pyodbc.connect('Driver={SQL Server};'
                      'Server=hongbo;'
                      'Database=covid;'
                      'Trusted_Connection=yes;')

conn2 = pyodbc.connect('Driver={SQL Server};'
                      'Server=hongbo;'
                      'Database=covid;'
                      'Trusted_Connection=yes;')



conn3 = pyodbc.connect('Driver={SQL Server};'
                      'Server=hongbo;'
                      'Database=covid;'
                      'Trusted_Connection=yes;')



conn4 = pyodbc.connect('Driver={SQL Server};'
                      'Server=hongbo;'
                      'Database=covid;'
                      'Trusted_Connection=yes;')


conn5 = pyodbc.connect('Driver={SQL Server};'
                      'Server=hongbo;'
                      'Database=covid;'
                      'Trusted_Connection=yes;')

def logging(conn, logging_info, cursor):
    insert_q = '''
            INSERT INTO [covid].[logs].[Log_Examples_ETL](Source_ID, StartTime, EndTime,Error_Flag
         )
            VALUES (?,?,?,?);'''
    values = (logging_info['Source_ID'],logging_info['StartTime'],
              logging_info['EndTime'], logging_info['Error_Flag'])

    cursor.execute(insert_q, values)

    conn.commit()


def etl(conn):
    logging_info ={}
    logging_info['StartTime'] = (datetime.datetime.now())
    logging_info['Source_ID'] = 1
    logging_info['Source_Type'] = 'database'
    cursor = conn.cursor()
    cursor.execute('select max(ETL_ID) from [covid].[logs].[Log_Examples_ETL]'
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
        task = covid.stagingTables(conn,id)
        if task['Error_Flag'] == True:
            fail = 1/0

        task = covid.DimCountry(conn,id)
        if task['Error_Flag'] == True:
            fail = 1/0

        task = covid.FactCovidTotCases(conn,id)
        if task['Error_Flag'] == True:
            fail = 1/0

        task = covid.FactCovidNewCases(conn2, id)
        if task['Error_Flag'] == True:
            fail = 1 / 0

        task = covid.FactCovidNewDeaths(conn3, id)
        if task['Error_Flag'] == True:
            fail = 1 / 0

        task = covid.FactCovidTotDeaths(conn4, id)
        if task['Error_Flag'] == True:
            fail = 1 / 0

        task = covid.FactPopulation(conn5,id)
        print(task)
        if task['Error_Flag'] == True:
            fail = 1/0

        logging_info['Error_Flag'] = False
        logging_info['EndTime'] = (datetime.datetime.now())
        logging(conn, logging_info, cursor)
        print('done')

    except Exception:
        logging_info['Error_Flag'] = True
        logging_info['EndTime'] = (datetime.datetime.now())
        logging(conn, logging_info, cursor)






etl(conn)


conn.close()
conn2.close()
conn3.close()
conn4.close()
conn5.close()