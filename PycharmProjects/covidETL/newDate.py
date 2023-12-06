import pandas as pd
import pyodbc
import datetime

url = 'https://covid.ourworldindata.org/data/ecdc/total_cases.csv'
df = pd.read_csv(url, index_col=None)


conn = pyodbc.connect('Driver={SQL Server};'
                      'Server=hongbo;'
                      'Database=covid;'
                      'Trusted_Connection=yes;')
cursor = conn.cursor()



old_column_names = list(df.columns.values)

new_column_names = []


for column in old_column_names:

    new_column_names.append(column.replace(' ',''))

new_column_names[85] = "GuineaBissau"
new_column_names[172] = 'SintMaartenDutchpart'
new_column_names[48] = 'CotedIvoire'


df.rename(columns=dict(zip(old_column_names,new_column_names)), inplace=True)

cursor.execute('''
select format(MAX (date), 'yyyy-MM-dd') from [covid].[dbo].stg_source_total_cases
''')
recent_date = cursor.fetchall()





df2 = df.iloc[-1]

lastDate = df2.at['date']



recent_date = str(recent_date[0])
recent_date = recent_date.replace('(',"")
recent_date = recent_date.replace(' ','')
recent_date = recent_date.replace("'", '')
recent_date = recent_date.replace(')', '')
recent_date = recent_date.replace(',', '')



print(lastDate)

print(recent_date)


if recent_date == lastDate:
    pass

else:
    pass