from flask import Flask, render_template
import psycopg2

app = Flask(__name__)

@app.route("/")
def index():
    conn = psycopg2.connect(
        dbname="flaskdb",
        user="flaskuser",
        password="Strong1709",
        host="localhost"
    )
    cur = conn.cursor()
    cur.execute("SELECT version();")
    db_version = cur.fetchone()[0]
    cur.close()
    conn.close()
    return render_template("index.html", version=db_version)

