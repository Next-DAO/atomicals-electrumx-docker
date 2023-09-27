# Atomicals ElectrumX Docker

Aim to provide a simple and easy way to run [atomicals-electrumx](https://github.com/atomicals/atomicals-electrumx) server. Inspired by https://github.com/lukechilds/docker-electrumx.

## Usage

### 1. Create an empty directory:

```bash
mkdir atomicals-electrumx && cd atomicals-electrumx
```

### 2. Update your Bitcoin Full Node RPC settings, _SKIP_ if you already set.

```
# bitcoin.conf
rpcauth=username:hased_password
```

### 3. Run the server:

```bash
docker run --name atomicals-electrumx -it -d \
-v `pwd`/data:/data \
-e DAEMON_URL=username:password@host:port \
-p 50004:50004 \
lucky2077/atomicals-electrumx
```

- `pwd`/data will be used to store the server data and configuration files.
- `DAEMON_URL` is the RPC URL of your Bitcoin Full Node.
  - `username`: from step 2.
  - `password`: from step 2 but not hashed.
  - `host`: your Bitcoin Full Node host.
  - `port`: your Bitcoin Full Node RPC port. normally `8332` for mainnet and `18332` for testnet.

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
