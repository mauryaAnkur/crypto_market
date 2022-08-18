import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../Model/coin_model.dart';
import '../Model/coin_trade_history_model.dart';

class TradeHistoryController extends GetxController {

  static TradeHistoryController get to => Get.put(TradeHistoryController());

  List<CoinTradeHistory> tradeHistoryList = <CoinTradeHistory>[].obs;
  int itemCount = 20;

  addData(CoinTradeHistory coinTradeHistory) {
    tradeHistoryList.add(coinTradeHistory);

    if(tradeHistoryList.length > itemCount) {
      tradeHistoryList.removeAt(0);
    }
    update();
  }

  connectToTradeHistory(Coin coinData) {

    WebSocketChannel channelHome = IOWebSocketChannel.connect(Uri.parse('wss://stream.binance.com:9443/ws/stream?'),);

    Map<String, dynamic> subRequestHome;

    if(coinData.coinPairWith.toUpperCase() == 'INR') {
      subRequestHome = {
        'method': "SUBSCRIBE",
        'params': ['${coinData.coinShortName.toLowerCase()}usdt@trade'],
        'id': 1,
      };
    } else {
      subRequestHome = {
        'method': "SUBSCRIBE",
        'params': ['${coinData.coinSymbol.toLowerCase()}@trade'],
        'id': 1,
      };
    }


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
      addData(CoinTradeHistory(
          date: snapshot['T'] == null ? "" : DateTime.fromMillisecondsSinceEpoch(snapshot['T']).toString().split(' ')[1],
          type: snapshot['m'] == true ? "Buy" : "Sell",
          price: snapshot['p'] == null ? "" : double.parse(snapshot['p'].toString()).toString(),
          amount:  snapshot['q'] == null ? "" : snapshot['q'].toString()));
    });
  }

}
