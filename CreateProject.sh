#!/bin/bash

mkdir $1
cd $1
mkdir backend
mkdir frontend

cat >docker-compose.yml <<NAME
version: '3.7'

services:
  db:
    image: postgres
  backend:
    build: ./backend
    command: python manage.py runserver 0.0.0.0:8000
    volumes:
      - .:/app/backend
    ports:
      - "8000:8000"
    depends_on:
      - db
  frontend:
    build: ./frontend
    volumes:
      - .:/frontend
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
    depends_on:
      - backend
    command: npm run serve
NAME

cat >./backend/Dockerfile <<NAME
FROM python:3
ENV PYTHONUNBUFFERED 1
WORKDIR /app/backend
COPY requirements.txt /app/backend
RUN pip install -r requirements.txt
NAME

cat >./frontend/Dockerfile <<NAME
FROM node:13
WORKDIR /app/frontend
RUN npm install -g @vue/cli
NAME

cat >./backend/requirements.txt <<NAME
Django>=3.0.2
psycopg2>=2.8.4
NAME
