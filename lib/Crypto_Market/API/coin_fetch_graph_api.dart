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
