# Atomicals ElectrumX Docker

Aim to provide a simple and easy way to run [atomicals-electrumx](https://github.com/atomicals/atomicals-electrumx) server. Inspired by https://github.com/lukechilds/docker-electrumx.

## Usage

### 1. Update your Bitcoin Full Node RPC settings, _SKIP_ if you already set.

Add this to your bitcoin.conf, and restart your bitcoin full node.

```
txindex=1
rpcauth=electrumx:c7ed296134ebe0035d9ff786dfa102b5$9d40e8e36bcdba1e3ca0a79178c3864c3deaa9e6fd484ff683e7770690a97097
```

- `txindex=1` is required for ElectrumX to work. You need wait for full node to reindex.
- You can also download script from https://github.com/bitcoin/bitcoin/blob/master/share/rpcauth/rpcauth.py. And generate one by yourself.

### 2. Clone this repo and Run the server:

```bash
git clone https://github.com/lucky2077/atomicals-electrumx-docker.git
```

```bash
cd atomicals-electrumx-docker
```

For users who set rpcauth by themselves, you should create an `.env` file:

```ini
DAEMON_URL=<rpcuser>:<rpcpassword>@<rpcip>:<rpcport>
```

Then run the ElectrumX server:

```bash
docker-compose up -d
```

- use `docker-compose logs -f` to check the logs.
- use `docker-compose down` to stop the server.

**NOTE**

- You should stop here until the server is fully synced.
- The `data` directory will be more than **90G** after sync.

### 3. Update `.env` in your `atomicals-js` project as below:

```ini
# ELECTRUMX_WSS=wss://electrumx.atomicals.xyz:50012
ELECTRUMX_WSS=wss://127.0.0.1:50004
```

### 4. Edit `lib/api/electrum-api.ts` file in your `atomicals-js`

```diff
-        this.ws = new WebSocket(this.url);
+        this.ws = new WebSocket(this.url, { rejectUnauthorized: false });
```

### 5. Then you can use `atomicals-js` all cli as before.
