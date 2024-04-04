import psycopg2
import pandas as pd
from sqlalchemy import create_engine
#progress bar library like tqdm to show the progress of files being loaded
from tqdm import tqdm

# Define connection string and database engine
conn_string = 'postgresql://postgres:password@localhost/postgres'
db = create_engine(conn_string)

# Connect to database
conn = db.connect()

files = ['artist.csv', 'canvas_size.csv', 'image_link.csv', 'museum_hours.csv',
          'museum.csv', 'product_size.csv', 'subject.csv', 'work.csv']

for file in tqdm(files):
    try:
    # Read CSV data
        data_path = f'/Users/DELL/Documents/SQL_Challenge/Famous Paintings/Data/{file}'
        df = pd.read_csv(data_path)

     # Extract table name from filename (assuming filename matches table name)
        table_name = file.split('.')[0] # Get filename without extension

    # Load data to database, append if table exists
        #df.to_sql(table_name, con=conn, if_exists='append', index=False)
        df.to_sql(table_name, con=conn, if_exists='append', index=False)
    except FileNotFoundError:
        print(f"Error: File {file} not found!")
  
conn.close()  # Close connection after all files are processed




