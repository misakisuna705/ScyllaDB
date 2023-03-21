#!/usr/bin/env bash

cqlsh -e "DROP KEYSPACE IF EXISTS ycsb"

rm -rf ~/apache-cassandra-4.1.0/data/data/ycsb

cqlsh -e "CREATE KEYSPACE IF NOT EXISTS ycsb WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1}"

cqlsh -e "CREATE TABLE IF NOT EXISTS ycsb.usertable (y_id varchar primary key, field0 varchar, field1 varchar, field2 varchar, field3 varchar, field4 varchar, field5 varchar, field6 varchar, field7 varchar, field8 varchar, field9 varchar) WITH compaction = {'class': 'SizeTieredCompactionStrategy', 'min_threshold': 4, 'max_threshold': 4, 'min_sstable_size': 1} AND compression = {'enabled': 'false'}"

inotifywait -rm -e create,modify,delete --format "%e %w%f" ~/apache-cassandra-4.1.0/data/data/ycsb/*/ |
    while read -r changed; do
        if [[ "$changed" == *"Data"* ]]; then
            stat="$(echo "$changed" | awk '{print $1}')"
            file="$(echo "$changed" | awk '{print $2}')"
            name=$(basename "$file")

            printf "%s %s " "$stat" "$name"

            if [[ "$changed" == *"CREATE"* ]]; then
                printf "0\n"
            elif [[ "$changed" == *"MODIFY"* ]]; then
                if test -f "$file"; then
                    du -h "$file" | cut -f -1
                else
                    printf "\n"
                fi
            elif [[ "$changed" == *"DELETE"* ]]; then
                printf "X\n"
            fi

            echo ""
        fi
    done
