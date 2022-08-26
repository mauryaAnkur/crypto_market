import 'dart:convert';

import 'package:k_chart/entity/k_line_entity.dart';
import 'package:http/http.dart' as http;

import '../Model/candle.dart';


Future<List<Candle>> fetchCandles({required String symbol, required String interval}) async {
  final uri = Uri.parse("https://api.binance.com/api/v3/klines?symbol=$symbol&interval=$interval&limit=1000");
  final res = await http.get(uri);

  List<dynamic> data = jsonDecode(res.body);
  return (data).map((e) => Candle.fromJson(e)).toList();
}


Future<List<Candle>> fetchListedCoinCandles({required String listedCoinGraphUrl}) async {
  final uri = Uri.parse(listedCoinGraphUrl);
  List<Candle> candleList = [];
  List<KLineEntity> dataKline = [];

  final res = await http.get(uri);
  var data = json.decode(res.body);

  for(var i=0; i<data['data'].length; i++) {

    candleList.add(Candle(
      date: DateTime.fromMillisecondsSinceEpoch(data['data'][i]['end_time']),
      high: double.parse(data['data'][i]['ohlc']['h'].toString()),
      // high: 1,
      low: double.parse(data['data'][i]['ohlc']['l'].toString()),
      open: double.parse(data['data'][i]['ohlc']['o'].toString()),
      close: double.parse(data['data'][i]['ohlc']['c'].toString()),
      volume: double.parse(data['data'][i]['ohlc']['v'].toString()),
      // volume: 1,
    ));

    dataKline.add(KLineEntity.fromCustom(
      time: data['data'][i]['end_time'],
      high: double.parse(data['data'][i]['ohlc']['h'].toString()),
      low: double.parse(data['data'][i]['ohlc']['l'].toString()),
      open: double.parse(data['data'][i]['ohlc']['o'].toString()),
      close: double.parse(data['data'][i]['ohlc']['c'].toString()),
      vol: double.parse(data['data'][i]['ohlc']['v'].toString()),
    ));

  }

  return candleList;
}