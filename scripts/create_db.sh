#!/usr/bin/env bash

PROJECT_ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}")/.." ; pwd -P )

echo Setup as root
mysql -u root -p <<QUERY
CREATE USER IF NOT EXISTS 'ece421'@'localhost'
    IDENTIFIED BY 'ece421';
CREATE DATABASE IF NOT EXISTS connect4;
GRANT ALL PRIVILEGES ON connect4.* TO 'ece421'@'localhost';
GRANT SUPER ON *.* TO 'ece421'@'localhost';
FLUSH PRIVILEGES;
QUERY

echo Setup tables as 'ece421' user
mysql -u ece421 -p connect4 < ${PROJECT_ROOT}/server/tables.sql
