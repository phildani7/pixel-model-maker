pragma Singleton

import QtQuick 2.15
import PixelModelMaker 1.0

QtObject {
    property string url: "https://api.devnet.solana.com/"
    property string network: "devnet"

    function noop() {}

    function updateNetwork(network) {
        let networkMap = {
            "mainnet-beta": "https://api.mainnet-beta.solana.com/",
            "devnet": "https://api.devnet.solana.com/",
            "testnet": "https://api.testnet.solana.com/"
        }
        SolanaApi.network = network
        SolanaApi.url = networkMap[network]
    }

    function rpcRequest(method, params, success, error, commitment) {
        commitment = commitment || "confirmed"
        var client = new XMLHttpRequest()
        client.onload = function () {
            success(client)
        }
        client.onerror = function () {
            error(client)
        }

        client.open("POST", url)
        client.setRequestHeader("Content-Type", "application/json")
        client.send(JSON.stringify({
                                       "jsonrpc": "2.0",
                                       "id": 1,
                                       "method": method,
                                       "params": [...params, {
                                               "commitment": commitment
                                           }]
                                   }))
    }

    function getBalance(pubKey, success, error, commitment) {
        success = success || noop
        error = error || noop
        rpcRequest("getBalance", [pubKey],
                   req => success(JSON.parse(req.response).result.value, req),
                   error, commitment)
    }

    function requestAirdrop(pubKey, lamparts, success, error, commitment) {
        success = success || noop
        error = error || noop
        rpcRequest("requestAirdrop", [pubKey, lamparts], req => success(req),
                   error, commitment)
    }
}
