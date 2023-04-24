import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Model/candle.dart';

/// fetch candles using binance api
Future<List<Candle>> fetchCandles(
    {required String symbol, required String interval}) async {
  final uri = Uri.parse(
      "https://api.binance.com/api/v3/klines?symbol=$symbol&interval=$interval&limit=1000");
  final res = await http.get(uri);

  List<dynamic> data = jsonDecode(res.body);

  /// return candles
  return (data).map((e) => Candle.fromJson(e)).toList();
}

/// fetch listed coin candles
Future<List<Candle>> fetchListedCoinCandles(
    {required String listedCoinGraphUrl}) async {
  final uri = Uri.parse(listedCoinGraphUrl);
  List<Candle> candleList = [];

  final res = await http.get(uri);
  var data = json.decode(res.body);

  /// add candles into list
  for (var i = 0; i < data['data'].length; i++) {
    candleList.add(Candle(
      date: DateTime.fromMillisecondsSinceEpoch(data['data'][i]['end_time']),
      high: double.parse(data['data'][i]['ohlc']['h'].toString()),
      low: double.parse(data['data'][i]['ohlc']['l'].toString()),
      open: double.parse(data['data'][i]['ohlc']['o'].toString()),
      close: double.parse(data['data'][i]['ohlc']['c'].toString()),
      volume: double.parse(data['data'][i]['ohlc']['v'].toString()),
    ));
  }

  /// return candles
  return candleList;
}
