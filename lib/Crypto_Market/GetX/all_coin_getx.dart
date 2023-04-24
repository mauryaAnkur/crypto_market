import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../Model/coin_model.dart';

class CoinController extends GetxController {
  static CoinController get to => Get.put(CoinController());

  List<Coin> allCoinsList = <Coin>[].obs;
  List<Coin> wishlistCoinsList = <Coin>[].obs;
  int selectedTabIndex = 1;

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
  List selectedCurrencyCoins = [].obs;

  getSelectCurrencyList(String currencyName) async {
    if (selectedCurrency.isEmpty) {
      selectedCurrency.value = currencyName;

      for (int i = 0; i < allCoinsList.length; i++) {
        String currencyName = allCoinsList.elementAt(i).coinPairWith;
        if (currencyName.toLowerCase() == selectedCurrency.toLowerCase()) {
          selectedCurrencyCoins.add(Coin(
            coinID: allCoinsList.elementAt(i).coinID,
            coinImage: allCoinsList.elementAt(i).coinImage,
            coinName: allCoinsList.elementAt(i).coinName,
            coinShortName: allCoinsList.elementAt(i).coinShortName,
            coinPrice: allCoinsList.elementAt(i).coinPrice,
            coinLastPrice: allCoinsList.elementAt(i).coinLastPrice,
            coinPercentage: allCoinsList.elementAt(i).coinPercentage,
            coinSymbol: allCoinsList.elementAt(i).coinSymbol,
            coinPairWith: allCoinsList.elementAt(i).coinPairWith,
            coinHighDay: allCoinsList.elementAt(i).coinHighDay,
            coinLowDay: allCoinsList.elementAt(i).coinLowDay,
            coinDecimalCurrency: allCoinsList.elementAt(i).coinDecimalCurrency,
          ));
        }
      }
    } else {
      selectedCurrency.value = currencyName;
      selectedCurrencyCoins.clear();
      for (int i = 0; i < allCoinsList.length; i++) {
        String currencyName = allCoinsList.elementAt(i).coinPairWith;
        if (currencyName.toLowerCase() == selectedCurrency.toLowerCase()) {
          selectedCurrencyCoins.add(Coin(
            coinID: allCoinsList.elementAt(i).coinID,
            coinImage: allCoinsList.elementAt(i).coinImage,
            coinName: allCoinsList.elementAt(i).coinName,
            coinShortName: allCoinsList.elementAt(i).coinShortName,
            coinPrice: allCoinsList.elementAt(i).coinPrice,
            coinLastPrice: allCoinsList.elementAt(i).coinPrice,
            coinPercentage: allCoinsList.elementAt(i).coinPercentage,
            coinSymbol: allCoinsList.elementAt(i).coinSymbol,
            coinPairWith: allCoinsList.elementAt(i).coinPairWith,
            coinHighDay: allCoinsList.elementAt(i).coinHighDay,
            coinLowDay: allCoinsList.elementAt(i).coinLowDay,
            coinDecimalCurrency: allCoinsList.elementAt(i).coinDecimalCurrency,
          ));
        }
      }
    }
    update();
  }

  void updateCoin(
      String coinSymbol, String coinPrice, String coinPercentage) async {
    var inrPairCoins = coinSymbol.substring(0, coinSymbol.length - 4);

    var index = allCoinsList.where((element) =>
        element.coinSymbol.toUpperCase() == coinSymbol.toUpperCase() ||
        element.coinSymbol.toUpperCase() == '${inrPairCoins.toUpperCase()}INR');
    var selectedCurrencyIndex = selectedCurrencyCoins.where((element) =>
        element.coinSymbol.toUpperCase() == coinSymbol.toUpperCase() ||
        element.coinSymbol.toUpperCase() == '${inrPairCoins.toUpperCase()}INR');
    var wishlistIndex = wishlistCoinsList.where((element) =>
        element.coinSymbol.toUpperCase() == coinSymbol.toUpperCase());

    for (var i in index) {
      i.coinPrice = coinPrice;
      i.coinPercentage = coinPercentage;
    }

    for (var i in selectedCurrencyIndex) {
      i.coinPrice = coinPrice;
      i.coinPercentage = coinPercentage;
    }

    for (var i in wishlistIndex) {
      i.coinPrice = coinPrice;
      i.coinPercentage = coinPercentage;
    }

    update();
  }

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
