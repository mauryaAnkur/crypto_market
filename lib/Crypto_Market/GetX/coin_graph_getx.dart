import 'dart:async';
import 'dart:convert';

import 'package:crypto_market/Crypto_Market/API/coin_fetch_graph_api.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:k_chart/entity/k_line_entity.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../Model/coin_model.dart';

class CoinGraphController extends GetxController {
  static CoinGraphController get to => Get.put(CoinGraphController());

  List<KLineEntity> kChartCandles = <KLineEntity>[].obs;
  List<FlSpot> lineChart = <FlSpot>[].obs;

  String interval = '1m';

  double inrRate = 0.0;

  WebSocketChannel channelHome = IOWebSocketChannel.connect(
    Uri.parse('wss://stream.binance.com:9443/ws/stream?'),
  );

  getCandles({required Coin coinData, required String interval}) async {
    if (coinData.pairWith.toUpperCase() == "INR") {
      try {
        fetchCandles(
          symbol: "${coinData.shortName.toUpperCase()}USDT",
          interval: interval,
        ).then((value) {
          kChartCandles.clear();
          lineChart.clear();
          for (int i = 0; i < value.length; i++) {
            kChartCandles.add(KLineEntity.fromCustom(
                time: value[i].date.millisecondsSinceEpoch,
                amount: value[i].high * inrRate,
                change: value[i].volume,
                close: value[i].close * inrRate,
                high: value[i].high * inrRate,
                low: value[i].low * inrRate,
                open: value[i].open * inrRate,
                vol: value[i].volume,
                ratio: value[i].low * inrRate));

            lineChart.add(FlSpot(
              double.parse(value[i].date.millisecondsSinceEpoch.toString()),
              value[i].close * inrRate,
            ));
          }
        });
      } catch (e) {
        kChartCandles.clear();
        lineChart.clear();
        return;
      }
    } else {
      try {
        fetchCandles(
          symbol: coinData.symbol.toUpperCase(),
          interval: interval,
        ).then(
          (value) {
            kChartCandles.clear();
            lineChart.clear();
            for (int i = 0; i < value.length; i++) {
              kChartCandles.add(KLineEntity.fromCustom(
                  time: value[i].date.millisecondsSinceEpoch,
                  amount: value[i].high,
                  change: value[i].volume,
                  close: value[i].close,
                  high: value[i].high,
                  low: value[i].low,
                  open: value[i].open,
                  vol: value[i].volume,
                  ratio: value[i].low));

              lineChart.add(
                FlSpot(
                  double.parse(value[i].date.millisecondsSinceEpoch.toString()),
                  value[i].close,
                ),
              );
            }
          },
        );
      } catch (e) {
        kChartCandles.clear();
        lineChart.clear();
        return;
      }
    }

    connectToBinanceServer(coinData, interval);
    update();
  }

  updateCoinGraph(data, Coin coinData) {
    if (data.containsKey("k") == true &&
        kChartCandles[kChartCandles.length - 1].time! < data["k"]["t"]) {
      if (coinData.pairWith.toUpperCase() == "INR") {
        kChartCandles.add(KLineEntity.fromCustom(
            time: data["k"]["t"],
            amount: double.parse(data["k"]["h"].toString()) * inrRate,
            change: double.parse(data["k"]["v"].toString()),
            close: double.parse(data["k"]["c"].toString()) * inrRate,
            high: double.parse(data["k"]["h"].toString()) * inrRate,
            low: double.parse(data["k"]["l"].toString()) * inrRate,
            open: double.parse(data["k"]["o"].toString()) * inrRate,
            vol: double.parse(data["k"]["v"].toString()),
            ratio: double.parse(data["k"]["c"].toString())));
      } else {
        kChartCandles.add(KLineEntity.fromCustom(
            time: data["k"]["t"],
            amount: double.parse(data["k"]["h"].toString()),
            change: double.parse(data["k"]["v"].toString()),
            close: double.parse(data["k"]["c"].toString()),
            high: double.parse(data["k"]["h"].toString()),
            low: double.parse(data["k"]["l"].toString()),
            open: double.parse(data["k"]["o"].toString()),
            vol: double.parse(data["k"]["v"].toString()),
            ratio: double.parse(data["k"]["c"].toString())));
      }
    } else if (data.containsKey("k") == true) {
      if (coinData.pairWith.toUpperCase() == "INR") {
        kChartCandles[kChartCandles.length - 1] = KLineEntity.fromCustom(
            time: data["k"]["t"],
            amount: double.parse(data["k"]["h"]) * inrRate,
            change: double.parse(data["k"]["v"].toString()),
            close: double.parse(data["k"]["c"]) * inrRate,
            high: double.parse(data["k"]["h"]) * inrRate,
            low: double.parse(data["k"]["l"]) * inrRate,
            open: double.parse(data["k"]["o"]) * inrRate,
            vol: double.parse(data["k"]["v"].toString()),
            ratio: double.parse(data["k"]["c"].toString()));
      } else {
        kChartCandles[kChartCandles.length - 1] = KLineEntity.fromCustom(
            time: data["k"]["t"],
            amount: double.parse(data["k"]["h"].toString()),
            change: double.parse(data["k"]["v"].toString()),
            close: double.parse(data["k"]["c"].toString()),
            high: double.parse(data["k"]["h"].toString()),
            low: double.parse(data["k"]["l"].toString()),
            open: double.parse(data["k"]["o"].toString()),
            vol: double.parse(data["k"]["v"].toString()),
            ratio: double.parse(data["k"]["c"].toString()));
      }
    }
    update();
  }

  connectToBinanceServer(Coin coinData, String interval) {
    channelHome.sink.close();
    channelHome = IOWebSocketChannel.connect(
      Uri.parse('wss://stream.binance.com:9443/ws/stream?'),
    );

    var subRequestHome = {
      'method': "SUBSCRIBE",
      'params': ['${coinData.shortName.toLowerCase()}usdt@kline_$interval'],
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
      updateCoinGraph(snapshot, coinData);
    });
  }
}
