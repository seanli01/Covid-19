import pyodbc 

conn = pyodbc.connect('Driver = {SQL Server Native Client 11.0};'
                      'Server=hongbo;'
                      'Database =pubs;'
                      'Trusted_Connection=yes')