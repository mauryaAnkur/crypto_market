import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../GetX/coin_order_book_getx.dart';
import '../Model/coin_model.dart';

class OrderBook extends StatelessWidget {
  final Coin coinData;
  final double inrRate;
  final int itemCount;

  const OrderBook({
    Key? key,
    required this.coinData,
    required this.inrRate,
    this.itemCount = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OrderBookController.to.itemCount = itemCount;
    OrderBookController.to.getOrderBook(
      coinData: coinData,
    );

    final height = MediaQuery.of(context).size.height;
    double mediaQuery = MediaQuery.of(context).size.width / 2.2;
    return GetBuilder<OrderBookController>(builder: (_) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text(
                    "Volume",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                Text(
                  "Price",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Text(
                    "Volume",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.01),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: mediaQuery,
                  child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    reverse: true,
                    padding: EdgeInsets.zero,
                    itemCount:
                        OrderBookController.to.coinOrderBookBuyList.length <
                                itemCount
                            ? OrderBookController.to.coinOrderBookBuyList.length
                            : itemCount,
                    itemBuilder: (BuildContext ctx, int i) {
                      return _buyAmount(context, i, mediaQuery,
                          OrderBookController.to.coinOrderBookBuyList[i]);
                    },
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                SizedBox(
                  width: mediaQuery,
                  child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    reverse: true,
                    padding: EdgeInsets.zero,
                    itemCount: OrderBookController
                                .to.coinOrderBookSellList.length <
                            itemCount
                        ? OrderBookController.to.coinOrderBookSellList.length
                        : itemCount,
                    itemBuilder: (BuildContext ctx, int i) {
                      return _amountSell(context, i, mediaQuery,
                          OrderBookController.to.coinOrderBookSellList[i]);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buyAmount(BuildContext context, int index, double width, item) {
    // double price = double.parse(item.price.isNotEmpty ? item.price : '0.0') * inrRate;

    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            color: Colors.green.withOpacity(0.2),
            width: width / (index / 4) + Random().nextInt(10),
            height: 25,
          ),
        ),
        SizedBox(
          width: width,
          height: 25,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                child: SizedBox(
                  width: width * 0.48,
                  child: Text(
                    item.value.toString(),
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: SizedBox(
                  width: width * 0.48,
                  child: Text(
                    coinData.pairWith == "INR"
                        ? (double.parse(item.price.isNotEmpty
                                    ? item.price
                                    : '0.0') *
                                inrRate)
                            .toString()
                        : double.parse(item.price).toString(),
                    maxLines: 1,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Colors.green[600],
                        fontWeight: FontWeight.w600,
                        fontSize: 12.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _amountSell(BuildContext context, int index, double width, item) {
    double price =
        double.parse(item.price.isNotEmpty ? item.price : '0.0') * inrRate;

    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            color: Colors.red.withOpacity(0.2),
            width: width / (index / 4) + Random().nextInt(10),
            height: 25,
          ),
        ),
        SizedBox(
          width: width,
          height: 25,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                child: SizedBox(
                  width: width * 0.48,
                  child: Text(
                    coinData.pairWith == "INR"
                        ? price.toString()
                        : double.parse(item.price).toString(),
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.0),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: SizedBox(
                  width: width * 0.48,
                  child: Text(
                    item.value.toString(),
                    maxLines: 1,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Positioned.fill(
        //   child: Align(
        //     alignment: Alignment.centerLeft,
        //     child: AnimatedSize(
        //       duration: const Duration(milliseconds: 1600),
        //       reverseDuration: Duration(milliseconds: 1000),
        //       curve: Curves.easeIn,
        //       child: Container(
        //         color: Colors.redAccent.withOpacity(0.2),
        //         // width: width * double.parse(item.percent.isNotEmpty ? item.percent : '1.0'),
        //         width: width / (index / 4) + Random().nextInt(30),
        //         height: 25,
        //         alignment: Alignment.centerLeft,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
