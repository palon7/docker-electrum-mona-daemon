# docker-electrum-mona-daemon
![Docker Pulls](https://img.shields.io/docker/pulls/palon7/electrum-mona-daemon)
[![License: MIT](https://img.shields.io/badge/License-MIT-black.svg)](https://opensource.org/licenses/MIT)


**Electrum-mona client running as a daemon in docker container with JSON-RPC enabled.**

[Electrum-mona client](https://electrum-mona.org/) is light monacoin wallet software operates through supernodes (ElectrumX instances actually).

Don't confuse with [ElectrumX](https://github.com/kyuupichan/electrumx) that use monacoind and full blockchain data.

Star this project on Docker Hub :star2: https://hub.docker.com/r/palon7/electrum-mona-daemon

### Ports

* `7000` - JSON-RPC port.

### Volumes

* `/data` - user data folder (on host it usually has a path ``/home/user/.electrum-mona``).


## Getting started

#### docker

Running with Docker:

```bash
docker run --rm --name electrum-mona \
    --env TESTNET=false \
    --publish 127.0.0.1:7000:7000 \
    --volume /srv/electrum-mona:/data \
    palon7/electrum-mona-daemon
```
```bash
docker exec -it electrum-mona electrum-mona create
docker exec -it electrum-mona electrum-mona load_wallet
docker exec -it electrum-mona electrum-mona list_wallets
[
    {
        "path": "/home/electrum/.electrum-mona/wallets/default_wallet",
        "synchronized": true
    }
]
```


#### docker-compose

[docker-compose.yml](https://github.com/osminogin/docker-electrum-daemon/blob/master/docker-compose.yml) to see minimal working setup. When running in production, you can use this as a guide.

```bash
docker-compose up
docker-compose exec electrum-mona electrum-mona getinfo
docker-compose exec electrum-mona electrum-mona create
docker-compose exec electrum-mona electrum-mona load_wallet
curl --data-binary '{"id":"1","method":"listaddresses"}' http://electrum:changeme@localhost:7000
```

:exclamation:**Warning**:exclamation:

Always link electrum daemon to containers or bind to localhost directly and not expose 7000 port for security reasons.

## API

* [Electrum-mona protocol specs](https://electrum-mona.readthedocs.io/ja/japanese-monacoin/protocol.html)
* [API related sources](https://github.com/wakiyamap/electrum-mona/blob/master/electrum_mona/commands.py)

## License

See [LICENSE](https://github.com/palon7/docker-electrum-mona-daemon/blob/master/LICENSE)

