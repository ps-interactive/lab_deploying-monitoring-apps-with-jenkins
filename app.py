from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def index():
    return "Welcome to the Guest Book!"

@app.route('/add/<guest>')
def add_guest(guest):
    with open("log.txt", "a") as f:
        f.write(f"{guest}\n")
    return f"Added {guest} to the guestbook"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port='5001')
