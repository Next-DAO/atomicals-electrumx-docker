# Atomicals ElectrumX Docker

Aims to provide a simple and easy way to run [atomicals-electrumx](https://github.com/atomicals/atomicals-electrumx) server.

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

Edit `docker-compose.yml`:

- Change `127.0.0.1` to `lan ip` of the bitcoin core host, eg: 192.168.50.2.
- Also change `nextdao:nextdao` to your `rpcuser:rpcpassword` in `bitcoin.conf

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

### 2. ERROR:Daemon:connection problem - check your daemon is running. Retrying occasionally...

1. Check if bitcoind is running.
2. Check if `rpcbind` include the `ip` used in `DAEMON_URL`

### 3. ERROR:Daemon:daemon service refused: Forbidden. Retrying occasionally...

1. Run `docker-compose ps` to check your container name. eg: `electrumx-electrumx-1`
2. Run `docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' electrumx-electrumx-1` to get container ip
3. Check if the ip in rpcallow range

### 4. ERROR:Daemon:daemon service refused: Unauthorize. Retrying occasionally...

Check if rpc username and password correct?

### 5. Why the sync is so slow?

There are many reasons that may cause the sync slow.

1. The `bitcoind` is not fully synced.
2. You are using a HDD instead of SSD.
3. Your CPU single core performance is not good enough.
4. You are runing docker on windows or macos.
