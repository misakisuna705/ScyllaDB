# ScyllaDB

<!-- vim-markdown-toc GFM -->

* [參數](#參數)
    - [系統](#系統)
* [環境](#環境)
    - [Docker](#docker)
    - [Pip3](#pip3)
* [ScyllaDB](#scylladb)
    - [下載](#下載)
    - [建構](#建構)
    - [執行](#執行)
* [CQLSH](#cqlsh)
    - [安裝](#安裝)
    - [執行](#執行-1)

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

sudo chmod 666 /var/run/docker.sock
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

### 建構

```zsh
sudo service docker start

./tools/toolchain/dbuild ./configure.py --mode dev
./tools/toolchain/dbuild ninja -j $(nproc --all)
```

### 執行

```zsh
./tools/toolchain/dbuild ./build/dev/scylla --developer-mode 1 --workdir tmp --smp 1 --overprovisioned
```

## CQLSH

### 安裝

```zsh
pip3 install cqlsh
```

### 執行

```zsh
cqlsh localhost 9042
```
