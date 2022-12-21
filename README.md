# ScyllaDB

<!-- vim-markdown-toc GFM -->

* [參數](#參數)
    - [系統](#系統)
* [環境](#環境)
    - [Docker](#docker)
    - [Maven 3](#maven-3)
    - [Python 2.7](#python-27)
    - [Pip3](#pip3)
* [ScyllaDB](#scylladb)
    - [下載](#下載)
    - [構建](#構建)
    - [執行](#執行)
* [CQLSH](#cqlsh)
    - [安裝](#安裝)
    - [命令](#命令)
* [YCSB](#ycsb)
    - [下載](#下載-1)
    - [構建](#構建-1)
    - [安裝](#安裝-1)
    - [執行](#執行-1)
* [Cassandra](#cassandra)
    - [下載](#下載-2)
    - [配置](#配置)
    - [執行](#執行-2)
* [YCSB](#ycsb-1)
    - [執行](#執行-3)

<!-- vim-markdown-toc -->

---

## 參數

### 系統

-   Ubuntu 18.04（WSL）

## 環境

### Docker

```zsh
curl -fsSL https://get.docker.com -o get-docker.sh

sudo sh get-docker.sh
```

### Maven 3

```zsh
sudo apt install -y maven
```

### Python 2.7

```zsh
sudo apt install -y python
```

### Pip3

```zsh
sudo apt install -y python3-pip
```

## ScyllaDB

### 下載

```zsh
git clone --no-tags --depth 1 https://github.com/scylladb/scylla

cd ./scylla

git submodule update --init --force --recursive
```

### 構建

```zsh
sudo chmod 666 /var/run/docker.sock

sudo service docker start

./tools/toolchain/dbuild ./configure.py --mode dev
./tools/toolchain/dbuild ninja -j $(nproc --all)
```

### 執行

```zsh
sudo chmod 666 /var/run/docker.sock

sudo service docker start

./tools/toolchain/dbuild ./build/dev/scylla --developer-mode 1 --workdir tmp --smp 1 --overprovisioned --compaction-enforce-min-threshold 1
```

## CQLSH

### 安裝

```zsh
pip3 install cqlsh
```

### 命令

```zsh
cqlsh -e "[cql command]" [ip] [port]

cqlsh -f [cql script] [ip] [port]
```

## YCSB

### 下載

```zsh
git clone --no-tags --depth 1 https://github.com/brianfrankcooper/YCSB.git
```

### 構建

```zsh
cd YCSB

mvn -pl site.ycsb:scylla-binding -am clean package

cp scylla/target/ycsb-scylla-binding-0.18.0-SNAPSHOT.tar.gz ~
```

### 安裝

```zsh
tar xfvz ycsb-scylla-binding-0.18.0-SNAPSHOT.tar.gz

cd ycsb-scylla-binding-0.18.0-SNAPSHOT
```

### 執行

```zsh
cqlsh -e "DROP KEYSPACE IF EXISTS ycsb"

rm -rf ~/scylla/tmp/data/ycsb

###

# ls -alh ~/scylla/tmp/data

###

# cqlsh -e "Expand ON; SELECT * FROM system_schema.keyspaces"

cqlsh -e "CREATE KEYSPACE IF NOT EXISTS ycsb WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1}"

# cqlsh -e "Expand ON; SELECT * FROM system_schema.keyspaces"

###

# cqlsh -e "Expand ON; SELECT * FROM system_schema.tables WHERE keyspace_name = 'ycsb'"

cqlsh -e "CREATE TABLE IF NOT EXISTS ycsb.usertable (y_id varchar primary key, field0 varchar, field1 varchar, field2 varchar, field3 varchar, field4 varchar, field5 varchar, field6 varchar, field7 varchar, field8 varchar, field9 varchar) WITH compaction = {'class' : 'SizeTieredCompactionStrategy', 'min_threshold' : 4, 'max_threshold': 4}"

# cqlsh -e "Expand ON; SELECT * FROM system_schema.tables WHERE keyspace_name = 'ycsb'"

# cqlsh -e "Expand ON; SELECT * FROM system_schema.columns WHERE keyspace_name = 'ycsb' AND table_name = 'usertable'"

###

# cqlsh -e "Expand ON; SELECT * from ycsb.usertable"

~/ycsb-scylla-binding-0.18.0-SNAPSHOT/bin/ycsb load scylla -s -P ~/ycsb-scylla-binding-0.18.0-SNAPSHOT/workloads/workloada -threads $(nproc --all) -p scylla.hosts=localhost -p recordcount=10000000 -p requestdistribution=sequential

###

ls -alh ~/scylla/tmp/data/ycsb/*/*.db | grep Data
```

## Cassandra

### 下載

```zsh
wget http://archive.apache.org/dist/cassandra/4.1.0/apache-cassandra-4.1.0-bin.tar.gz

tar xzvf apache-cassandra-4.1.0-bin.tar.gz

cd apache-cassandra-4.1.0
```

### 配置

-   conf/cassandra.yaml

```yaml
memtable_flush_writers: 1
memtable_heap_space: 9MiB
# flush_compression: none
```

### 執行

```zsh
bin/cassandra -f
```

## YCSB

### 執行

```zsh
cqlsh -e "DROP KEYSPACE IF EXISTS ycsb"

rm -rf ~/apache-cassandra-4.1.0/data/data/ycsb

cqlsh -e "CREATE KEYSPACE IF NOT EXISTS ycsb WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1}"

cqlsh -e "CREATE TABLE IF NOT EXISTS ycsb.usertable (y_id varchar primary key, field0 varchar, field1 varchar, field2 varchar, field3 varchar, field4 varchar, field5 varchar, field6 varchar, field7 varchar, field8 varchar, field9 varchar) WITH compaction = {'class' : 'SizeTieredCompactionStrategy', 'min_threshold' : 4, 'max_threshold': 4} AND compression = {'enabled': 'false'}"

~/ycsb-scylla-binding-0.18.0-SNAPSHOT/bin/ycsb load scylla -s -P ~/ycsb-scylla-binding-0.18.0-SNAPSHOT/workloads/workloada -threads $(nproc --all) -p scylla.hosts=localhost -p recordcount=10000000 -p requestdistribution=sequential

ls -alh ~/apache-cassandra-4.1.0/data/data/ycsb/*/*.db | grep Data
```
