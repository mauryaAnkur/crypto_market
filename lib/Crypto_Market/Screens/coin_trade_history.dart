
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

import '../GetX/coin_trade_history_getx.dart';
import '../Model/coin_model.dart';
import '../Model/coin_trade_history_model.dart';

class CoinTradeHistory extends StatefulWidget {

  final Coin coinData;
  final String listedCoinTradeHistoryAPIUrl;
  final int itemCount;
  final double inrRate;

  const CoinTradeHistory({
    Key? key,
    required this.coinData,
    this.listedCoinTradeHistoryAPIUrl = '',
    this.itemCount = 20,
    required this.inrRate,
  }) : super(key: key);

  @override
  State<CoinTradeHistory> createState() => _CoinTradeHistoryState();
}

class _CoinTradeHistoryState extends State<CoinTradeHistory> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    TradeHistoryController.to.connectToTradeHistory(widget.coinData);
    TradeHistoryController.to.itemCount = widget.itemCount;
    widget.coinData.coinListed ? getListedCoinTradeHistory() : connectToServer();
    super.initState();
  }

  getListedCoinTradeHistory() async {
    String url = widget.listedCoinTradeHistoryAPIUrl;

    var response = await http.get(Uri.parse(url));
    var data = json.decode(response.body);

    for(var i=0; i<data['data'].length; i++) {
      tradeHistoryList.add(TradeHistory(
          date: data['data'][i]['T'] == null ? "" : DateTime.fromMillisecondsSinceEpoch(int.parse(data['data'][i]['T'].toString())).toString().split(' ')[1],
          type: data['data'][i]['m'] == true ? "Buy" : "Sell",
          price: data['data'][i]['p'] == null ? "" : double.parse(data['data'][i]['p'].toString()).toString(),
          amount:  data['data'][i]['q'] == null ? "" : data['data'][i]['q'].toString()));
    }
    setState(() {});
  }

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }


  WebSocketChannel channelHome = IOWebSocketChannel.connect(Uri.parse('wss://stream.binance.com:9443/ws/stream?'),);


  Future<void> connectToServer() async {
    String jsonString;

    if(widget.coinData.coinPairWith.toUpperCase() == "INR") {
      jsonString= json.encode({
        'method': "SUBSCRIBE",
        'params': [
          '${widget.coinData.coinShortName.toLowerCase()}usdt@trade',
        ],
        'id': 3,
      });
    }
    else {
      jsonString = json.encode({
        'method': "SUBSCRIBE",
        'params': [
          '${widget.coinData.coinSymbol.toLowerCase()}@trade',
        ],
        'id': 3,
      });
    }
    channelHome.sink.add(jsonString);
  }


  @override
  void dispose() {
    channelHome.sink.close();
    tradeHistoryList.clear();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GetBuilder<TradeHistoryController>(
        builder: (_) {
          return  SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: height * 0.02,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: width * 0.18,
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        child: Text(
                          "Time",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText2!.color,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Container(
                        width: width * 0.13,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Type",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText2
                           !.color,
                            fontWeight: FontWeight.w600,
                            fontSize: 15
                          ),
                        ),
                      ),
                      Container(
                        width: width * 0.26,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Price",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText2!.color,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Container(
                        width: width * 0.26,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Amount",
                          textAlign: TextAlign.end,
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

                SizedBox(height: height * 0.01,),
                widget.coinData.coinListed ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    controller: _scrollController,
                    shrinkWrap: true,
                    primary: false,
                    // reverse: true,
                    itemCount: tradeHistoryList.length,
                    itemBuilder: (BuildContext ctx, int i) {
                      return _orderHistory(tradeHistoryList[i]);
                    }
                ) : StreamBuilder(
                    // stream: channelHome.stream,
                    builder: (context, snapshot) {
                      // if (snapshot.hasError) {
                      //   return Center(child: Text(snapshot.error.toString()));
                      // }
                      // else if (snapshot.connectionState == ConnectionState.active) {

                        // item = json.decode(snapshot.data as String);
                        //
                        // coinTradeHistoryList.add(CoinTradeHistory(
                        //     date: item['T'] == null ? "" : DateTime.fromMillisecondsSinceEpoch(item['T']).toString().split(' ')[1],
                        //     type: item['m'] == true ? "Buy" : "Sell",
                        //     price: item['p'] == null ? "" : double.parse(item['p'].toString()).toString(),
                        //     amount:  item['q'] == null ? "" : item['q'].toString()));
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: SizedBox(
                            // height: height * 0.74,
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  controller: _scrollController,
                                  shrinkWrap: true,
                                  primary: false,
                                  reverse: true,
                                  itemCount: TradeHistoryController.to.tradeHistoryList.length,
                                  // itemCount: coinTradeHistoryList.length < 10 ? coinTradeHistoryList.length : 10,
                                  itemBuilder: (BuildContext ctx, int i) {
                                    // return _orderHistory(coinTradeHistoryList[i]);
                                    return _orderHistory(TradeHistoryController.to.tradeHistoryList[i]);
                                  }
                              )),
                        );
                      // }
                      // else {
                      //   return const Center(child: CircularProgressIndicator());
                      // }
                    }),
              ],
            ),
          );
        }
    );
  }

  Widget _orderHistory(TradeHistory item) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollToBottom());
    return SingleChildScrollView(
        child: item.date != "" ? Container(
          color: Theme.of(context).brightness == Brightness.dark ? Colors.transparent : item.type == 'Buy' ? Colors.green.withOpacity(0.1) : Colors.redAccent.withOpacity(0.1),
          padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.01),
          child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: width * 0.18,
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  item.date.toString().split('.')[0],
                  // item.date == null ? "00:00:00" : item.date.toString().split('.')[0],
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      fontSize: 12.0),
                ),
              ),
              Container(
                width: width * 0.13,
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  item.type,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.0, color: item.type == 'Buy'? Colors.green[600] : Colors.redAccent),
                ),
              ),
              Container(
                width: width * 0.3,
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  item.price,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      // color: Theme.of(context).textTheme.bodyText1!.color,
                      color: item.type == 'Buy' ? Colors.green[600] : Colors.redAccent,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.0),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                width: width * 0.27,
                child: Text(
                  // item.amount.replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), ""),
                  double.parse(item.amount.toString()).toString(),
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.0),
                ),
              )
            ],
          ),
        ):
        Container()
    );
  }

}
