import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../Model/coin_model.dart';


class CoinController extends GetxController {

  static CoinController get to => Get.put(CoinController());

  List<Coin> allCoinsList = <Coin>[].obs;
  var selectedTabIndex = 1.obs;


  getCoins(List<Coin> coinsList, List<String> tickerList) async {
    allCoinsList = coinsList;
    connectToServer(tickerList);
    update();
  }


  ///
  var selectedCurrency = ''.obs;
  List selectedCurrencyCoins = [].obs;


  getSelectCurrencyList(String currencyName) async {
    if(selectedCurrency.isEmpty) {

      selectedCurrency.value = currencyName;

      for (int i = 0; i < allCoinsList.length; i++) {
        String  currencyName = allCoinsList.elementAt(i).coinPairWith;
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
            coinDecimalPair: allCoinsList.elementAt(i).coinDecimalPair,
            coinDecimalCurrency: allCoinsList.elementAt(i).coinDecimalCurrency,
            coinListed: allCoinsList.elementAt(i).coinListed,
          ));
        }
      }
    }
    else {

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
            coinDecimalPair: allCoinsList.elementAt(i).coinDecimalPair,
            coinDecimalCurrency: allCoinsList.elementAt(i).coinDecimalCurrency,
            coinListed: allCoinsList.elementAt(i).coinListed,
          ));
        }
      }
    }
    update();
  }

  void updateCoin(String coinSymbol, String coinPrice, String coinPercentage) async {

    var inrPairCoins = coinSymbol.substring(0, coinSymbol.length - 4);
    // print('string substring ===>  ${inrPairCoins+'INR'}');
    // if(coinSymbol.substring(0, coinSymbol.length - 4)) {
    //
    // }
    allCoinsList.indexWhere((element) => element.coinSymbol.toUpperCase() == coinSymbol.toUpperCase());

    var index = allCoinsList.indexWhere((element) => element.coinSymbol.toUpperCase() == coinSymbol.toUpperCase() || element.coinSymbol.toUpperCase() == '${inrPairCoins.toUpperCase()}INR');
    var selectedCurrencyIndex = selectedCurrencyCoins.indexWhere((element) => element.coinSymbol.toUpperCase() == coinSymbol.toUpperCase() || element.coinSymbol.toUpperCase() == '${inrPairCoins.toUpperCase()}INR');
    // var wishlistIndex = allWishlist.indexWhere((element) => element.coinSymbol.toUpperCase() == coinSymbol.toUpperCase());

    // print('coinName @@@@@ Index  $selectedCurrencyIndex');

    if(index >= 0) {
      allCoinsList.elementAt(index).coinPrice = coinPrice;
      allCoinsList.elementAt(index).coinPercentage = coinPercentage;
    }

    if(selectedCurrencyIndex >= 0) {
      selectedCurrencyCoins.elementAt(selectedCurrencyIndex).coinPrice = coinPrice;
      selectedCurrencyCoins.elementAt(selectedCurrencyIndex).coinPercentage = coinPercentage;
    }

    // if(wishlistIndex >= 0) {
    //   allWishlist.elementAt(wishlistIndex).coinPrice = coinPrice;
    //   allWishlist.elementAt(wishlistIndex).coinPercentage = coinPercentage;
    // }

    update();

    // notifyListeners();
  }
  ///

  connectToServer(tickerList) {

    WebSocketChannel channelHome = IOWebSocketChannel.connect(Uri.parse('wss://stream.binance.com:9443/ws/stream?'),);

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

      updateCoin(snapshot['s'].toString(), snapshot['c'].toString(), snapshot['P'].toString());
    });
  }


}