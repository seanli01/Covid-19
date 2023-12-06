import dash
import dash_core_components as dcc
import dash_html_components as html
from dash.dependencies import Input, Output
import plotly.express as px
import pyodbc
import pandas as pd
import datetime
app = dash.Dash(__name__)
conn = pyodbc.connect('Driver={SQL Server};'
                      'Server=hongbo;'
                      'Database=covid;'
                      'Trusted_Connection=yes;')

df = pd.read_sql_query("Select * from FactCovid", conn)
print(df)
conn.close()


# app layout ------------------------------------

app.layout = html.Div([
    html.H1('Daily Covid 19 Cases per Country', style={'text-align': 'center'}),

    dcc.Dropdown(id="slct_country",
                 options=[
                        {"label": "Afghanistan", "value": 1},
                        {"label": "Albania", "value": 2},
                        {"label": "Algeria", "value": 3},
                        {"label": "Andorra", "value": 4},
                        {"label": "Angola", "value": 5},
                        {"label": "Anguilla", "value": 6},
                        {"label": "AntiguaandBarbuda", "value": 7},
                        {"label": "Argentina", "value": 8},
                        {"label": "Armenia", "value": 9},
                        {"label": "Aruba", "value": 10},
                        {"label": "Australia", "value": 11},
                        {"label": "Austria", "value": 12},
                        {"label": "Azerbaijan", "value": 13},
                        {"label": "Bahamas", "value": 14},
                        {"label": "Bahrain", "value": 15},
                        {"label": "Bangladesh", "value": 16},
                        {"label": "Barbados", "value": 17},
                        {"label": "Belarus", "value": 18},
                        {"label": "Belgium", "value": 19},
                        {"label": "Belize", "value": 20},
                        {"label": "Benin", "value": 21},
                        {"label": "Bermuda", "value": 22},
                        {"label": "Bhutan", "value": 23},
                        {"label": "Bolivia", "value": 24},
                        {"label": "BonaireSintEustatiusandSaba", "value": 25},
                        {"label": "BosniaandHerzegovina", "value": 26},
                        {"label": "Botswana", "value": 27},
                        {"label": "Brazil", "value": 28},
                        {"label": "BritishVirginIslands", "value": 29},
                        {"label": "Brunei", "value": 30},
                        {"label": "Bulgaria", "value": 31},
                        {"label": "BurkinaFaso", "value": 32},
                        {"label": "Burundi", "value": 33},
                        {"label": "Cambodia", "value": 34},
                        {"label": "Cameroon", "value": 35},
                        {"label": "Canada", "value": 36},
                        {"label": "CapeVerde", "value": 37},
                        {"label": "CaymanIslands", "value": 38},
                        {"label": "CentralAfricanRepublic", "value": 39},
                        {"label": "Chad", "value": 40},
                        {"label": "Chile", "value": 41},
                        {"label": "China", "value": 42},
                        {"label": "Colombia", "value": 43},
                        {"label": "Comoros", "value": 44},
                        {"label": "Congo", "value": 45},
                        {"label": "CostaRica", "value": 46},
                        {"label": "CotedIvoire", "value": 47},
                        {"label": "Croatia", "value": 48},
                        {"label": "Cuba", "value": 49},
                        {"label": "Curacao", "value": 50},
                        {"label": "Cyprus", "value": 51},
                        {"label": "CzechRepublic", "value": 52},
                        {"label": "DemocraticRepublicofCongo", "value": 53},
                        {"label": "Denmark", "value": 54},
                        {"label": "Djibouti", "value": 55},
                        {"label": "Dominica", "value": 56},
                        {"label": "DominicanRepublic", "value": 57},
                        {"label": "Ecuador", "value": 58},
                        {"label": "Egypt", "value": 59},
                        {"label": "ElSalvador", "value": 60},
                        {"label": "EquatorialGuinea", "value": 61},
                        {"label": "Eritrea", "value": 62},
                        {"label": "Estonia", "value": 63},
                        {"label": "Ethiopia", "value": 64},
                        {"label": "FaeroeIslands", "value": 65},
                        {"label": "FalklandIslands", "value": 66},
                        {"label": "Fiji", "value": 67},
                        {"label": "Finland", "value": 68},
                        {"label": "France", "value": 69},
                        {"label": "FrenchPolynesia", "value": 70},
                        {"label": "Gabon", "value": 71},
                        {"label": "Gambia", "value": 72},
                        {"label": "Georgia", "value": 73},
                        {"label": "Germany", "value": 74},
                        {"label": "Ghana", "value": 75},
                        {"label": "Gibraltar", "value": 76},
                        {"label": "Greece", "value": 77},
                        {"label": "Greenland", "value": 78},
                        {"label": "Grenada", "value": 79},
                        {"label": "Guam", "value": 80},
                        {"label": "Guatemala", "value": 81},
                        {"label": "Guernsey", "value": 82},
                        {"label": "Guinea", "value": 83},
                        {"label": "GuineaBissau", "value": 84},
                        {"label": "Guyana", "value": 85},
                        {"label": "Haiti", "value": 86},
                        {"label": "Honduras", "value": 87},
                        {"label": "Hungary", "value": 88},
                        {"label": "Iceland", "value": 89},
                        {"label": "India", "value": 90},
                        {"label": "Indonesia", "value": 91},
                        {"label": "Iran", "value": 93},
                        {"label": "Iraq", "value": 94},
                        {"label": "Ireland", "value": 95},
                        {"label": "IsleofMan", "value": 96},
                        {"label": "Israel", "value": 97},
                        {"label": "Italy", "value": 98},
                        {"label": "Jamaica", "value": 99},
                        {"label": "Japan", "value": 100},
                        {"label": "Jersey", "value": 101},
                        {"label": "Jordan", "value": 102},
                        {"label": "Kazakhstan", "value": 103},
                        {"label": "Kenya", "value": 104},
                        {"label": "Kosovo", "value": 105},
                        {"label": "Kuwait", "value": 106},
                        {"label": "Kyrgyzstan", "value": 107},
                        {"label": "Laos", "value": 108},
                        {"label": "Latvia", "value": 109},
                        {"label": "Lebanon", "value": 110},
                        {"label": "Lesotho", "value": 111},
                        {"label": "Liberia", "value": 112},
                        {"label": "Libya", "value": 113},
                        {"label": "Liechtenstein", "value": 114},
                        {"label": "Lithuania", "value": 115},
                        {"label": "Luxembourg", "value": 116},
                        {"label": "Macedonia", "value": 117},
                        {"label": "Madagascar", "value": 118},
                        {"label": "Malawi", "value": 119},
                        {"label": "Malaysia", "value": 120},
                        {"label": "Maldives", "value": 121},
                        {"label": "Mali", "value": 122},
                        {"label": "Malta", "value": 123},
                        {"label": "Mauritania", "value": 124},
                        {"label": "Mauritius", "value": 125},
                        {"label": "Mexico", "value": 126},
                        {"label": "Moldova", "value": 127},
                        {"label": "Monaco", "value": 128},
                        {"label": "Mongolia", "value": 129},
                        {"label": "Montenegro", "value": 130},
                        {"label": "Montserrat", "value": 131},
                        {"label": "Morocco", "value": 132},
                        {"label": "Mozambique", "value": 133},
                        {"label": "Myanmar", "value": 134},
                        {"label": "Namibia", "value": 135},
                        {"label": "Nepal", "value": 136},
                        {"label": "Netherlands", "value": 137},
                        {"label": "NewCaledonia", "value": 138},
                        {"label": "NewZealand", "value": 139},
                        {"label": "Nicaragua", "value": 140},
                        {"label": "Niger", "value": 141},
                        {"label": "Nigeria", "value": 142},
                        {"label": "NorthernMarianaIslands", "value": 143},
                        {"label": "Norway", "value": 144},
                        {"label": "Oman", "value": 145},
                        {"label": "Pakistan", "value": 146},
                        {"label": "Palestine", "value": 147},
                        {"label": "Panama", "value": 148},
                        {"label": "PapuaNewGuinea", "value": 149},
                        {"label": "Paraguay", "value": 150},
                        {"label": "Peru", "value": 151},
                        {"label": "Philippines", "value": 152},
                        {"label": "Poland", "value": 153},
                        {"label": "Portugal", "value": 154},
                        {"label": "PuertoRico", "value": 155},
                        {"label": "Qatar", "value": 156},
                        {"label": "Romania", "value": 157},
                        {"label": "Russia", "value": 158},
                        {"label": "Rwanda", "value": 159},
                        {"label": "SaintKittsandNevis", "value": 160},
                        {"label": "SaintLucia", "value": 161},
                        {"label": "SaintVincentandtheGrenadines", "value": 162},
                        {"label": "SanMarino", "value": 163},
                        {"label": "SaoTomeandPrincipe", "value": 164},
                        {"label": "SaudiArabia", "value": 165},
                        {"label": "Senegal", "value": 166},
                        {"label": "Serbia", "value": 167},
                        {"label": "Seychelles", "value": 168},
                        {"label": "SierraLeone", "value": 169},
                        {"label": "Singapore", "value": 170},
                        {"label": "SintMaartenDutchpart", "value": 171},
                        {"label": "Slovakia", "value": 172},
                        {"label": "Slovenia", "value": 173},
                        {"label": "Somalia", "value": 174},
                        {"label": "SouthAfrica", "value": 175},
                        {"label": "SouthKorea", "value": 176},
                        {"label": "SouthSudan", "value": 177},
                        {"label": "Spain", "value": 178},
                        {"label": "SriLanka", "value": 179},
                        {"label": "Sudan", "value": 180},
                        {"label": "Suriname", "value": 181},
                        {"label": "Swaziland", "value": 182},
                        {"label": "Sweden", "value": 183},
                        {"label": "Switzerland", "value": 184},
                        {"label": "Syria", "value": 185},
                        {"label": "Taiwan", "value": 186},
                        {"label": "Tajikistan", "value": 187},
                        {"label": "Tanzania", "value": 188},
                        {"label": "Thailand", "value": 189},
                        {"label": "Timor", "value": 190},
                        {"label": "Togo", "value": 191},
                        {"label": "TrinidadandTobago", "value": 192},
                        {"label": "Tunisia", "value": 193},
                        {"label": "Turkey", "value": 194},
                        {"label": "TurksandCaicosIslands", "value": 195},
                        {"label": "Uganda", "value": 196},
                        {"label": "Ukraine", "value": 197},
                        {"label": "UnitedArabEmirates", "value": 198},
                        {"label": "UnitedKingdom", "value": 199},
                        {"label": "UnitedStates", "value": 200},
                        {"label": "UnitedStatesVirginIslands", "value": 201},
                        {"label": "Uruguay", "value": 202},
                        {"label": "Uzbekistan", "value": 203},
                        {"label": "Vatican", "value": 204},
                        {"label": "Venezuela", "value": 205},
                        {"label": "Vietnam", "value": 206},
                        {"label": "WesternSahara", "value": 207},
                        {"label": "Yemen", "value": 208},
                        {"label": "Zambia", "value": 209},
                        {"label": "Zimbabwe", "value": 210}],
                 multi = False,
                 value = 1,
                 style={'width': "40%"} ),
    html.Div(id='output_container', children=[]),
    html.Br(),


    dcc.Graph(id="daily_cases", figure={})



])
#------------------------------------ connecting graphs with dash

@app.callback(
    [Output(component_id = 'output_container', component_property = 'children'),
     Output(component_id = 'daily_cases', component_property= 'figure')],
    [Input(component_id= 'slct_country', component_property= 'value')]
)

def update_graph(option_selected):
    print(option_selected)
    print(type(option_selected))
    today =   datetime.date.today()

    container = 'The country chosen by the user was: {}'.format(option_selected)
    dff = df.copy()
    dff = dff[dff['CountryKey'] == option_selected]


    dff["DateKey"] = dff["DateKey"].astype(str)
    dff["DateKey"] = pd.to_datetime(dff['DateKey'], format='%Y/%m/%d')
    print(dff)



    fig = px.line(
       data_frame= dff,
        x= 'DateKey',
        y = 'TotalCases'
        #range_x = [20191231, int(today.strftime('%Y%m%d'))]
    )



    return container, fig



if __name__ == '__main__':
    app.run_server(debug=True)