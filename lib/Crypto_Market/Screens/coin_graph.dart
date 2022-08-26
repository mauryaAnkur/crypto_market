import 'package:crypto_market/Crypto_Market/GetX/coin_graph_getx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k_chart/chart_style.dart';

import 'package:k_chart/k_chart_widget.dart';

import '../Model/coin_model.dart';

class CoinGraph extends StatelessWidget {

  final Coin coinData;
  final String listedCoinGraphUrl;
  final double inrRate;
  final Color backgroundColor;
  final bool isLine;
  final bool hideGrid;
  final bool hideVolume;
  final bool showNowPrice;
  final bool isTrendLine;
  final bool isTapShowInfoDialog;
  final bool materialInfoDialog;
  final bool showInfoDialog;

  CoinGraph({
    Key? key,
    required this.coinData,
    required this.listedCoinGraphUrl,
    required this.inrRate,
    this.backgroundColor = const Color(0xff18191d),
    this.isLine = false,
    this.hideGrid = false,
    this.hideVolume = false,
    this.showNowPrice = true,
    this.isTrendLine = false,
    this.isTapShowInfoDialog = true,
    this.materialInfoDialog = true,
    this.showInfoDialog = true,
  }) : super(key: key);

  final ChartStyle chartStyle = ChartStyle();
  final ChartColors chartColors = ChartColors();

  final List intervalsList = [
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

  @override
  Widget build(BuildContext context) {

    CoinGraphController.to.getCandles(coinData: coinData, interval: '1m', listedCoinGraphUrl: listedCoinGraphUrl);
    CoinGraphController.to.inrRate = inrRate;

    return GetBuilder<CoinGraphController>(
        builder: (_) {
          return Container(
            color: backgroundColor,
            child: KChartWidget(
              CoinGraphController.to.kChartCandles,
              chartStyle,
              chartColors,
              isLine: isLine,
              onSecondaryTap: () {},
              mainState: MainState.NONE,
              volHidden: hideVolume,
              fixedLength: 2,
              timeFormat: TimeFormat.YEAR_MONTH_DAY,
              hideGrid: hideGrid,
              showNowPrice: showNowPrice,
              isTrendLine: isTrendLine,
              isTapShowInfoDialog: isTapShowInfoDialog,
              materialInfoDialog: materialInfoDialog,
              showInfoDialog: showInfoDialog,
              flingCurve: Curves.bounceInOut,
            ),
          );
        },
    );
  }
}
