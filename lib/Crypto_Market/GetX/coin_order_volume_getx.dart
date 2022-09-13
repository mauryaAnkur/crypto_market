import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

import '../Model/coin_model.dart';
import '../Model/coin_order_volume_model.dart';

/// OrderVolumeController is extends with GetXController
/// that helps in state management
///
/// OrderVolumeController update the UI instantly
class OrderVolumeController extends GetxController {
  static OrderVolumeController get to => Get.put(OrderVolumeController());

  /// coin order volume buy list
  List<OrderVolume> coinOrderVolumeBuyList = <OrderVolume>[].obs;

  /// coin order volume sell list
  List<OrderVolume> coinOrderVolumeSellList = <OrderVolume>[].obs;

  /// itemCount is the length of the list
  int itemCount = 20;

  /// get coin order volumes
  getOrderVolume(
      {required Coin coinData, required String listedCoinOrderBookUrl}) async {
    /// if coin is listed then connect to binance server,
    /// else get order volumes from listed coin url
    !coinData.coinListed
        ? await connectToBinanceServer(coinData)
        : await getListedCoinOrderVolume(listedCoinOrderBookUrl);

    /// update UI
    update();
  }

  /// update UI whenever a new item inserted into
  /// order volume list
  updateOrderVolume(data) {
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
          /// coin order volume buy list
          coinOrderVolumeBuyList.insert(
              i,
              OrderVolume(
                price: double.parse(data['bids'][i][0]).toString(),
                value: double.parse(data['bids'][i][1].toString()).toString(),
                percent:
                    (double.parse(data['bids'][i][1].toString()) / largeValue)
                        .toString(),
              ));

          /// insert an item into
          /// coin order volume sell list
          coinOrderVolumeSellList.insert(
              i,
              OrderVolume(
                price: double.parse(data['asks'][i][0]).toString(),
                value: double.parse(data['asks'][i][1].toString()).toString(),
                percent:
                    (double.parse(data['asks'][i][1].toString()) / largeValue)
                        .toString(),
              ));
        }
      }
    }

    /// if coin order volume buy list length is greater than item count
    /// then delete the item at index 0 from list
    if (coinOrderVolumeBuyList.length > itemCount) {
      coinOrderVolumeBuyList.removeAt(0);
    }

    /// if coin order volume sell list length is greater than item count
    /// then delete the item at index 0 from list
    if (coinOrderVolumeSellList.length > itemCount) {
      coinOrderVolumeSellList.removeAt(0);
    }

    /// update UI
    update();
  }

  /// get listed coin order volume
  getListedCoinOrderVolume(String listedCoinOrderBookUrl) async {
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
        /// coin order volume buy list
        coinOrderVolumeBuyList.insert(
            i,
            OrderVolume(
              price: double.parse(data['data']['bids'][i][0].toString())
                  .toString(),
              value: double.parse(data['data']['bids'][i][1].toString())
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
        /// coin order volume sell list
        coinOrderVolumeSellList.insert(
            i,
            OrderVolume(
              price: double.parse(data['data']['asks'][i][0].toString())
                  .toString(),
              value: double.parse(data['data']['asks'][i][1].toString())
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

      /// update order volume
      updateOrderVolume(snapshot);
    });
  }

  connectToListedCoinServer() {}
}
