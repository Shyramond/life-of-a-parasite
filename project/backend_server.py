import uvicorn
import psycopg2
from fastapi import FastAPI
from pydantic import BaseModel
import os
from dotenv import load_dotenv
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()
load_dotenv()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:8080"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class GameInfo(BaseModel):
    username: str
    password: str
    deaths: int
    wrong_answers: int


class UserInfo(BaseModel):
    username: str
    password: str


class Username(BaseModel):
    username: str


def get_connection():
    connection = psycopg2.connect(
        dbname=os.getenv("dbname"),
        user=os.getenv("user"),
        password=os.getenv("password"),
        host=os.getenv("host"),
        port=os.getenv("port")
    )
    return connection


@app.post("/api/add_game")
def add_game(game_info: GameInfo):
    connection = get_connection()
    cursor = connection.cursor()
    cursor.execute(
        "SELECT password FROM users WHERE username = %s", (game_info.username,)
    )
    result = cursor.fetchone()
    if not result or result[0] != game_info.password:
        return 1
    cursor.execute(
        "INSERT INTO games (username, deaths, wrong_answers) VALUES (%s, %s, %s)",
        (game_info.username, game_info.deaths, game_info.wrong_answers)
    )
    connection.commit()


@app.post("/api/add_user")
def add_user(user_info: UserInfo):
    connection = get_connection()
    cursor = connection.cursor()
    cursor.execute(
        """SELECT EXISTS (
            SELECT 1 
            FROM users 
            WHERE username = %s
        );""", (user_info.username,)
    )
    result = cursor.fetchone()
    if result[0]:
        return 1
    cursor.execute(
        "INSERT INTO users (username, password) VALUES (%s, %s)", (user_info.username, user_info.password)
    )
    connection.commit()
    return 0


@app.post("/api/login")
def login(user_info: UserInfo):
    connection = get_connection()
    cursor = connection.cursor()
    cursor.execute(
        """SELECT username, password
            FROM users 
            WHERE username = %s;""", (user_info.username,)
    )
    result = cursor.fetchone()
    if not result or user_info.password != result[1]:
        return 3
    return 2


@app.post("/api/get_user")
def get_user(username: Username):
    connection = get_connection()
    cursor = connection.cursor()
    cursor.execute(
        """SELECT EXISTS (
            SELECT 1 
            FROM users 
            WHERE username = %s
        );""", (username.username,)
    )
    result = cursor.fetchone()
    if not result[0]:
        return 1
    cursor.execute(
        "SELECT deaths, wrong_answers "
        "FROM games "
        "WHERE username = %s;", (username.username,)
    )
    result = cursor.fetchall()
    return result


if __name__ == "__main__":
    connection = get_connection()
    cursor = connection.cursor()
    cursor.execute(
        "CREATE TABLE IF NOT EXISTS users ("
        "username VARCHAR(20) PRIMARY KEY,"
        "password VARCHAR(20))"
    )
    cursor.execute(
        "CREATE TABLE IF NOT EXISTS games ("
        "id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,"
        "username VARCHAR(20) REFERENCES users(username),"
        "deaths INTEGER,"
        "wrong_answers INTEGER)"
    )
    connection.commit()
    uvicorn.run(app, host="127.0.0.1", port=8000)
