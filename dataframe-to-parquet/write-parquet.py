"""
A sample code to read and write parquet files.
Source: https://arrow.apache.org/docs/python/parquet.html
"""
import pyarrow as pa
import pyarrow.parquet as pq
import pandas as pd


# Writing a parquet file
df = pd.read_csv('data/yellow_sample.csv')
data = pa.Table.from_pandas(df)
pq.write_table(data, 'data/yellow_sample.parquet')

# Reading a parquet file
data_pq = pq.read_table('data/yellow_sample.parquet')
print(data_pq.to_pandas().head())
