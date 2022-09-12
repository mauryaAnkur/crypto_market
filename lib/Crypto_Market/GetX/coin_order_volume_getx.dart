import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

import '../Model/coin_model.dart';
import '../Model/coin_order_volume_model.dart';

class OrderVolumeController extends GetxController {

  static OrderVolumeController get to => Get.put(OrderVolumeController());

  List<OrderVolume> coinOrderVolumeBuyList = <OrderVolume>[].obs;
  List<OrderVolume> coinOrderVolumeSellList = <OrderVolume>[].obs;


  getOrderVolume({required Coin coinData, required String listedCoinOrderBookUrl}) async {

    !coinData.coinListed ? await connectToBinanceServer(coinData) : await getListedCoinOrderVolume(listedCoinOrderBookUrl);

    update();
  }


  updateOrderVolume(data) {

    List<double> buys=[];
    List<double> asks=[];

    if(data['bids'] != null) {
      if(data['bids'].length > 0) {
        double largeValue = 0.0;

        for (int i = 0; i < data['bids'].length; i++) {
          buys.add(double.parse(data['bids'][i][1]));
          asks.add(double.parse(data['asks'][i][1]));
          largeValue = buys.reduce(max) > asks.reduce(max) ? buys.reduce(max) : asks.reduce(max);

          coinOrderVolumeBuyList.insert(i, OrderVolume(
            number: i.toString(),
            price: double.parse(data['bids'][i][0]).toString(),
            value: double.parse(data['bids'][i][1].toString()).toString(),
            percent: (double.parse(data['bids'][i][1].toString()) / largeValue).toString(),
          ));

          coinOrderVolumeSellList.insert(i, OrderVolume(
            number: i.toString(),
            price: double.parse(data['asks'][i][0]).toString(),
            value: double.parse(data['asks'][i][1].toString()).toString(),
            percent: (double.parse(data['asks'][i][1].toString()) / largeValue).toString(),
          ));

        }
      }
    }

    update();
  }


  getListedCoinOrderVolume(String listedCoinOrderBookUrl) async {

    var response = await http.get(Uri.parse(listedCoinOrderBookUrl));
    var data = json.decode(response.body);

    List<double> buys=[];
    List<double> asks=[];

    coinOrderVolumeBuyList = <OrderVolume>[].obs;
    coinOrderVolumeSellList = <OrderVolume>[].obs;

    if(data['data']['bids'].length > 0 || data['data']['asks'].length > 0) {

      double buyLargeValue = 0.0;
      double sellLargeValue = 0.0;

      for (int i = 0; i < data['data']['bids'].length; i++) {

        buys.add(double.parse(data['data']['bids'][i][1]));
        i < data['data']['asks'].length ? asks.add(double.parse(data['data']['asks'][i][1])) : null;
        buyLargeValue = buys.reduce(max) > asks.reduce(max) ? buys.reduce(max) : asks.reduce(max);

        coinOrderVolumeBuyList.insert(i, OrderVolume(
          number: i.toString(),
          price: double.parse(data['data']['bids'][i][0].toString()).toString(),
          value: double.parse(data['data']['bids'][i][1].toString()).toString(),
          percent: (double.parse(data['data']['bids'][i][1].toString()) / buyLargeValue).toString(),
        ));
      }

      for (int i = 0; i < data['data']['asks'].length; i++) {

        sellLargeValue = buys.isNotEmpty ? buys.reduce(max) > asks.reduce(max) ? buys.reduce(max) : asks.reduce(max) : 1.00;

        coinOrderVolumeSellList.insert(i, OrderVolume(
          number: i.toString(),
          price: double.parse(data['data']['asks'][i][0].toString()).toString(),
          value: double.parse(data['data']['asks'][i][1].toString()).toString(),
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
      updateOrderVolume(snapshot);
    });
  }

  connectToListedCoinServer() {}

}