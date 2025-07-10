import pandas as pd
from sqlalchemy import create_engine
import os

# Dynamically resolve path
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
csv_path = os.path.join(BASE_DIR, "..", "data", "nashville_housing.csv")

# Load CSV
df = pd.read_csv(csv_path)

# Clean column names
df.columns = [c.lower().replace(" ", "_") for c in df.columns]

# Create DB engine - use 'db' as host inside Docker network
#engine = create_engine("postgresql://admin:admin123@postgres_container:5432/mydb")
engine = create_engine("postgresql://admin:admin123@postgres_container:5432/mydb")

# Load into DB
df.to_sql("nashville_housing", engine, if_exists="replace", index=False)

print("✅ Data loaded into Postgres!")
