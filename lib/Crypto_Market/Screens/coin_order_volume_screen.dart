import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

import '../Model/coin_model.dart';
import '../Model/coin_order_volume_model.dart';

class CoinOrderVolumeScreen extends StatefulWidget {

  final Coin coinData;
  final String listedCoinOrderBookUrl;
  final double inrRate;

  const CoinOrderVolumeScreen({
    Key? key,
    required this.coinData,
    this.listedCoinOrderBookUrl = '',
    required this.inrRate,
  }) : super(key: key);

  @override
  State<CoinOrderVolumeScreen> createState() => _CoinOrderVolumeScreenState();
}

class _CoinOrderVolumeScreenState extends State<CoinOrderVolumeScreen> {


  getListedCoinOrderVolume() async {
    String url = widget.listedCoinOrderBookUrl;

    var response = await http.get(Uri.parse(url));
    var data = json.decode(response.body);

    dev.log('trade data ==>>  ${data['data']}');

    List<double> buys=[];
    List<double> asks=[];

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

      /// new
      for (int i = 0; i < data['data']['asks'].length; i++) {
        sellLargeValue = buys.isNotEmpty ? buys.reduce(max) > asks.reduce(max) ? buys.reduce(max) : asks.reduce(max) : 1.00;

        coinOrderVolumeSellList.insert(i, OrderVolume(
          number: i.toString(),
          price: double.parse(data['data']['asks'][i][0].toString()).toString(),
          value: double.parse(data['data']['asks'][i][1].toString()).toString(),
          percent: (double.parse(data['data']['asks'][i][1].toString()) / sellLargeValue).toString(),
        ));

      }
      ///

    }

    setState(() {});

  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      widget.coinData.coinListed ? await getListedCoinOrderVolume() : connectToServer();
    });
    super.initState();
  }


  WebSocketChannel channelHome = IOWebSocketChannel.connect(Uri.parse('wss://stream.binance.com:9443/ws/stream?'),);

  Future<void> connectToServer() async {
    String jsonString;
    if(widget.coinData.coinPairWith == "INR"){
      jsonString= json.encode({
        'method': "SUBSCRIBE",
        'params': [
          '${widget.coinData.coinShortName.toLowerCase()}usdt@depth20@1000ms',
        ],
        'id': 3,
      });
    }
    else {
      jsonString = json.encode({
        'method': "SUBSCRIBE",
        'params': [
          '${widget.coinData.coinSymbol.toLowerCase()}@depth20@1000ms',
        ],
        'id': 3,
      });
    }

    channelHome.sink.add(jsonString);

  }

  @override
  void dispose() {
    coinOrderVolumeBuyList = [];
    coinOrderVolumeSellList = [];
    channelHome.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    double mediaQuery = MediaQuery.of(context).size.width / 2.2;
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height * 0.02,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 9),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      "Volume",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText2!.color,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Text(
                    "Price",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText2!.color,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Text(
                      "Volume",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText2!.color,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: height * 0.02),
          widget.coinData.coinListed
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: mediaQuery,
                child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: coinOrderVolumeBuyList.length < 20 ? coinOrderVolumeBuyList.length : 20,
                  itemBuilder: (BuildContext ctx, int i) {
                    return _buyAmount(mediaQuery, coinOrderVolumeBuyList[i]);
                  },
                ),
              ),
              const SizedBox(width: 5,),
              SizedBox(
                width: mediaQuery,
                child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: coinOrderVolumeSellList.length < 20 ? coinOrderVolumeSellList.length : 20,
                  itemBuilder: (BuildContext ctx, int i) {
                    return _amountSell(mediaQuery, coinOrderVolumeSellList[i]);
                  },
                ),
              ),
            ],)
              : StreamBuilder(
              stream: channelHome.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(),);
                }
                else if(snapshot.connectionState == ConnectionState.waiting){
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: mediaQuery,
                        child: ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: coinOrderVolumeBuyList.length,
                          itemBuilder: (BuildContext ctx, int i) {
                            return _buyAmount(mediaQuery, coinOrderVolumeBuyList[i]);
                          },
                        ),
                      ),
                      const SizedBox(width: 5,),
                      SizedBox(
                        //height: 300.0,
                        width: mediaQuery,
                        child: ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: coinOrderVolumeSellList.length,
                          itemBuilder: (BuildContext ctx, int i) {
                            return _amountSell(mediaQuery, coinOrderVolumeSellList[i]);
                          },
                        ),
                      ),
                    ],);
                }
                else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                else if (snapshot.connectionState == ConnectionState.active && !snapshot.data.toString().contains("result")) {
                  var item = json.decode(snapshot.data as String);
                  List<double> buys=[];
                  List<double> asks=[];

                  if(item['bids'].length > 0) {
                    double largeValue = 0.0;

                    for (int i = 0; i < item['bids'].length; i++) {
                      buys.add(double.parse(item['bids'][i][1]));
                      asks.add(double.parse(item['asks'][i][1]));
                      largeValue = buys.reduce(max) > asks.reduce(max) ? buys.reduce(max) : asks.reduce(max);

                      coinOrderVolumeBuyList.insert(i, OrderVolume(
                        number: i.toString(),
                        price: double.parse(item['bids'][i][0]).toString(),
                        value: double.parse(item['bids'][i][1].toString()).toString(),
                        percent: (double.parse(item['bids'][i][1].toString()) / largeValue).toString(),
                      ));

                      coinOrderVolumeSellList.insert(i, OrderVolume(
                        number: i.toString(),
                        price: double.parse(item['asks'][i][0]).toString(),
                        value: double.parse(item['asks'][i][1].toString()).toString(),
                        percent: (double.parse(item['asks'][i][1].toString()) / largeValue).toString(),
                      ));

                    }
                    return  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: mediaQuery,
                          child: ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: coinOrderVolumeBuyList.length < 20 ? coinOrderVolumeBuyList.length : 20,
                            itemBuilder: (BuildContext ctx, int i) {
                              return _buyAmount(mediaQuery, coinOrderVolumeBuyList[i]);
                            },
                          ),
                        ),
                        const SizedBox(width: 5,),
                        SizedBox(
                          width: mediaQuery,
                          child: ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: coinOrderVolumeSellList.length < 20 ? coinOrderVolumeSellList.length : 20,
                            itemBuilder: (BuildContext ctx, int i) {
                              return _amountSell(mediaQuery, coinOrderVolumeSellList[i]);
                            },
                          ),
                        ),
                      ],);
                  }
                  else {
                    return const Center(child: CircularProgressIndicator(),);
                  }
                }
                return const Center(child: CircularProgressIndicator(),);
              })
        ]);
  }

  Widget _buyAmount(double width, OrderVolume item) {
    double price = double.parse(item.price.isNotEmpty ? item.price : '0.0') * widget.inrRate;

    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            color: Colors.green.withOpacity(0.2),
            width: width * double.parse(item.percent.isNotEmpty ? item.percent : '0.0'), // here you can define your percentage of progress, 0.2 = 20%, 0.3 = 30 % .....
            height: 25,
          ),
        ),
        SizedBox(
          width: width,
          height: 25,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text(
                item.value.toString(),
                style: TextStyle(fontSize: 12.0,
                  color: Theme.of(context).textTheme.bodyText1!.color),
              ),
              Text(
                widget.coinData.coinPairWith == "INR"
                    ? price.toStringAsFixed(int.parse(widget.coinData.coinDecimalCurrency))
                    : double.parse(item.price).toStringAsFixed(int.parse(widget.coinData.coinDecimalCurrency)),
                style: TextStyle(
                    color: Colors.green[600],
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0),
              ),
            ],),
        ),

      ],
    );
  }

  Widget _amountSell(double width, OrderVolume item) {
    double price = double.parse(item.price.isNotEmpty ? item.price : '0.0') * widget.inrRate;

    return Stack(
      children: <Widget>[
        SizedBox(
          width: width,
          height: 25,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.coinData.coinPairWith == "INR"
                    ? price.toStringAsFixed(int.parse(widget.coinData.coinDecimalCurrency))
                    : double.parse(item.price).toStringAsFixed(int.parse(widget.coinData.coinDecimalCurrency)),
                style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0),
              ),
              Text(
                item.value.toString(),
                style: TextStyle(
                    fontSize: 12.0,
                    color: Theme.of(context).textTheme.bodyText1!.color),
              ),

            ],),
        ),
        Container(
          color: Colors.redAccent.withOpacity(0.2),
          width: width * double.parse(item.percent.isNotEmpty ? item.percent : '1.0'), // here you can define your percentage of progress, 0.2 = 20%, 0.3 = 30 % .....
          height: 25,
        ),
      ],
    );
  }

}
