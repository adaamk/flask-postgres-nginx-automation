from flask import Flask
import psycopg2

app = Flask(__name__)

@app.route("/")
def index():
    conn = psycopg2.connect(
        host="localhost",
        database="flaskdb",
        user="flaskuser",
        password="Strong1709"
    )
    cur = conn.cursor()
    cur.execute("SELECT version();")
    db_version = cur.fetchone()
    cur.close()
    conn.close()
    return f"Connected to PostgreSQL: {db_version}"

if __name__ == "__main__":
    app.run()

