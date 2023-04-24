import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../Model/coin_model.dart';
import '../Model/coin_order_volume_model.dart';

/// OrderBookController is extends with GetXController
/// that helps in state management
///
/// OrderBookController update the UI instantly
class OrderBookController extends GetxController {
  static OrderBookController get to => Get.put(OrderBookController());

  /// coin order book buy list
  List<OrderVolume> coinOrderBookBuyList = <OrderVolume>[].obs;

  /// coin order book sell list
  List<OrderVolume> coinOrderBookSellList = <OrderVolume>[].obs;

  /// itemCount is the length of the list
  int itemCount = 20;

  /// websocket
  WebSocketChannel channelHome = IOWebSocketChannel.connect(
    /// webSocket url
    Uri.parse('wss://stream.binance.com:9443/ws/stream?'),
  );

  /// get coin order books
  getOrderBook({required Coin coinData}) async {
    await connectToBinanceServer(coinData);

    /// update UI
    update();
  }

  /// update UI whenever a new item inserted into
  /// order book list
  updateOrderBook(data) {
    /// buys list
    List<double> buys = [];

    /// asks list
    List<double> asks = [];

    /// check data['bids'] != null
    if (data['bids'] != null) {
      /// check data['bids'] length is greater then zero
      if (data['bids'].length > 0) {
        /// large value is used to indicate the percentage of color
        double largeValue = 0.0;

        for (int i = 0; i < data['bids'].length; i++) {
          buys.add(double.parse(data['bids'][i][1]));
          asks.add(double.parse(data['asks'][i][1]));
          largeValue = buys.reduce(max) > asks.reduce(max)
              ? buys.reduce(max)
              : asks.reduce(max);

          /// insert an item into
          /// coin order book buy list
          coinOrderBookBuyList.insert(
              i,
              OrderVolume(
                price: double.parse(data['bids'][i][0]).toString(),
                value: double.parse(data['bids'][i][1].toString()).toString(),
                // value: coinOrderBookBuyList.isEmpty
                //     ? double.parse(data['bids'][i][1].toString()).toString()
                //     : (double.parse(data['bids'][i][1].toString()) +
                //             double.parse(coinOrderBookBuyList
                //                 .elementAt(coinOrderBookBuyList.length - 1)
                //                 .value))
                //         .toString(),
                percent:
                    (double.parse(data['bids'][i][1].toString()) / largeValue)
                        .toString(),
              ));

          /// insert an item into
          /// coin order book sell list
          coinOrderBookSellList.insert(
              i,
              OrderVolume(
                price: double.parse(data['asks'][i][0]).toString(),
                value: double.parse(data['asks'][i][1].toString()).toString(),
                // value: coinOrderBookSellList.isEmpty
                //     ? double.parse(data['asks'][i][1].toString()).toString()
                //     : (double.parse(data['asks'][i][1].toString()) +
                //             double.parse(coinOrderBookSellList
                //                 .elementAt(coinOrderBookSellList.length - 1)
                //                 .value))
                //         .toString(),
                percent:
                    (double.parse(data['asks'][i][1].toString()) / largeValue)
                        .toString(),
              ));
        }
      }
    }

    /// if coin order book buy list length is greater than item count
    /// then delete the item at index 0 from list
    if (coinOrderBookBuyList.length > itemCount) {
      coinOrderBookBuyList.removeAt(0);
    }

    /// if coin order book sell list length is greater than item count
    /// then delete the item at index 0 from list
    if (coinOrderBookSellList.length > itemCount) {
      coinOrderBookSellList.removeAt(0);
    }

    /// update UI
    update();
  }

  /// connect to binance server
  connectToBinanceServer(Coin coinData) {
    channelHome.sink.close();
    channelHome = IOWebSocketChannel.connect(
      /// webSocket url
      Uri.parse('wss://stream.binance.com:9443/ws/stream?'),
    );

    Map<String, Object> subRequestHome;

    /// check coinPair is INR or not
    if (coinData.coinPairWith == "INR") {
      subRequestHome = {
        'method': "SUBSCRIBE",
        'params': [
          '${coinData.coinShortName.toLowerCase()}usdt@depth20@1000ms',
        ],
        'id': 3,
      };
    } else {
      subRequestHome = {
        'method': "SUBSCRIBE",
        'params': [
          '${coinData.coinSymbol.toLowerCase()}@depth20@1000ms',
        ],
        'id': 3,
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

      if (coinOrderBookBuyList.isNotEmpty) {
        /// if coin order book buy list length is greater than item count
        /// then delete the item at index 0 from list
        if (coinOrderBookBuyList.length > itemCount) {
          for (var i = 0; i < coinOrderBookBuyList.length; i++) {
            if (i > itemCount) {
              coinOrderBookBuyList.removeAt(i);
            }
          }
        }
      }

      if (coinOrderBookSellList.isNotEmpty) {
        /// if coin order book sell list length is greater than item count
        /// then delete the item at index 0 from list
        if (coinOrderBookSellList.length > itemCount) {
          for (var i = 0; i < coinOrderBookSellList.length; i++) {
            if (i > itemCount) {
              coinOrderBookSellList.removeAt(i);
            }
          }
        }
      }

      /// update order book
      updateOrderBook(snapshot);
    });
  }
}
