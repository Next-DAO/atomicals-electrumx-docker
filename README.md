# Atomicals ElectrumX Docker

Aim to provide a simple and easy way to run [atomicals-electrumx](https://github.com/atomicals/atomicals-electrumx) server.

Dockerfile is based on [Dockerfile from Official Repository](https://github.com/atomicals/atomicals-electrumx/blob/master/contrib/Dockerfile)

## Requirements

### 1. Bitcoin Full Node with `txindex=1` and enable rpc. A example of `bitcoin.conf`:

```ini
server=1
txindex=1

# genearate with [rpcauth.py](https://github.com/bitcoin/bitcoin/blob/master/share/rpcauth/rpcauth.py)
# equals to `rpcuser=nextdao` and `rpcpassword=nextdao`
rpcauth=nextdao:cca838b4b19bdc6093f4e0312550361c$213834a29e8488804946c196781059a7ee0ac2b48dbf896b4c6852060d9d83dd

rpcallowip=127.0.0.1
rpcallowip=172.0.0.0/8
rpcallowip=192.168.0.0/16

rpcbind=0.0.0.0
```
### 2. Install Docker with docker-compose.

### 3. At least **110G** left in your storage.

## Usage

### 1. Download [docker-compose.yml](https://github.com/Next-DAO/atomicals-electrumx-docker/raw/main/docker-compose.yml) to a folder.

Create an `.env` file with content below:

```ini
DAEMON_URL=nextdao:nextdao@127.0.0.1:8332
```

- if BTC full node is running on another host, change `127.0.0.1` to the `ip` of the host.
- also you can change `nextdao:nextdao` to your `rpcuser:rpcpassword` in `bitcoin.conf

### 2. Run the RPC server:

```bash
docker-compose pull && docker-compose up -d
```

- the electrumx indexes stored in `./electrumx-data` directory.
- use `docker-compose logs -f` to check the logs.
- use `docker-compose down` to stop the server.

### 3. Used in [atomicals-js](https://github.com/atomicals/atomicals-js)

Edit .env with `ELECTRUMX_PROXY_BASE_URL=http://localhost:8080/proxy`, then use all commands as usual.

If you run atomicals cli in anthoer host, change `localhost` to the `ip` of the `proxy` server.

## FAQ

### 1. How to check if the server is ready?

```bash
docker-compose ps
```

If you see `electrumx` is `healthy`, then the server is ready.

### 2. Why `electrumx` can't connect to `bitcoind`?

Double check your `bitcoin.conf` and `docker-compose.yml`.

1. If your `ip` included in `rpcallowip` of `bitcoin.conf`?
2. If `bitcoind` listen on `8332` port?
3. If `bitcoind` rpc username and password is correct?

### 3. Why the sync is so slow?

There are many reasons that may cause the sync slow.

1. The `bitcoind` is not fully synced.
2. You are using a HDD instead of SSD.
3. Your CPU single core performance is not good enough.
4. You are runing docker on windows or macos.