import 'package:crypto_market/Crypto_Market/Model/coin_model.dart';
import 'package:crypto_market/Crypto_Market/Screens/coin_line_chart.dart';
import 'package:crypto_market/crypto_market.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        child: allCoin(),
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
      onWishlistError: Center(
        child: Text(
          'Wishlist not found!!',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 20),
        ),
      ),
      onCoinTap: (ctx, coin) {
        ///  ------  ///
      },
    );
  }

  Widget candleChart() {
    return CandleChart(
      coinData: coinsList.elementAt(0),
      inrRate: 77.0,
      intervalSelectedTextColor: Colors.red,
      intervalTextSize: 20,
      intervalUnselectedTextColor: Colors.black,
    );
  }

  Widget lineChart() {
    return LineChart(
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
  }

  Widget orderVolume() {
    return OrderVolume(
      coinData: coinsList.elementAt(0),
      inrRate: 77.0,
    );
  }

  Widget tradeHistory() {
    return CoinTradeHistory(
      coinData: coinsList.elementAt(0),
      itemCount: 15,
      inrRate: 77,
    );
  }

  Widget searchCoin() {
    return CoinSearch(
      coinsList: coinsList,
      currencyList: currencyList,
      tickerList: tickerList,
      inrRate: 77.0,
    );
  }
}

List<Coin> coinsList = [
  Coin(
    id: '1',
    image: 'https://s2.coinmarketcap.com/static/img/coins/64x64/1.png',
    name: 'Bitcoin',
    shortName: 'BTC',
    price: '123456',
    lastPrice: '123456',
    percentage: '-0.5',
    symbol: 'BTCUSDT',
    pairWith: 'USDT',
    highDay: '567',
    lowDay: '12',
    decimalCurrency: 4,
  ),
  Coin(
    id: '2',
    image: 'https://s2.coinmarketcap.com/static/img/coins/64x64/1.png',
    name: 'Bitcoin',
    shortName: 'BTC',
    price: '123456',
    lastPrice: '123456',
    percentage: '-0.5',
    symbol: 'BTCINR',
    pairWith: 'INR',
    highDay: '567',
    lowDay: '12',
    decimalCurrency: 4,
  ),
  Coin(
    id: '3',
    image: 'https://s2.coinmarketcap.com/static/img/coins/64x64/1839.png',
    name: 'Binance',
    shortName: 'BNB',
    price: '0.0005',
    lastPrice: '0.0005',
    percentage: '-0.5',
    symbol: 'BNBBUSD',
    pairWith: 'BUSD',
    highDay: '567',
    lowDay: '12',
    decimalCurrency: 4,
  ),
  Coin(
    id: '4',
    image: 'https://bin.bnbstatic.com/image/admin_mgs_image_upload/20201110/22ef2baf-b210-4882-afd9-1317bb7a3603.png',
    name: 'Dogecoin',
    shortName: 'DOGE',
    price: '123456',
    lastPrice: '123456',
    percentage: '-0.5',
    symbol: 'DOGEUSDT',
    pairWith: 'USDT',
    highDay: '567',
    lowDay: '12',
    decimalCurrency: 4,
  ),
  Coin(
    id: '5',
    image: 'https://bin.bnbstatic.com/image/admin_mgs_image_upload/20201110/4766a9cc-8545-4c2b-bfa4-cad2be91c135.png',
    name: 'XRP',
    shortName: 'XRP',
    price: '123456',
    lastPrice: '123456',
    percentage: '-0.5',
    symbol: 'XRPUSDT',
    pairWith: 'USDT',
    highDay: '567',
    lowDay: '12',
    decimalCurrency: 4,
  ),
];

List<Coin> wishlistCoinsList = [
  Coin(
    id: '1',
    image: 'https://s2.coinmarketcap.com/static/img/coins/64x64/1027.png',
    name: 'Ethereum',
    shortName: 'ETH',
    price: '123456',
    lastPrice: '123456',
    percentage: '-0.5',
    symbol: 'ETHUSDT',
    pairWith: 'USDT',
    highDay: '567',
    lowDay: '12',
    decimalCurrency: 4,
  )
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
