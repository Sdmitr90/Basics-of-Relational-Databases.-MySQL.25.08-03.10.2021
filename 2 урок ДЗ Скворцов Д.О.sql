Урок 1. Видеоурок. Управление БД. Язык запросов SQL

1) Установите СУБД MySQL. Создайте в домашней директории файл .my.cnf, задав в нем логин и пароль, который указывался при установке.

   файл my.cnf создал, поместил в папку windows, теперь MySQL открывается без запроса логина и пароля:
        [client]
        user=root
        password=root

    так же добавил путь в Path, могу вызывать MySQL из любой директории.    

2) Создайте базу данных example, разместите в ней таблицу users, состоящую из двух столбцов, числового id и строкового name.

    CREATE DATABASE example;

    USE example

    CREATE TABLE users (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255)
        );

3) Создайте дамп базы данных example из предыдущего задания, разверните содержимое дампа в новую базу данных sample.

    mysqldump example > example.sql

    mysql

    CREATE DATABASE sample;

    mysql sample < example.sql
