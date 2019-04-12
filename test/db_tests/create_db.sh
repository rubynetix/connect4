#!/usr/bin/env bash

PROJECT_ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}")/../.." ; pwd -P )

mysql -u ece421 -p'ece421' test < ${PROJECT_ROOT}/server/queries/tables.sql
