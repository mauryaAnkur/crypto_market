import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

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

  /// get coin order books
  getOrderBook(
      {required Coin coinData, required String listedCoinOrderBookUrl}) async {
    /// if coin is listed then connect to binance server,
    /// else get order books from listed coin url
    !coinData.coinListed
        ? await connectToBinanceServer(coinData)
        : await getListedCoinOrderBook(listedCoinOrderBookUrl);

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
                // value: double.parse(data['bids'][i][1].toString()).toString(),
                value: coinOrderBookBuyList.isEmpty
                    ? double.parse(data['bids'][i][1].toString()).toString()
                    : (double.parse(data['bids'][i][1].toString()) +
                            double.parse(coinOrderBookBuyList
                                .elementAt(coinOrderBookBuyList.length - 1)
                                .value))
                        .toString(),
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
                // value: double.parse(data['asks'][i][1].toString()).toString(),
                value: coinOrderBookSellList.isEmpty
                    ? double.parse(data['asks'][i][1].toString()).toString()
                    : (double.parse(data['asks'][i][1].toString()) +
                            double.parse(coinOrderBookSellList
                                .elementAt(coinOrderBookSellList.length - 1)
                                .value))
                        .toString(),
                percent:
                    (double.parse(data['asks'][i][1].toString()) / largeValue)
                        .toString(),
              ));

          ///

          // int buyIndex = coinOrderBookBuyList.isNotEmpty
          //     ? coinOrderBookBuyList.indexWhere((element) =>
          //         double.parse(element.price) ==
          //         double.parse(data['bids'][i][0]))
          //     : -1;
          // int sellIndex = coinOrderBookSellList.isNotEmpty
          //     ? coinOrderBookSellList.indexWhere((element) =>
          //         double.parse(element.price) ==
          //         double.parse(data['asks'][i][0]))
          //     : -1;
          //
          // if (buyIndex >= 0) {
          //   coinOrderBookBuyList[buyIndex] = OrderVolume(
          //     price: double.parse(data['bids'][i][0]).toString(),
          //     value: double.parse(data['bids'][i][1].toString()).toString(),
          //     // value:  coinOrderBookBuyList.isEmpty
          //     //     ? double.parse(data['bids'][i][1].toString()).toString()
          //     //     : (double.parse(data['bids'][i][1].toString()) + double.parse(coinOrderBookBuyList.elementAt(coinOrderBookBuyList.length - 1).value)).toString(),
          //     percent:
          //         (double.parse(data['bids'][i][1].toString()) / largeValue)
          //             .toString(),
          //   );
          // } else {
          //   coinOrderBookBuyList.add(OrderVolume(
          //     price: double.parse(data['bids'][i][0]).toString(),
          //     value: double.parse(data['bids'][i][1].toString()).toString(),
          //     // value:  coinOrderBookBuyList.isEmpty
          //     //     ? double.parse(data['bids'][i][1].toString()).toString()
          //     //     : (double.parse(data['bids'][i][1].toString()) + double.parse(coinOrderBookBuyList.elementAt(coinOrderBookBuyList.length - 1).value)).toString(),
          //     percent:
          //         (double.parse(data['bids'][i][1].toString()) / largeValue)
          //             .toString(),
          //   ));
          // }
          //
          // if (sellIndex >= 0) {
          //   coinOrderBookSellList[sellIndex] = OrderVolume(
          //     price: double.parse(data['bids'][i][0]).toString(),
          //     value: double.parse(data['bids'][i][1].toString()).toString(),
          //     // value:  coinOrderBookBuyList.isEmpty
          //     //     ? double.parse(data['bids'][i][1].toString()).toString()
          //     //     : (double.parse(data['bids'][i][1].toString()) + double.parse(coinOrderBookBuyList.elementAt(coinOrderBookBuyList.length - 1).value)).toString(),
          //     percent:
          //         (double.parse(data['bids'][i][1].toString()) / largeValue)
          //             .toString(),
          //   );
          // } else {
          //   coinOrderBookSellList.add(OrderVolume(
          //     price: double.parse(data['asks'][i][0]).toString(),
          //     value: double.parse(data['asks'][i][1].toString()).toString(),
          //     // value: coinOrderBookSellList.isEmpty
          //     //     ? double.parse(data['asks'][i][1].toString()).toString()
          //     //     : (double.parse(data['asks'][i][1].toString()) + double.parse(coinOrderBookSellList.elementAt(coinOrderBookSellList.length - 1).value)).toString(),
          //     percent:
          //         (double.parse(data['asks'][i][1].toString()) / largeValue)
          //             .toString(),
          //   ));
          // }
          // coinOrderBookBuyList.sort((a, b) {
          //   return double.parse(a.price).compareTo(double.parse(b.price));
          // });
          // coinOrderBookSellList.sort((a, b) {
          //   return double.parse(a.price).compareTo(double.parse(b.price));
          // });

          ///

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

  /// get listed coin order book
  getListedCoinOrderBook(String listedCoinOrderBookUrl) async {
    var response = await http.get(Uri.parse(listedCoinOrderBookUrl));
    var data = json.decode(response.body);

    /// buys list
    List<double> buys = [];

    /// asks list
    List<double> asks = [];

    /// check data['bids'] != null
    if (data['data']['bids'].length > 0 || data['data']['asks'].length > 0) {
      double buyLargeValue = 0.0;
      double sellLargeValue = 0.0;

      for (int i = 0; i < data['data']['bids'].length; i++) {
        buys.add(double.parse(data['data']['bids'][i][1]));

        i < data['data']['asks'].length
            ? asks.add(double.parse(data['data']['asks'][i][1]))
            : null;

        /// buy large value
        buyLargeValue = buys.reduce(max) > asks.reduce(max)
            ? buys.reduce(max)
            : asks.reduce(max);

        /// insert an item into
        /// coin order book buy list
        coinOrderBookBuyList.insert(
            i,
            OrderVolume(
              price: double.parse(data['data']['bids'][i][0].toString())
                  .toString(),
              // value: double.parse(data['data']['bids'][i][1].toString()).toString(),
              value: coinOrderBookBuyList.isEmpty
                  ? double.parse(data['data']['bids'][i][1].toString())
                      .toString()
                  : (double.parse(data['data']['bids'][i][1].toString()) +
                          double.parse(coinOrderBookBuyList
                              .elementAt(coinOrderBookBuyList.length - 1)
                              .value))
                      .toString(),
              percent: (double.parse(data['data']['bids'][i][1].toString()) /
                      buyLargeValue)
                  .toString(),
            ));
      }

      for (int i = 0; i < data['data']['asks'].length; i++) {
        /// sell large value
        sellLargeValue = buys.isNotEmpty
            ? buys.reduce(max) > asks.reduce(max)
                ? buys.reduce(max)
                : asks.reduce(max)
            : 1.00;

        /// insert an item into
        /// coin order book sell list
        coinOrderBookSellList.insert(
            i,
            OrderVolume(
              price: double.parse(data['data']['asks'][i][0].toString())
                  .toString(),
              // value: double.parse(data['data']['asks'][i][1].toString()).toString(),
              value: coinOrderBookSellList.isEmpty
                  ? double.parse(data['data']['asks'][i][1].toString())
                      .toString()
                  : (double.parse(data['data']['asks'][i][1].toString()) +
                          double.parse(coinOrderBookSellList
                              .elementAt(coinOrderBookSellList.length - 1)
                              .value))
                      .toString(),
              percent: (double.parse(data['data']['asks'][i][1].toString()) /
                      sellLargeValue)
                  .toString(),
            ));
      }
    }

    /// update UI
    update();
  }

  /// connect to binance server
  connectToBinanceServer(Coin coinData) {
    WebSocketChannel channelHome = IOWebSocketChannel.connect(
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

      /// update order book
      updateOrderBook(snapshot);
    });
  }

  connectToListedCoinServer() {}
}
