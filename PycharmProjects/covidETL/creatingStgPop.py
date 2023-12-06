import pandas as pd
import pyodbc
def run():
    url = 'https://covid.ourworldindata.org/data/ecdc/locations.csv'
    df = pd.read_csv(url, index_col=None)



    conn = pyodbc.connect('Driver={SQL Server};'
                          'Server=hongbo;'
                          'Database=covid;'
                          'Trusted_Connection=yes;')
    cursor = conn.cursor()

    cursor.execute('''
    truncate table covid.dbo.stg_source_pop
    ''')

    df= df.fillna(value=0)


    df.replace(' ', '', regex=True, inplace=True)

    df.at[85,'location'] = 'GuineaBissau'
    df.at[172,'location'] = 'SintMaartenDutchpart'
    df.at[47,'location'] = 'CotedIvoire'
    for row in df.itertuples():

        cursor.execute(
            '''
            insert into covid.dbo.stg_source_pop(
            countriesAndTerritories,
            location,
            continent,
            population_year,
            population
            
            )
            values(
            ?,
            ?,
            ?,
            ?,
            ?
            
            
            )
    
            ''',
            row.countriesAndTerritories,
            row.location,
            row.continent,
            row.population_year,
            row.population

        )

        conn.commit()