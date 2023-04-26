### Crypto Market is a highly customizable Flutter library that supports Coin Graph, Order Book, Order Volume, and Trade History.


## Features


<img src="https://raw.githubusercontent.com/mauryaAnkur/crypto_market/master/assets/all_coin.jpg?token=GHSAT0AAAAAABXRIUL4S3NYW57BKJKZLB2GYX7LX3A" alt="All Coins" width="300" height="540">                  <img src="https://raw.githubusercontent.com/mauryaAnkur/crypto_market/master/assets/search_coin.jpg?token=GHSAT0AAAAAABXRIUL4HFF6SJDM4M72K5OQYX7L3JQ" alt="Coin Search" width="300" height="540">
<img src="https://raw.githubusercontent.com/mauryaAnkur/crypto_market/master/assets/candle_chart.jpg?token=GHSAT0AAAAAABXRIUL4LT3FZLGWVRYFUI24YX7MKRA" alt="Candle Chart" width="300" height="540">                 <img src="https://raw.githubusercontent.com/mauryaAnkur/crypto_market/master/assets/line_chart.png?token=GHSAT0AAAAAABXRIUL4LT3FZLGWVRYFUI24YX7MKRA" alt="Line Chart" width="300" height="540">
<img src="https://raw.githubusercontent.com/mauryaAnkur/crypto_market/master/assets/order_volume.jpg?token=GHSAT0AAAAA" alt="Order Volume" width="300" height="540">                  <img src="https://raw.githubusercontent.com/mauryaAnkur/crypto_market/master/assets/trade_history.jpg?token=GHSAT0AAAAAABXRIUL5FHHMFMFU4QR62ARUYX7ML2A" alt="Trade History" width="300" height="540">

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

## Candle Chart
````
CoinGraph(
      coinData: coinsList.elementAt(0),
      listedCoinGraphUrl: 'http://node.demo.com/orders/getohlc?symbol=TSTUSDT&interval=1m',
      inrRate: 77.0,
    );
````

## Line Chart
````
CoinLineChart(
      coinData: coinsList.elementAt(4),
      inrRate: 77.0,
      intervalSelectedTextColor: Colors.red,
      intervalTextSize: 20,
      intervalUnselectedTextColor: Colors.black,
      chartBorderColor: Colors.green,
      showToolTip: false,
      showInterval: false,
      chartColor: LinearGradient(
       colors: [
         Colors.green.shade500.withOpacity(1),
         Colors.green.shade500.withOpacity(0.9),
         Colors.green.shade500.withOpacity(0.8),
         Colors.green.shade500.withOpacity(0.7),
         Colors.green.shade500.withOpacity(0.6),
         Colors.green.shade500.withOpacity(0.5),
         Colors.green.shade500.withOpacity(0.4),
         Colors.green.shade500.withOpacity(0.3),
         Colors.green.shade500.withOpacity(0.2),
         Colors.green.shade500.withOpacity(0.1),
         Colors.green.shade500.withOpacity(0.0),
       ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      toolTipBgColor: Colors.green.shade900,
      toolTipTextColor: Colors.white,
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
