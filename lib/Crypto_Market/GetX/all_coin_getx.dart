import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../Model/coin_model.dart';


/// coin controller
class CoinController extends GetxController {
  static CoinController get to => Get.put(CoinController());

  List<Coin> allCoinsList = <Coin>[].obs;
  List<Coin> wishlistCoinsList = <Coin>[].obs;
  int selectedTabIndex = 1;

  /// get all coins
  getCoins(List<Coin> coinsList, List<Coin>? wishlist,
      List<String> tickerList) async {
    allCoinsList = coinsList;
    if (wishlist != null) {
      wishlistCoinsList = wishlist;
    }
    connectToServer(tickerList);
    update();
  }

  var selectedCurrency = ''.obs;
  List<Coin> selectedCurrencyCoins = <Coin>[].obs;

  /// get selected currency coins list
  getSelectCurrencyList(String currencyName) async {
    if (selectedCurrency.isEmpty) {
      selectedCurrency.value = currencyName;

      for (int i = 0; i < allCoinsList.length; i++) {
        String currencyName = allCoinsList.elementAt(i).pairWith;
        if (currencyName.toLowerCase() == selectedCurrency.toLowerCase()) {
          selectedCurrencyCoins.add(Coin(
            id: allCoinsList.elementAt(i).id,
            image: allCoinsList.elementAt(i).image,
            name: allCoinsList.elementAt(i).name,
            shortName: allCoinsList.elementAt(i).shortName,
            price: allCoinsList.elementAt(i).price,
            lastPrice: allCoinsList.elementAt(i).lastPrice,
            percentage: allCoinsList.elementAt(i).percentage,
            symbol: allCoinsList.elementAt(i).symbol,
            pairWith: allCoinsList.elementAt(i).pairWith,
            highDay: allCoinsList.elementAt(i).highDay,
            lowDay: allCoinsList.elementAt(i).lowDay,
            decimalCurrency: allCoinsList.elementAt(i).decimalCurrency,
          ));
        }
      }
    } else {
      selectedCurrency.value = currencyName;
      selectedCurrencyCoins.clear();
      for (int i = 0; i < allCoinsList.length; i++) {
        String currencyName = allCoinsList.elementAt(i).pairWith;
        if (currencyName.toLowerCase() == selectedCurrency.toLowerCase()) {
          selectedCurrencyCoins.add(Coin(
            id: allCoinsList.elementAt(i).id,
            image: allCoinsList.elementAt(i).image,
            name: allCoinsList.elementAt(i).name,
            shortName: allCoinsList.elementAt(i).shortName,
            price: allCoinsList.elementAt(i).price,
            lastPrice: allCoinsList.elementAt(i).price,
            percentage: allCoinsList.elementAt(i).percentage,
            symbol: allCoinsList.elementAt(i).symbol,
            pairWith: allCoinsList.elementAt(i).pairWith,
            highDay: allCoinsList.elementAt(i).highDay,
            lowDay: allCoinsList.elementAt(i).lowDay,
            decimalCurrency: allCoinsList.elementAt(i).decimalCurrency,
          ));
        }
      }
    }
    update();
  }

  /// update coin
  void updateCoin(
      String coinSymbol, String coinPrice, String coinPercentage) async {
    var inrPairCoins = coinSymbol.substring(0, coinSymbol.length - 4);

    var index = allCoinsList.where((element) =>
        element.symbol.toUpperCase() == coinSymbol.toUpperCase() ||
        element.symbol.toUpperCase() == '${inrPairCoins.toUpperCase()}INR');
    var selectedCurrencyIndex = selectedCurrencyCoins.where((element) =>
        element.symbol.toUpperCase() == coinSymbol.toUpperCase() ||
        element.symbol.toUpperCase() == '${inrPairCoins.toUpperCase()}INR');
    var wishlistIndex = wishlistCoinsList.where((element) =>
        element.symbol.toUpperCase() == coinSymbol.toUpperCase());

    for (var i in index) {
      i.price = coinPrice;
      i.percentage = coinPercentage;
    }

    for (var i in selectedCurrencyIndex) {
      i.price = coinPrice;
      i.percentage = coinPercentage;
    }

    for (var i in wishlistIndex) {
      i.price = coinPrice;
      i.percentage = coinPercentage;
    }

    update();
  }

  /// connect to binance websocket
  connectToServer(tickerList) {
    WebSocketChannel channelHome = IOWebSocketChannel.connect(
      Uri.parse('wss://stream.binance.com:9443/ws/stream?'),
    );

    var subRequestHome = {
      'method': "SUBSCRIBE",
      'params': tickerList,
      'id': 1,
    };

    var jsonString = json.encode(subRequestHome);
    channelHome.sink.add(jsonString);
    var result = channelHome.stream.transform(
      StreamTransformer<dynamic, dynamic>.fromHandlers(
        handleData: (number, sink) {
          sink.add(number);
        },
      ),
    );
    result.listen((event) {
      var snapshot = jsonDecode(event);

      updateCoin(snapshot['s'].toString(), snapshot['c'].toString(),
          snapshot['P'].toString());
    });
  }
}
