import pyodbc
import datetime
import creatingStgNewDeaths
import creatingStgPop
import creatingStgTotDeaths
import creatingStgNewCases
import importWeb
import os

conn = pyodbc.connect('Driver={SQL Server};'
                      'Server=hongbo;'
                      'Database=covid;'
                      'Trusted_Connection=yes;')


def logging(conn, logging_info, cursor):
    insert_q = '''
            INSERT INTO [covid].[logs].[Log_Examples_Task](ETL_ID,ETL_Task_Name, StartTime, EndTime,Error_Flag
            ,Error_msg)
            VALUES (?,?,?,?,?,?);'''
    values = (logging_info['ETL_ID'], logging_info['ETL_Task_Name'], logging_info['StartTime'],
              logging_info['EndTime'], logging_info['Error_Flag'], logging_info['Error_msg'])

    cursor.execute(insert_q, values)

    conn.commit()


def stagingTables(conn, etl_id):
    logging_info = {'ETL_ID': etl_id}
    logging_info['ETL_Task_Name'] = 'Updating Staging Tables'
    logging_info['StartTime'] = (datetime.datetime.now())
    cursor = conn.cursor()
    try:
        print("Updating Staging Tables")
        importWeb.run()
        creatingStgTotDeaths.run()
        creatingStgTotDeaths.run()
        creatingStgNewDeaths.run()
        creatingStgNewCases.run()
        creatingStgPop.run()
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

def DimCountry(conn, etl_id):
    logging_info = {'ETL_ID': etl_id}
    logging_info['ETL_Task_Name'] = 'Populating DimCountry'
    logging_info['StartTime'] = (datetime.datetime.now())
    cursor = conn.cursor()
    try:
        print("Populating DimCountry")

        os.chdir(r'C:\Users\Admin\PycharmProjects\covidETL') # No such file or directory
        sqlFile = open("popDimCountry.sql")
        stringSql = sqlFile.read()
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


def FactCovidTotCases(conn, etl_id):
    logging_info = {'ETL_ID': etl_id}
    logging_info['ETL_Task_Name'] = 'Populating FactCovid Total Cases'
    logging_info['StartTime'] = (datetime.datetime.now())
    cursor = conn.cursor()
    try:
        print("Populating FactCovid for Total Cases")
        sqlFile = open("PopFactCovidSetup.sql")
        stringSql = sqlFile.read()
        cursor.execute(stringSql)
        print('1')

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


def FactCovidNewCases(conn, etl_id):
    logging_info = {'ETL_ID': etl_id}
    logging_info['ETL_Task_Name'] = 'Populating FactCovid New Cases'
    logging_info['StartTime'] = (datetime.datetime.now())
    cursor = conn.cursor()
    try:
        print("Populating FactCovid for New Cases")
        sqlFile = open("PopFactCovidNewCases.sql")
        stringSql = sqlFile.read()
        cursor.execute(stringSql)


        logging_info['EndTime'] = (datetime.datetime.now())
        logging_info['Error_Flag'] = False
        logging_info['Error_msg'] = ""

        logging(conn,logging_info,cursor)
        print('2')

    except Exception as errors:

        logging_info['EndTime'] = (datetime.datetime.now())
        logging_info['Error_Flag'] = True
        logging_info["Error_msg"] = str(errors)
        logging(conn, logging_info, cursor)
        print('1')



    return logging_info



def FactCovidNewDeaths(conn, etl_id):
    logging_info = {'ETL_ID': etl_id}
    logging_info['ETL_Task_Name'] = 'Populating FactCovid New Deaths'
    logging_info['StartTime'] = (datetime.datetime.now())
    cursor = conn.cursor()
    try:
        print("Populating FactCovid for New Deaths")
        sqlFile = open("PopFactCovidNewDeaths.sql")
        stringSql = sqlFile.read()
        cursor.execute(stringSql)
        print('1')

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



def FactCovidTotDeaths(conn, etl_id):
    logging_info = {'ETL_ID': etl_id}
    logging_info['ETL_Task_Name'] = 'Populating FactCovid Total Deaths'
    logging_info['StartTime'] = (datetime.datetime.now())
    cursor = conn.cursor()
    try:
        print("Populating FactCovid for Total Deaths")
        sqlFile = open("PopFactCovidTotDeaths.sql")
        stringSql = sqlFile.read()
        cursor.execute(stringSql)
        print('1')

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


def FactPopulation(conn, etl_id):
    logging_info = {'ETL_ID': etl_id}
    logging_info['ETL_Task_Name'] = 'Populating FactPopulation'
    logging_info['StartTime'] = (datetime.datetime.now())
    cursor = conn.cursor()

    try:
        print("Populating FactPopulation")
        sqlFile = open("PopFactPopulation.sql")

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

