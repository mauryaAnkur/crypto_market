import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../GetX/coin_trade_history_getx.dart';
import '../Model/coin_model.dart';
import '../Model/coin_trade_history_model.dart';

class CoinTradeHistory extends StatelessWidget {
  final Coin coinData;
  final int itemCount;
  final double inrRate;

  const CoinTradeHistory({
    Key? key,
    required this.coinData,
    this.itemCount = 20,
    required this.inrRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TradeHistoryController.to.itemCount = itemCount;
    TradeHistoryController.to.connectToTradeHistory(coinData);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GetBuilder<TradeHistoryController>(builder: (_) {
      return SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.02,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: width * 0.18,
                    child: const Text(
                      "Time",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.13,
                    child: const Text(
                      "Type",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.26,
                    child: const Text(
                      "Price",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.26,
                    child: const Text(
                      "Amount",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  reverse: true,
                  itemCount: TradeHistoryController.to.tradeHistoryList.length,
                  itemBuilder: (BuildContext ctx, int i) {
                    return _itemCard(
                        context, TradeHistoryController.to.tradeHistoryList[i]);
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _itemCard(BuildContext context, TradeHistory item) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      color: item.type == 'Buy'
          ? Colors.green.withOpacity(0.1)
          : Colors.redAccent.withOpacity(0.1),
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.03, vertical: height * 0.012),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: width * 0.18,
            child: Text(
              item.date.toString().split('.')[0],
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
          ),
          SizedBox(
            width: width * 0.13,
            child: Text(
              item.type,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.0,
                color:
                    item.type == 'Buy' ? Colors.green[600] : Colors.redAccent,
              ),
            ),
          ),
          SizedBox(
            width: width * 0.3,
            child: Text(
              double.parse(item.price).toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color:
                    item.type == 'Buy' ? Colors.green[600] : Colors.redAccent,
                fontWeight: FontWeight.w600,
                fontSize: 12.0,
              ),
            ),
          ),
          SizedBox(
            width: width * 0.27,
            child: Text(
              double.parse(item.amount).toString(),
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}
