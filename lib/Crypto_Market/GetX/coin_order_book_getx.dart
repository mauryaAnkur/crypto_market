import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

import '../Model/coin_model.dart';
import '../Model/coin_order_volume_model.dart';

class OrderBookController extends GetxController {

  static OrderBookController get to => Get.put(OrderBookController());

  List<OrderVolume> coinOrderBookBuyList = <OrderVolume>[].obs;
  List<OrderVolume> coinOrderBookSellList = <OrderVolume>[].obs;

  int itemCount = 20;


  getOrderBook({required Coin coinData, required String listedCoinOrderBookUrl}) async {

    !coinData.coinListed ? await connectToBinanceServer(coinData) : await getListedCoinOrderBook(listedCoinOrderBookUrl);

    update();
  }


  updateOrderBook(data) {

    List<double> buys=[];
    List<double> asks=[];

    if(data['bids'] != null) {
      if(data['bids'].length > 0) {
        double largeValue = 0.0;

        for (int i = 0; i < data['bids'].length; i++) {
          buys.add(double.parse(data['bids'][i][1]));
          asks.add(double.parse(data['asks'][i][1]));
          largeValue = buys.reduce(max) > asks.reduce(max) ? buys.reduce(max) : asks.reduce(max);

          // coinOrderBookBuyList.insert(i, OrderVolume(
          //   number: i.toString(),
          //   price: double.parse(data['bids'][i][0]).toString(),
          //   // value: double.parse(data['bids'][i][1].toString()).toString(),
          //   value:  coinOrderBookBuyList.isEmpty
          //       ? double.parse(data['bids'][i][1].toString()).toString()
          //       : (double.parse(data['bids'][i][1].toString()) + double.parse(coinOrderBookBuyList.elementAt(coinOrderBookBuyList.length - 1).value)).toString(),
          //   percent: (double.parse(data['bids'][i][1].toString()) / largeValue).toString(),
          // ));
          //
          // coinOrderBookSellList.insert(i, OrderVolume(
          //   number: i.toString(),
          //   price: double.parse(data['asks'][i][0]).toString(),
          //   // value: double.parse(data['asks'][i][1].toString()).toString(),
          //   value: coinOrderBookSellList.isEmpty
          //       ? double.parse(data['asks'][i][1].toString()).toString()
          //       : (double.parse(data['asks'][i][1].toString()) + double.parse(coinOrderBookSellList.elementAt(coinOrderBookSellList.length - 1).value)).toString(),
          //   percent: (double.parse(data['asks'][i][1].toString()) / largeValue).toString(),
          // ));


          ///

          int buyIndex = coinOrderBookBuyList.isNotEmpty ? coinOrderBookBuyList.indexWhere((element) => double.parse(element.price) == double.parse(data['bids'][i][0])) : -1;
          int sellIndex = coinOrderBookSellList.isNotEmpty ? coinOrderBookSellList.indexWhere((element) => double.parse(element.price) == double.parse(data['asks'][i][0])) : -1;

          if(buyIndex >= 0) {
            coinOrderBookBuyList[buyIndex] = OrderVolume(
              number: i.toString(),
              price: double.parse(data['bids'][i][0]).toString(),
              value: double.parse(data['bids'][i][1].toString()).toString(),
              // value:  coinOrderBookBuyList.isEmpty
              //     ? double.parse(data['bids'][i][1].toString()).toString()
              //     : (double.parse(data['bids'][i][1].toString()) + double.parse(coinOrderBookBuyList.elementAt(coinOrderBookBuyList.length - 1).value)).toString(),
              percent: (double.parse(data['bids'][i][1].toString()) / largeValue).toString(),
            );
          } else {
            coinOrderBookBuyList.add(OrderVolume(
              number: i.toString(),
              price: double.parse(data['bids'][i][0]).toString(),
              value: double.parse(data['bids'][i][1].toString()).toString(),
              // value:  coinOrderBookBuyList.isEmpty
              //     ? double.parse(data['bids'][i][1].toString()).toString()
              //     : (double.parse(data['bids'][i][1].toString()) + double.parse(coinOrderBookBuyList.elementAt(coinOrderBookBuyList.length - 1).value)).toString(),
              percent:
                  (double.parse(data['bids'][i][1].toString()) / largeValue)
                      .toString(),
            ));
          }

          if(sellIndex >= 0) {
            coinOrderBookSellList[sellIndex] = OrderVolume(
              number: i.toString(),
              price: double.parse(data['bids'][i][0]).toString(),
              value: double.parse(data['bids'][i][1].toString()).toString(),
              // value:  coinOrderBookBuyList.isEmpty
              //     ? double.parse(data['bids'][i][1].toString()).toString()
              //     : (double.parse(data['bids'][i][1].toString()) + double.parse(coinOrderBookBuyList.elementAt(coinOrderBookBuyList.length - 1).value)).toString(),
              percent: (double.parse(data['bids'][i][1].toString()) / largeValue).toString(),
            );
          } else {
            coinOrderBookSellList.add(OrderVolume(
              number: i.toString(),
              price: double.parse(data['asks'][i][0]).toString(),
              value: double.parse(data['asks'][i][1].toString()).toString(),
              // value: coinOrderBookSellList.isEmpty
              //     ? double.parse(data['asks'][i][1].toString()).toString()
              //     : (double.parse(data['asks'][i][1].toString()) + double.parse(coinOrderBookSellList.elementAt(coinOrderBookSellList.length - 1).value)).toString(),
              percent:
                  (double.parse(data['asks'][i][1].toString()) / largeValue)
                      .toString(),
            ));
          }
          coinOrderBookBuyList.sort((a, b) {
            return double.parse(a.price).compareTo(double.parse(b.price));
          });
          coinOrderBookSellList.sort((a, b) {
            return double.parse(a.price).compareTo(double.parse(b.price));
          });





          ///

        }
      }
    }

    if(coinOrderBookBuyList.length > itemCount) {
      coinOrderBookBuyList.removeAt(0);
    }
    if(coinOrderBookSellList.length > itemCount) {
      coinOrderBookSellList.removeAt(0);
    }

    update();
  }


  getListedCoinOrderBook(String listedCoinOrderBookUrl) async {

    var response = await http.get(Uri.parse(listedCoinOrderBookUrl));
    var data = json.decode(response.body);

    List<double> buys=[];
    List<double> asks=[];

    coinOrderBookBuyList = <OrderVolume>[].obs;
    coinOrderBookSellList = <OrderVolume>[].obs;

    if(data['data']['bids'].length > 0 || data['data']['asks'].length > 0) {

      double buyLargeValue = 0.0;
      double sellLargeValue = 0.0;

      for (int i = 0; i < data['data']['bids'].length; i++) {

        buys.add(double.parse(data['data']['bids'][i][1]));
        i < data['data']['asks'].length ? asks.add(double.parse(data['data']['asks'][i][1])) : null;
        buyLargeValue = buys.reduce(max) > asks.reduce(max) ? buys.reduce(max) : asks.reduce(max);

        coinOrderBookBuyList.insert(i, OrderVolume(
          number: i.toString(),
          price: double.parse(data['data']['bids'][i][0].toString()).toString(),
          // value: double.parse(data['data']['bids'][i][1].toString()).toString(),
          value:  coinOrderBookBuyList.isEmpty
              ? double.parse(data['data']['bids'][i][1].toString()).toString()
              : (double.parse(data['data']['bids'][i][1].toString()) + double.parse(coinOrderBookBuyList.elementAt(coinOrderBookBuyList.length - 1).value)).toString(),
          percent: (double.parse(data['data']['bids'][i][1].toString()) / buyLargeValue).toString(),
        ));
      }

      for (int i = 0; i < data['data']['asks'].length; i++) {

        sellLargeValue = buys.isNotEmpty ? buys.reduce(max) > asks.reduce(max) ? buys.reduce(max) : asks.reduce(max) : 1.00;

        coinOrderBookSellList.insert(i, OrderVolume(
          number: i.toString(),
          price: double.parse(data['data']['asks'][i][0].toString()).toString(),
          // value: double.parse(data['data']['asks'][i][1].toString()).toString(),
          value: coinOrderBookSellList.isEmpty
              ? double.parse(data['data']['asks'][i][1].toString()).toString()
              : (double.parse(data['data']['asks'][i][1].toString()) + double.parse(coinOrderBookSellList.elementAt(coinOrderBookSellList.length - 1).value)).toString(),
          percent: (double.parse(data['data']['asks'][i][1].toString()) / sellLargeValue).toString(),
        ));
      }

    }
    update();
  }


  connectToBinanceServer(Coin coinData) {
    WebSocketChannel channelHome = IOWebSocketChannel.connect(Uri.parse('wss://stream.binance.com:9443/ws/stream?'),);

    Map<String, Object> subRequestHome;

    if(coinData.coinPairWith == "INR"){
      subRequestHome = {
        'method': "SUBSCRIBE",
        'params': [
          '${coinData.coinShortName.toLowerCase()}usdt@depth20@1000ms',
        ],
        'id': 3,
      };
    }
    else {
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
      updateOrderBook(snapshot);
    });
  }

  connectToListedCoinServer() {}

}