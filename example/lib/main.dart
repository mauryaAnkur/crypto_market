import 'package:crypto_market/Crypto_Market/Model/coin_model.dart';
import 'package:crypto_market/crypto_market.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Market'),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 6),
        child: tradeHistory(),
      ),
    );
  }

  Widget allCoin() {
    return AllCoin(
      coinsList: coinsList,
      currencyList: currencyList,
      tickerList: tickerList,
      wishlistCoinsList: wishlistCoinsList,
      showWishlistAtFirst: false,
      currencyTabSelectedItemColor: Colors.red,
      currencyTabBackgroundColor: Colors.transparent,
      currencyTabHeight: 100,
      showHeading: true,
      inrRate: 77.0,
      onWishlistError: Center(child: Text('Wishlist not found!!', style: TextStyle(color: Colors.grey.shade600, fontSize: 20),),),
      onCoinTap: (ctx, coin) {
        ///  ------  ///
      },
    );
  }

  Widget coinGraph() {
    return CoinGraph(
      coinData: coinsList.elementAt(0),
      listedCoinGraphUrl: 'http://node.demo.com/orders/getohlc?symbol=TSTUSDT&interval=1m',
      inrRate: 77.0,
    );
  }

  Widget orderBook() {
    return OrderBook(
      coinData: coinsList.elementAt(0),
      // listedCoinOrderBookUrl: 'http://node.demo.com/orders/order-book?currency=TST&with_currency=USDT',
      listedCoinOrderBookUrl: 'https://server.justbit.co.in/orders/order-book?currency=RPT&with_currency=INR',
      inrRate: 77.0,
    );
  }

  Widget orderVolume() {
    return OrderVolume(
      coinData: coinsList.elementAt(0),
      // listedCoinOrderBookUrl: 'http://node.demo.com/orders/order-book?currency=TST&with_currency=USDT',
      listedCoinOrderBookUrl: 'https://server.justbit.co.in/orders/order-book?currency=RPT&with_currency=INR',
      inrRate: 77.0,
    );
  }

  Widget tradeHistory() {
    return CoinTradeHistory(
      coinData: coinsList.elementAt(0),
      listedCoinTradeHistoryAPIUrl: 'http://node.demo.com/orders/trade-book?currency=TST&with_currency=USDT',
      itemCount: 15,
      inrRate: 77,
    );
  }

  Widget coinSearch() {
    return CoinSearch(
      coinsList: coinsList,
      currencyList: currencyList,
      tickerList: tickerList,
      inrRate: 77.0,
    );
  }

}




List<Coin> coinsList = [
  Coin(coinID: '1', coinImage: 'https://', coinName: 'Bitcoin', coinShortName: 'BTC', coinPrice: '123456', coinLastPrice: '123456', coinPercentage: '-0.5', coinSymbol: 'BTCUSDT', coinPairWith: 'USDT', coinHighDay: '567', coinLowDay: '12', coinDecimalPair: 3, coinDecimalCurrency: 4, coinListed: false),
  // Coin(coinID: '1', coinImage: 'https://', coinName: 'Litecoin', coinShortName: 'LTC', coinPrice: '123456', coinLastPrice: '123456', coinPercentage: '-0.5', coinSymbol: 'LTCBNB', coinPairWith: 'BNB', coinHighDay: '567', coinLowDay: '12', coinDecimalPair: 3, coinDecimalCurrency: 4, coinListed: false),
  Coin(coinID: '2', coinImage: 'https://', coinName: 'Bitcoin', coinShortName: 'BTC', coinPrice: '123456', coinLastPrice: '123456', coinPercentage: '-0.5', coinSymbol: 'BTCINR', coinPairWith: 'INR', coinHighDay: '567', coinLowDay: '12', coinDecimalPair: 3, coinDecimalCurrency: 4, coinListed: false),
  Coin(coinID: '3', coinImage: 'https://', coinName: 'Binance USD', coinShortName: 'BUSD', coinPrice: '0.0005', coinLastPrice: '0.0005', coinPercentage: '-0.5', coinSymbol: 'BUSDBNB', coinPairWith: 'BNB', coinHighDay: '567', coinLowDay: '12', coinDecimalPair: 3, coinDecimalCurrency: 4, coinListed: false),
  Coin(coinID: '4', coinImage: 'https://', coinName: 'Dogecoin', coinShortName: 'DOGE', coinPrice: '123456', coinLastPrice: '123456', coinPercentage: '-0.5', coinSymbol: 'DOGEUSDT', coinPairWith: 'USDT', coinHighDay: '567', coinLowDay: '12', coinDecimalPair: 3, coinDecimalCurrency: 4, coinListed: false),
];

List<Coin> wishlistCoinsList = [
  Coin(coinID: '1', coinImage: 'https://', coinName: 'Ethereum', coinShortName: 'ETH', coinPrice: '123456', coinLastPrice: '123456', coinPercentage: '-0.5', coinSymbol: 'ETHUSDT', coinPairWith: 'USDT', coinHighDay: '567', coinLowDay: '12', coinDecimalPair: 3, coinDecimalCurrency: 4, coinListed: false)
];

List<String> currencyList = [
  'USDT',
  'INR',
  'BNB',
];



List<String> tickerList = [
  "btcusdt@ticker",
  "ethusdt@ticker",
  "winusdt@ticker",
  "dentusdt@ticker",
  "xrpusdt@ticker",
  "etcusdt@ticker",
  "dogeusdt@ticker",
  "bnbusdt@ticker",
  "cakeusdt@ticker",
  "maticusdt@ticker",
  "trxusdt@ticker",
  "usdcusdt@ticker",
  "sandusdt@ticker",
  "maticbtc@ticker",
  "polybtc@ticker",
  "bnbbtc@ticker",
  "xrpeth@ticker",
  "shibusdt@ticker",
];