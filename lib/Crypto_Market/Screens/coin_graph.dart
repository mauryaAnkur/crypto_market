import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k_chart/chart_style.dart';
// import 'package:flutter_k_chart/flutter_k_chart.dart';
// import 'package:k_chart/chart_style.dart';
import 'package:k_chart/entity/k_line_entity.dart';
import 'package:k_chart/k_chart_widget.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;


import '../Candle Chart/models/candle.dart';
import '../Candle Chart/models/indicator.dart';
import '../Candle Chart/utils/indicators/bollinger_bands_indicator.dart';
import '../Candle Chart/utils/indicators/moving_average_indicator.dart';
import '../Candle Chart/utils/indicators/weighted_moving_average.dart';
import '../Model/coin_model.dart';


class CoinGraph extends StatefulWidget {
  static const id = '/coinGraph';

  final Coin coinData;
  final String listedCoinGraphUrl;
  final double inrRate;
  // final double chartHeight;

  const CoinGraph({
    Key? key,
    required this.coinData,
    this.listedCoinGraphUrl = '',
    required this.inrRate,
    // required this.chartHeight,
  }) : super(key: key);

  @override
  State<CoinGraph> createState() => _CoinGraphState();
}


class _CoinGraphState extends State<CoinGraph> {

  bool isCandle = false;
  bool showVolume = false;
  bool showGrid = false;


  List<Candle> candles = <Candle>[].obs;
  List<KLineEntity> dataKline = [];
  WebSocketChannel _channels = IOWebSocketChannel.connect(Uri.parse('wss://stream.binance.com:9443/ws'),);

  ChartStyle chartStyle = ChartStyle();
  ChartColors chartColors = ChartColors();

  String interval = "1m";

  int nextIndex = 0;
  bool failed = false;

  List intervalsList = [
    '1m',
    '5m',
    '15m',
    '30m',
    '1h',
    '2h',
    '4h',
    '6h',
    '12h',
    '1d',
    '1w',
  ];

  List<Indicator> indicators = [
    BollingerBandsIndicator(
      length: 20,
      stdDev: 2,
      upperColor: const Color(0xFF2962FF),
      basisColor: const Color(0xFFFF6D00),
      lowerColor: const Color(0xFF2962FF),
    ),
    WeightedMovingAverageIndicator(
      length: 100,
      color: Colors.green.shade600,
    ),
    MovingAverageIndicator(length: 100, color: Colors.amber)
  ];


  /// listed coin details

  Future<List<Candle>> fetchListedCoinsCandles({required String symbol, required String interval, required double rate, required String familyCoin}) async {
    final uri = Uri.parse(widget.listedCoinGraphUrl);
    List<Candle> candleList = [];

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

  ///



  Future<List<Candle>> fetchCandles({required String symbol, required String interval, required double rate, required String familyCoin}) async {
    final uri = Uri.parse("https://api.binance.com/api/v3/klines?symbol=$symbol&interval=$interval&limit=1000");

    final res = await http.get(uri);

    ///new
    // var data = json.decode(res.body);
    //
    // for(var i=0; i<data['data'].length; i++) {
    //   print('uri ===>  ${data['data'][i]}');
    //   candleList.add(Candle(
    //       date: DateTime.fromMillisecondsSinceEpoch(data['data'][i]['end_time']),
    //       high: double.parse(data['data'][i]['ohlc']['h'].toString()),
    //       low: double.parse(data['data'][i]['ohlc']['l'].toString()),
    //       open: double.parse(data['data'][i]['ohlc']['o'].toString()),
    //       close: double.parse(data['data'][i]['ohlc']['c'].toString()),
    //       volume: 0.1,
    //   ));
    // }
    //
    // return candleList;
    ///


    /// old
    List<dynamic> data = jsonDecode(res.body);
    return (data).map((e) => Candle.fromJson(e)).toList();
    // return (data).map((e) => Candle.fromJson(e)).toList().reversed.toList();
  }


  void updateCandlesFromSnapshot(snapshot) async {

    if (snapshot.data != null) {

      final data = jsonDecode(snapshot.data as String) as Map<String, dynamic>;

      if (data.containsKey("k") == true && dataKline[dataKline.length-1].time! < data["k"]["t"]) {
        if(widget.coinData.coinPairWith.toUpperCase() == "INR") {
          // await getINRRate();
          dataKline.add(KLineEntity.fromCustom(time:data["k"]["t"],
              amount: double.parse(data["k"]["h"].toString()) * widget.inrRate,
              change:  double.parse(data["k"]["v"].toString()),
              close: double.parse(data["k"]["c"].toString()) * widget.inrRate,
              high: double.parse(data["k"]["h"].toString()) * widget.inrRate ,
              low: double.parse(data["k"]["l"].toString()) * widget.inrRate,
              open: double.parse(data["k"]["o"].toString()) * widget.inrRate,
              vol: double.parse(data["k"]["v"].toString()),
              ratio:double.parse(data["k"]["c"].toString())));

          /// candlesticks
          candles.add(Candle(
              date: DateTime.fromMillisecondsSinceEpoch(data["k"]["t"]),
              high: double.parse(data["k"]["h"].toString()) * widget.inrRate,
              low: double.parse(data["k"]["l"].toString()) * widget.inrRate,
              open: double.parse(data["k"]["o"].toString()) * widget.inrRate,
              close: double.parse(data["k"]["c"].toString()) * widget.inrRate,
              volume: double.parse(data["k"]["v"].toString()),
          ));
          ///


        }
        else {
          dataKline.add(KLineEntity.fromCustom(time:data["k"]["t"],
              amount: double.parse(data["k"]["h"].toString()),
              change:  double.parse(data["k"]["v"].toString()),
              close: double.parse(data["k"]["c"].toString()),
              high: double.parse(data["k"]["h"].toString()),
              low: double.parse(data["k"]["l"].toString()),
              open: double.parse(data["k"]["o"].toString()),
              vol: double.parse(data["k"]["v"].toString()),
              ratio:double.parse(data["k"]["c"].toString())));

          /// candlesticks
          candles.add(Candle(
            date: DateTime.fromMillisecondsSinceEpoch(data["k"]["t"]),
            high: double.parse(data["k"]["h"].toString()),
            low: double.parse(data["k"]["l"].toString()),
            open: double.parse(data["k"]["o"].toString()),
            close: double.parse(data["k"]["c"].toString()),
            volume: double.parse(data["k"]["v"].toString()),
          ));
          ///

        }
      }

      else if (data.containsKey("k") == true){
        if(widget.coinData.coinPairWith.toUpperCase() == "INR") {
          // await getINRRate();
          dataKline[dataKline.length - 1]=KLineEntity.fromCustom(time:data["k"]["t"],
              amount: double.parse(data["k"]["h"]) * widget.inrRate,
              change:  double.parse(data["k"]["v"].toString()),
              close: double.parse(data["k"]["c"]) * widget.inrRate,
              high: double.parse(data["k"]["h"]) * widget.inrRate ,
              low: double.parse(data["k"]["l"]) * widget.inrRate,
              open: double.parse(data["k"]["o"]) * widget.inrRate,
              vol: double.parse(data["k"]["v"].toString()),
              ratio:double.parse(data["k"]["c"].toString()));

          /// candlesticks
          candles[candles.length - 1] = Candle(
            date: DateTime.fromMillisecondsSinceEpoch(data["k"]["t"]),
            high: double.parse(data["k"]["h"].toString()) * widget.inrRate,
            low: double.parse(data["k"]["l"].toString()) * widget.inrRate,
            open: double.parse(data["k"]["o"].toString()) * widget.inrRate,
            close: double.parse(data["k"]["c"].toString()) * widget.inrRate,
            volume: double.parse(data["k"]["v"].toString()),
          );
          ///

        }
        else{
          dataKline[dataKline.length - 1] = KLineEntity.fromCustom(time:data["k"]["t"],
              amount: double.parse(data["k"]["h"].toString()),
              change:  double.parse(data["k"]["v"].toString()),
              close: double.parse(data["k"]["c"].toString()),
              high: double.parse(data["k"]["h"].toString()) ,
              low: double.parse(data["k"]["l"].toString()) ,
              open: double.parse(data["k"]["o"].toString()),
              vol: double.parse(data["k"]["v"].toString()),
              ratio:double.parse(data["k"]["c"].toString()));

          /// candlesticks
          candles[candles.length - 1] = Candle(
            date: DateTime.fromMillisecondsSinceEpoch(data["k"]["t"]),
            high: double.parse(data["k"]["h"].toString()),
            low: double.parse(data["k"]["l"].toString()),
            open: double.parse(data["k"]["o"].toString()),
            close: double.parse(data["k"]["c"].toString()),
            volume: double.parse(data["k"]["v"].toString()),
          );
          ///

        }
      }
    }
  }

  void binanceFetchCandle(String
  interval) {

    dataKline.clear();
    candles.clear();

    if(widget.coinData.coinPairWith.toUpperCase() == "INR") {
      try {
        !widget.coinData.coinListed ? fetchCandles(symbol: "${widget.coinData.coinShortName.toUpperCase()}USDT", interval: interval, familyCoin: widget.coinData.coinPairWith, rate: widget.inrRate).then(
              (value) => setState(() {
            this.interval = interval;
            nextIndex = value.length;
            // candles = value;
            for(int i=0;i<value.length;i++){

              dataKline.add(KLineEntity.fromCustom(
                  time: value[i].date.millisecondsSinceEpoch,
                  amount: value[i].high * widget.inrRate,
                  change: value[i].volume,
                  close: value[i].close * widget.inrRate,
                  high: value[i].high * widget.inrRate,
                  low: value[i].low * widget.inrRate,
                  open: value[i].open * widget.inrRate,
                  vol: value[i].volume,
                  ratio: value[i].low * widget.inrRate));


              /// candlesticks
              candles.add(Candle(
                date: value[i].date,
                high: double.parse(value[i].high.toString()) * widget.inrRate,
                low: double.parse(value[i].low.toString()) * widget.inrRate,
                open: double.parse(value[i].open.toString()) * widget.inrRate,
                close: double.parse(value[i].close.toString()) * widget.inrRate,
                volume: double.parse(value[i].volume.toString()),
              ));
              ///

            }
          },
          ),
        )
            : fetchListedCoinsCandles(symbol: "${widget.coinData.coinShortName.toUpperCase()}USDT", interval: interval, familyCoin: widget.coinData.coinPairWith, rate: widget.inrRate).then(
              (value) => setState(() {
            this.interval = interval;
            nextIndex = value.length;
            // candles = value;
            for(int i=0;i<value.length;i++){

              dataKline.add(KLineEntity.fromCustom(
                  time: value[i].date.millisecondsSinceEpoch,
                  amount: value[i].high * widget.inrRate,
                  change: value[i].volume,
                  close: value[i].close * widget.inrRate,
                  high: value[i].high * widget.inrRate,
                  low: value[i].low * widget.inrRate,
                  open: value[i].open * widget.inrRate,
                  vol: value[i].volume,
                  ratio: value[i].low * widget.inrRate));


              /// candlesticks
              candles.add(Candle(
                date: value[i].date,
                high: double.parse(value[i].high.toString()) * widget.inrRate,
                low: double.parse(value[i].low.toString()) * widget.inrRate,
                open: double.parse(value[i].open.toString()) * widget.inrRate,
                close: double.parse(value[i].close.toString()) * widget.inrRate,
                volume: double.parse(value[i].volume.toString()),
              ));
              ///

            }
          },
          ),
        );
        // if (_channels != null)
        _channels.sink.close();
        _channels = IOWebSocketChannel.connect(Uri.parse('wss://stream.binance.com:9443/ws'),);
        _channels.sink.add(
          jsonEncode(
            {
              "method": "SUBSCRIBE",
              "params": ["${widget.coinData.coinShortName.toLowerCase()}usdt@kline_$interval"],
              "id": 1
            },
          ),
        );
      }
      catch (e) {
        failed = true;
      }
    }
    else {
      try {
        !widget.coinData.coinListed ? fetchCandles(symbol: widget.coinData.coinSymbol.toUpperCase(), interval: interval,familyCoin: widget.coinData.coinPairWith,rate: widget.inrRate).then(
              (value) => setState(() {
            this.interval = interval;
            // candles = value;
            for(int i=0;i<value.length;i++) {
              dataKline.add(KLineEntity.fromCustom(
                  time:value[i].date.millisecondsSinceEpoch,
                  amount: value[i].high,
                  change: value[i].volume,
                  close: value[i].close,
                  high: value[i].high,
                  low: value[i].low,
                  open: value[i].open,
                  vol: value[i].volume,
                  ratio: value[i].low));

              /// candlesticks
              candles.add(Candle(
                date: value[i].date,
                high: double.parse(value[i].high.toString()),
                low: double.parse(value[i].low.toString()),
                open: double.parse(value[i].open.toString()),
                close: double.parse(value[i].close.toString()),
                volume: double.parse(value[i].volume.toString()),
              ));
              ///

            }
          },
          ),
        )
            : fetchListedCoinsCandles(symbol: widget.coinData.coinSymbol.toUpperCase(), interval: interval, familyCoin: widget.coinData.coinPairWith,rate: widget.inrRate).then(
              (value) => setState(() {
            this.interval = interval;
            // candles = value;
            for(int i=0;i<value.length;i++) {
              dataKline.add(KLineEntity.fromCustom(
                  time:value[i].date.millisecondsSinceEpoch,
                  amount: value[i].high,
                  change: value[i].volume,
                  close: value[i].close,
                  high: value[i].high,
                  low: value[i].low,
                  open: value[i].open,
                  vol: value[i].volume,
                  ratio: value[i].low));

              /// candlesticks
              candles.add(Candle(
                date: value[i].date,
                high: double.parse(value[i].high.toString()),
                low: double.parse(value[i].low.toString()),
                open: double.parse(value[i].open.toString()),
                close: double.parse(value[i].close.toString()),
                volume: double.parse(value[i].volume.toString()),
              ));
              ///

            }
          },
          ),
        );
        // if (_channels != null)
        _channels.sink.close();
        _channels = WebSocketChannel.connect(Uri.parse('wss://stream.binance.com:9443/ws'),);
        _channels.sink.add(
          jsonEncode(
            {
              "method": "SUBSCRIBE",
              "params": ["${widget.coinData.coinSymbol.toLowerCase()}@kline_$interval"],
              "id": 1
            },
          ),
        );
      }
      catch (e) {
        failed = true;
      }
    }
  }

  void disConnectFromServer() {
    // channel_home.sink.close();
    _channels.sink.close();
  }

  @override
  void dispose() {
    disConnectFromServer();
    super.dispose();
  }

  @override
  void initState() {
    binanceFetchCandle('1m');

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return StreamBuilder(
        stream: _channels.stream,
        builder: (context, snapshot) {
          candles.isNotEmpty ? updateCandlesFromSnapshot(snapshot) : null;
          return Container(
            // height: widget.chartHeight,
            color: Colors.green,
            margin: EdgeInsets.symmetric(horizontal: width * 0.02,),
            child:
            KChartWidget(
              dataKline,
              chartStyle,
              chartColors,
              isLine: isCandle,
              onSecondaryTap: () {},
              isTrendLine: false,
              mainState: MainState.NONE,
              volHidden: showVolume,
              fixedLength: 2,
              timeFormat: TimeFormat.YEAR_MONTH_DAY,
              showNowPrice: true,
              hideGrid: showGrid,
              isTapShowInfoDialog: false,
              materialInfoDialog: true,
              showInfoDialog: true,
              // maDayList: [1, 100, 1000],
              flingCurve: Curves.bounceInOut,
            ),


            // Container(
            //   margin: EdgeInsets.only(bottom: height * 0.1),
            //   child: Candlesticks(
            //     candles: candles.reversed.toList(),
            //     key: Key(widget.coinData.coinSymbol + interval),
            //     indicators: indicators,
            //     // onLoadMoreCandles: loadMoreCandles,
            //     showVolume: true,
            //     onRemoveIndicator: (String indicator) {
            //       setState(() {
            //         indicators = [...indicators];
            //         indicators
            //             .removeWhere((element) => element.name == indicator);
            //       });
            //     },
            //     actions: [
            //       ToolBarAction(
            //         onPressed: () {
            //           showDialog(
            //             context: context,
            //             builder: (context) {
            //               return Center(
            //                 child: Container(
            //                   width: 200,
            //                   color: Theme.of(context).backgroundColor,
            //                   child: Wrap(
            //                     children: intervalsList
            //                         .map((e) => Padding(
            //                       padding: const EdgeInsets.all(8.0),
            //                       child: SizedBox(
            //                         width: 50,
            //                         height: 30,
            //                         child: RawMaterialButton(
            //                           elevation: 0,
            //                           fillColor:
            //                           const Color(0xFF494537),
            //                           onPressed: () {
            //                             binanceFetchCandle(e);
            //                             Navigator.of(context).pop();
            //                           },
            //                           child: Text(
            //                             e,
            //                             style: const TextStyle(
            //                               color: Color(0xFFF0B90A),
            //                             ),
            //                           ),
            //                         ),
            //                       ),
            //                     )).toList(),
            //                   ),
            //                 ),
            //               );
            //             },
            //           );
            //         },
            //         child: Text(
            //           interval,
            //         ),
            //       ),
            //       // ToolBarAction(
            //       //   width: 100,
            //       //   onPressed: () {
            //       //     showDialog(
            //       //       context: context,
            //       //       builder: (context) {
            //       //         return SymbolsSearchModal(
            //       //           symbols: symbols,
            //       //           onSelect: (value) {
            //       //             fetchCandles(value, currentInterval);
            //       //           },
            //       //         );
            //       //       },
            //       //     );
            //       //   },
            //       //   child: Text(
            //       //     currentSymbol,
            //       //   ),
            //       // )
            //     ],
            //     // onLoadMoreCandles: () async {
            //     //   candles.addAll(candles.sublist(0, 100));
            //     // },
            //   ),
            // ),

          );
        },
      );
  }

}
