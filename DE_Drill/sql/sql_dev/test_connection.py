from sqlalchemy import text
from connection_sql import get_connection

conn = get_connection()
result = conn.execute(text("SELECT @@VERSION"))
print(result.scalar())
conn.close()