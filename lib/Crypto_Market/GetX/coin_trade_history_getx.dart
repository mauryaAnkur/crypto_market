import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../Model/coin_model.dart';
import '../Model/coin_trade_history_model.dart';

class TradeHistoryController extends GetxController {
  static TradeHistoryController get to => Get.put(TradeHistoryController());

  List<TradeHistory> tradeHistoryList = <TradeHistory>[].obs;
  int itemCount = 20;

  WebSocketChannel channelHome = IOWebSocketChannel.connect(
    Uri.parse('wss://stream.binance.com:9443/ws/stream?'),
  );

  addData(TradeHistory coinTradeHistory) {
    tradeHistoryList.add(coinTradeHistory);

    if (tradeHistoryList.length > itemCount) {
      tradeHistoryList.removeAt(0);
    }
    update();
  }

  connectToTradeHistory(Coin coinData) {
    channelHome.sink.close();
    channelHome = IOWebSocketChannel.connect(
      Uri.parse('wss://stream.binance.com:9443/ws/stream?'),
    );

    Map<String, dynamic> subRequestHome;

    if (coinData.pairWith.toUpperCase() == 'INR') {
      subRequestHome = {
        'method': "SUBSCRIBE",
        'params': ['${coinData.shortName.toLowerCase()}usdt@trade'],
        'id': 1,
      };
    } else {
      subRequestHome = {
        'method': "SUBSCRIBE",
        'params': ['${coinData.symbol.toLowerCase()}@trade'],
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
      addData(TradeHistory(
          date: snapshot['T'] == null
              ? ""
              : DateTime.fromMillisecondsSinceEpoch(snapshot['T'])
                  .toString()
                  .split(' ')[1],
          type: snapshot['m'] == true ? "Buy" : "Sell",
          price: snapshot['p'] == null ? "0" : snapshot['p'].toString(),
          amount: snapshot['q'] == null ? "0" : snapshot['q'].toString()));
    });
  }
}
