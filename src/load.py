import os 
import sys 
import pandas as pd
from sqlalchemy import create_engine 
from dotenv import load_dotenv 

# load env variables from .env into the system 
load_dotenv() 

def get_db_engine():
    user = os.getenv("POSTGRES_USER")
    password = os.getenv("POSTGRES_PASSWORD")
    db = os.getenv("POSTGRES_DB")
    return create_engine(f"postgresql://{user}:{password}@localhost:5433/{db}")

def ingest_multi_header_xlsx(file_path, data_year):
    print(f"1. Load multi header xlsl file: {file_path}")
    # skip metadata on the first 7 rows, last 1 row 
    df = pd.read_excel(file_path, skiprows=[0, 1, 2, 3, 4, 5, 6], skipfooter=1, header=None) 

    print("2. Build unique column names")
    reconstructed_headers= [
        "mode", # Mode (LU/LO/DLR/TfL)
        "mnlc",
        "masc",
        "station_name",
        "coverage",
        "source",
        
        "entry_mon",
        "entry_midweek_tue_thu",
        "entry_fri",
        "entry_sat",
        "entry_sun",

        "exit_mon",
        "exit_midweek_tue_thu",
        "exit_fri",
        "exit_sat",
        "exit_sun",

        "weekly", 
        "12-week",
        "annualised"
    ]
    df.columns = reconstructed_headers 
    df['data_year'] = int(data_year)

    print("3. Bulk load into docker PostgreSQL")
    engine = get_db_engine() 

    try: 
        df.to_sql(
            name='tfl_station_annual_traffic_raw',
            con=engine,
            if_exists='append', # NOT replace, keep adding new data 
            index=False 
        )
        print(f"Total {len(df)} data loaded into tfl_station_annual_traffic_raw table")
        print(f"Created columns list: {list(df.columns)}")

    except Exception as e:
        print(f"Fail: {e}")

if __name__ == "__main__":
    # dynamic file name 
    target_year = "2025"
    
    if len(sys.argv) > 1:
        target_year = sys.argv[1]

    TARGET_XLSX = f"TFL_AC{target_year}_AnnualisedEntryExit_public.xlsx"

    if os.path.exists(TARGET_XLSX):
        ingest_multi_header_xlsx(TARGET_XLSX, target_year)
    else:
        print(f"Cannot find the file: {TARGET_XLSX}")