### Crypto Market is a highly customizable Flutter library that supports Coin Graph, Order Book, Order Volume, and Trade History.


## Features


![All Coins](assets/allCoin.jpg =250x200)
![Coin Graph](https://raw.githubusercontent.com/mauryaAnkur/crypto_market/master/assets/coinGraph.jpg?token=GHSAT0AAAAAABXRIUL4LT3FZLGWVRYFUI24YX7MKRA)
![Coin Order Volume](https://raw.githubusercontent.com/mauryaAnkur/crypto_market/master/assets/orderBook.jpg?token=GHSAT0AAAAA)
![Coin Order Book](https://raw.githubusercontent.com/mauryaAnkur/crypto_market/master/assets/orderVolume.jpg?token=GHSAT0AAAAAABXRIUL5AUNZBRWKTPH3OCREYX7MLQQ)
![Coin Trade History](https://raw.githubusercontent.com/mauryaAnkur/crypto_market/master/assets/tradeHistory.jpg?token=GHSAT0AAAAAABXRIUL5FHHMFMFU4QR62ARUYX7ML2A)
![Coin Search](https://raw.githubusercontent.com/mauryaAnkur/crypto_market/master/assets/searchCoin.jpg?token=GHSAT0AAAAAABXRIUL4HFF6SJDM4M72K5OQYX7L3JQ)

## Usage

## All Coins
````
AllCoin(
      coinsList: coinsList,
      currencyList: currencyList,
      tickerList: tickerList,
      showWishlistAtFirst: false,
      currencyTabSelectedItemColor: Colors.red,
      currencyTabBackgroundColor: Colors.transparent,
      currencyTabHeight: 100,
      showHeading: true,
      inrRate: 77.0,
      onCoinTap: (ctx, coin) {
        ///  ------  ///
      },
    );
````

## Coin Graph
````
CoinGraph(
      coinData: coinsList.elementAt(0),
      listedCoinGraphUrl: 'http://node.demo.com/orders/getohlc?symbol=TSTUSDT&interval=1m',
      inrRate: 77.0,
    );
````

## Coin Order Book
````
CoinOrderBook(
      coinData: coinsList.elementAt(0),
      listedCoinOrderBookUrl: 'http://node.demo.com/orders/order-book?currency=TST&with_currency=USDT',
      inrRate: 77.0,
    );
````

## Coin Order Volume
````
CoinOrderVolume(
      coinData: coinsList.elementAt(0),
      listedCoinOrderBookUrl: 'http://node.demo.com/orders/order-book?currency=TST&with_currency=USDT',
      inrRate: 77.0,
    );
````

## Coin Trade History
````
CoinTradeHistory(
      coinData: coinsList.elementAt(0),
      listedCoinTradeHistoryAPIUrl: 'http://node.demo.com/orders/trade-book?currency=TST&with_currency=USDT',
      itemCount: 15,
      inrRate: 77,
    );
````

## Search Coin
````
CoinSearch(
      coinsList: coinsList,
      currencyList: currencyList,
      tickerList: tickerList,
      inrRate: 77.0,
    );
````
