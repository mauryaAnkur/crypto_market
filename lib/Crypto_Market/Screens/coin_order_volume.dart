import 'package:crypto_market/Crypto_Market/GetX/coin_order_volume_getx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/coin_model.dart';

class OrderVolume extends StatelessWidget {
  final Coin coinData;
  final String listedCoinOrderBookUrl;
  final double inrRate;

  const OrderVolume({
    Key? key,
    required this.coinData,
    this.listedCoinOrderBookUrl = '',
    required this.inrRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OrderVolumeController.to.getOrderVolume(coinData: coinData);

    final height = MediaQuery.of(context).size.height;
    double mediaQuery = MediaQuery.of(context).size.width / 2.2;
    return GetBuilder<OrderVolumeController>(builder: (_) {
      return Column(
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
                  padding: EdgeInsets.zero,
                  itemCount: OrderVolumeController
                              .to.coinOrderVolumeBuyList.length <
                          20
                      ? OrderVolumeController.to.coinOrderVolumeBuyList.length
                      : 20,
                  itemBuilder: (BuildContext ctx, int i) {
                    return _buyAmount(context, mediaQuery,
                        OrderVolumeController.to.coinOrderVolumeBuyList[i]);
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
                  padding: EdgeInsets.zero,
                  itemCount: OrderVolumeController
                              .to.coinOrderVolumeSellList.length <
                          20
                      ? OrderVolumeController.to.coinOrderVolumeSellList.length
                      : 20,
                  itemBuilder: (BuildContext ctx, int i) {
                    return _amountSell(context, mediaQuery,
                        OrderVolumeController.to.coinOrderVolumeSellList[i]);
                  },
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buyAmount(BuildContext context, double width, item) {
    double price =
        double.parse(item.price.isNotEmpty ? item.price : '0.0') * inrRate;

    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            color: Colors.green.withOpacity(0.2),
            width: width *
                double.parse(item.percent.isNotEmpty
                    ? item.percent
                    : '0.0'), // here you can define your percentage of progress, 0.2 = 20%, 0.3 = 30 % .....
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
                    coinData.coinPairWith == "INR"
                        ? price.toStringAsFixed(coinData.coinDecimalCurrency)
                        : double.parse(item.price)
                            .toStringAsFixed(coinData.coinDecimalCurrency),
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

  Widget _amountSell(BuildContext context, double width, item) {
    double price =
        double.parse(item.price.isNotEmpty ? item.price : '0.0') * inrRate;

    return Stack(
      children: <Widget>[
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
                    coinData.coinPairWith == "INR"
                        ? price.toStringAsFixed(coinData.coinDecimalCurrency)
                        : double.parse(item.price)
                            .toStringAsFixed(coinData.coinDecimalCurrency),
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
        Container(
          color: Colors.redAccent.withOpacity(0.2),
          width: width *
              double.parse(item.percent.isNotEmpty ? item.percent : '1.0'),
          height: 25,
        ),
      ],
    );
  }
}
