import pandas as pd
import pyodbc

def run():



    url = 'https://covid.ourworldindata.org/data/ecdc/total_cases.csv'
    df = pd.read_csv(url, index_col=None)

    print(df)

    conn = pyodbc.connect('Driver={SQL Server};'
                          'Server=hongbo;'
                          'Database=covid;'
                          'Trusted_Connection=yes;')
    cursor = conn.cursor()

    cursor.execute('''
    truncate table covid.dbo.stg_source_total_cases
    ''')



    old_column_names = list(df.columns.values)

    new_column_names = []


    for column in old_column_names:

        new_column_names.append(column.replace(' ',''))

    new_column_names[85] = "GuineaBissau"
    new_column_names[172] = 'SintMaartenDutchpart'
    new_column_names[48] = 'CotedIvoire'


    df.rename(columns=dict(zip(old_column_names,new_column_names)), inplace=True)
    print(new_column_names)
    df = df.fillna(value=0)  # if on csv value is blank, this will replace it with a value of 0
    for row in df.itertuples():
        cursor.execute('''
            insert into covid.dbo.stg_source_total_cases(
            date,
            World,
    Afghanistan,
    Albania,
    Algeria,
    Andorra,
    Angola,
    Anguilla,
    AntiguaandBarbuda,
    Argentina,
    Armenia,
    Aruba,
    Australia,
    Austria,
    Azerbaijan,
    Bahamas,
    Bahrain,
    Bangladesh,
    Barbados,
    Belarus,
    Belgium,
    Belize,
    Benin,
    Bermuda,
    Bhutan,
    Bolivia,
    BonaireSintEustatiusandSaba,
    BosniaandHerzegovina,
    Botswana,
    Brazil,
    BritishVirginIslands,
    Brunei,
    Bulgaria,
    BurkinaFaso,
    Burundi,
    Cambodia,
    Cameroon,
    Canada,
    CapeVerde,
    CaymanIslands,
    CentralAfricanRepublic,
    Chad,
    Chile,
    China,
    Colombia,
    Comoros,
    Congo,
    CostaRica,
    CotedIvoire,
    Croatia,
    Cuba,
    Curacao,
    Cyprus,
    CzechRepublic,
    DemocraticRepublicofCongo,
    Denmark,
    Djibouti,
    Dominica,
    DominicanRepublic,
    Ecuador,
    Egypt,
    ElSalvador,
    EquatorialGuinea,
    Eritrea,
    Estonia,
    Ethiopia,
    FaeroeIslands,
    FalklandIslands,
    Fiji,
    Finland,
    France,
    FrenchPolynesia,
    Gabon,
    Gambia,
    Georgia,
    Germany,
    Ghana,
    Gibraltar,
    Greece,
    Greenland,
    Grenada,
    Guam,
    Guatemala,
    Guernsey,
    Guinea,
    GuineaBissau,
    Guyana,
    Haiti,
    Honduras,
    Hungary,
    Iceland,
    India,
    Indonesia,
    International,
    Iran,
    Iraq,
    Ireland,
    IsleofMan,
    Israel,
    Italy,
    Jamaica,
    Japan,
    Jersey,
    Jordan,
    Kazakhstan,
    Kenya,
    Kosovo,
    Kuwait,
    Kyrgyzstan,
    Laos,
    Latvia,
    Lebanon,
    Lesotho,
    Liberia,
    Libya,
    Liechtenstein,
    Lithuania,
    Luxembourg,
    Macedonia,
    Madagascar,
    Malawi,
    Malaysia,
    Maldives,
    Mali,
    Malta,
    Mauritania,
    Mauritius,
    Mexico,
    Moldova,
    Monaco,
    Mongolia,
    Montenegro,
    Montserrat,
    Morocco,
    Mozambique,
    Myanmar,
    Namibia,
    Nepal,
    Netherlands,
    NewCaledonia,
    NewZealand,
    Nicaragua,
    Niger,
    Nigeria,
    NorthernMarianaIslands,
    Norway,
    Oman,
    Pakistan,
    Palestine,
    Panama,
    PapuaNewGuinea,
    Paraguay,
    Peru,
    Philippines,
    Poland,
    Portugal,
    PuertoRico,
    Qatar,
    Romania,
    Russia,
    Rwanda,
    SaintKittsandNevis,
    SaintLucia,
    SaintVincentandtheGrenadines,
    SanMarino,
    SaoTomeandPrincipe,
    SaudiArabia,
    Senegal,
    Serbia,
    Seychelles,
    SierraLeone,
    Singapore,
    SintMaartenDutchpart,
    Slovakia,
    Slovenia,
    Somalia,
    SouthAfrica,
    SouthKorea,
    SouthSudan,
    Spain,
    SriLanka,
    Sudan,
    Suriname,
    Swaziland,
    Sweden,
    Switzerland,
    Syria,
    Taiwan,
    Tajikistan,
    Tanzania,
    Thailand,
    Timor,
    Togo,
    TrinidadandTobago,
    Tunisia,
    Turkey,
    TurksandCaicosIslands, 
    Uganda,
    Ukraine,
    UnitedArabEmirates,
    UnitedKingdom,
    UnitedStates,
    UnitedStatesVirginIslands,
    Uruguay,
    Uzbekistan,
    Vatican,
    Venezuela,
    Vietnam,
    WesternSahara,
    Yemen,
    Zambia,
    Zimbabwe
    
            
            
            )
            values(
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?        
            
            
            
            
            )
            ''',
                       row.date,
                       row.World,
                       row.Afghanistan,
                       row.Albania,
                       row.Algeria,
                       row.Andorra,
                       row.Angola,
                       row.Anguilla,
                       row.AntiguaandBarbuda,
                       row.Argentina,
                       row.Armenia,
                       row.Aruba,
                       row.Australia,
                       row.Austria,
                       row.Azerbaijan,
                       row.Bahamas,
                       row.Bahrain,
                       row.Bangladesh,
                       row.Barbados,
                       row.Belarus,
                       row.Belgium,
                       row.Belize,
                       row.Benin,
                       row.Bermuda,
                       row.Bhutan,
                       row.Bolivia,
                       row.BonaireSintEustatiusandSaba,
                       row.BosniaandHerzegovina,
                       row.Botswana,
                       row.Brazil,
                       row.BritishVirginIslands,
                       row.Brunei,
                       row.Bulgaria,
                       row.BurkinaFaso,
                       row.Burundi,
                       row.Cambodia,
                       row.Cameroon,
                       row.Canada,
                       row.CapeVerde,
                       row.CaymanIslands,
                       row.CentralAfricanRepublic,
                       row.Chad,
                       row.Chile,
                       row.China,
                       row.Colombia,
                       row.Comoros,
                       row.Congo,
                       row.CostaRica,
                       row.CotedIvoire,
                       row.Croatia,
                       row.Cuba,
                       row.Curacao,
                       row.Cyprus,
                       row.CzechRepublic,
                       row.DemocraticRepublicofCongo,
                       row.Denmark,
                       row.Djibouti,
                       row.Dominica,
                       row.DominicanRepublic,
                       row.Ecuador,
                       row.Egypt,
                       row.ElSalvador,
                       row.EquatorialGuinea,
                       row.Eritrea,
                       row.Estonia,
                       row.Ethiopia,
                       row.FaeroeIslands,
                       row.FalklandIslands,
                       row.Fiji,
                       row.Finland,
                       row.France,
                       row.FrenchPolynesia,
                       row.Gabon,
                       row.Gambia,
                       row.Georgia,
                       row.Germany,
                       row.Ghana,
                       row.Gibraltar,
                       row.Greece,
                       row.Greenland,
                       row.Grenada,
                       row.Guam,
                       row.Guatemala,
                       row.Guernsey,
                       row.Guinea,
                       row.GuineaBissau,
                       row.Guyana,
                       row.Haiti,
                       row.Honduras,
                       row.Hungary,
                       row.Iceland,
                       row.India,
                       row.Indonesia,
                       row.International,
                       row.Iran,
                       row.Iraq,
                       row.Ireland,
                       row.IsleofMan,
                       row.Israel,
                       row.Italy,
                       row.Jamaica,
                       row.Japan,
                       row.Jersey,
                       row.Jordan,
                       row.Kazakhstan,
                       row.Kenya,
                       row.Kosovo,
                       row.Kuwait,
                       row.Kyrgyzstan,
                       row.Laos,
                       row.Latvia,
                       row.Lebanon,
                       row.Lesotho,
                       row.Liberia,
                       row.Libya,
                       row.Liechtenstein,
                       row.Lithuania,
                       row.Luxembourg,
                       row.Macedonia,
                       row.Madagascar,
                       row.Malawi,
                       row.Malaysia,
                       row.Maldives,
                       row.Mali,
                       row.Malta,
                       row.Mauritania,
                       row.Mauritius,
                       row.Mexico,
                       row.Moldova,
                       row.Monaco,
                       row.Mongolia,
                       row.Montenegro,
                       row.Montserrat,
                       row.Morocco,
                       row.Mozambique,
                       row.Myanmar,
                       row.Namibia,
                       row.Nepal,
                       row.Netherlands,
                       row.NewCaledonia,
                       row.NewZealand,
                       row.Nicaragua,
                       row.Niger,
                       row.Nigeria,
                       row.NorthernMarianaIslands,
                       row.Norway,
                       row.Oman,
                       row.Pakistan,
                       row.Palestine,
                       row.Panama,
                       row.PapuaNewGuinea,
                       row.Paraguay,
                       row.Peru,
                       row.Philippines,
                       row.Poland,
                       row.Portugal,
                       row.PuertoRico,
                       row.Qatar,
                       row.Romania,
                       row.Russia,
                       row.Rwanda,
                       row.SaintKittsandNevis,
                       row.SaintLucia,
                       row.SaintVincentandtheGrenadines,
                       row.SanMarino,
                       row.SaoTomeandPrincipe,
                       row.SaudiArabia,
                       row.Senegal,
                       row.Serbia,
                       row.Seychelles,
                       row.SierraLeone,
                       row.Singapore,
                       row.SintMaartenDutchpart,
                       row.Slovakia,
                       row.Slovenia,
                       row.Somalia,
                       row.SouthAfrica,
                       row.SouthKorea,
                       row.SouthSudan,
                       row.Spain,
                       row.SriLanka,
                       row.Sudan,
                       row.Suriname,
                       row.Swaziland,
                       row.Sweden,
                       row.Switzerland,
                       row.Syria,
                       row.Taiwan,
                       row.Tajikistan,
                       row.Tanzania,
                       row.Thailand,
                       row.Timor,
                       row.Togo,
                       row.TrinidadandTobago,
                       row.Tunisia,
                       row.Turkey,
                       row.TurksandCaicosIslands,
                       row.Uganda,
                       row.Ukraine,
                       row.UnitedArabEmirates,
                       row.UnitedKingdom,
                       row.UnitedStates,
                       row.UnitedStatesVirginIslands,
                       row.Uruguay,
                       row.Uzbekistan,
                       row.Vatican,
                       row.Venezuela,
                       row.Vietnam,
                       row.WesternSahara,
                       row.Yemen,
                       row.Zambia,
                       row.Zimbabwe

                       )
        conn.commit()




