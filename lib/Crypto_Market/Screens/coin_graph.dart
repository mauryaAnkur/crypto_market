import 'package:crypto_market/Crypto_Market/GetX/coin_graph_getx.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k_chart/chart_style.dart';

import 'package:k_chart/k_chart_widget.dart';

import '../Model/coin_model.dart';

class CoinGraph extends StatelessWidget {
  final Coin coinData;
  final double inrRate;
  final Color backgroundColor;
  final Function()? onSecondaryTap;
  final bool isLine;
  final bool hideGrid;
  final bool hideVolume;
  final bool showNowPrice;
  final bool isTrendLine;
  final bool isTapShowInfoDialog;
  final bool materialInfoDialog;
  final bool showInfoDialog;
  final Color? intervalSelectedTextColor;
  final Color? intervalUnselectedTextColor;
  final double? intervalTextSize;

  CoinGraph(
      {Key? key,
      required this.coinData,
      required this.inrRate,
      this.backgroundColor = const Color(0xff18191d),
      this.onSecondaryTap,
      this.isLine = false,
      this.hideGrid = false,
      this.hideVolume = false,
      this.showNowPrice = true,
      this.isTrendLine = false,
      this.isTapShowInfoDialog = true,
      this.materialInfoDialog = true,
      this.showInfoDialog = true,
      this.intervalSelectedTextColor,
      this.intervalUnselectedTextColor,
      this.intervalTextSize})
      : super(key: key);

  final ChartStyle chartStyle = ChartStyle();
  final ChartColors chartColors = ChartColors();

  @override
  Widget build(BuildContext context) {
    CoinGraphController.to.getCandles(
      coinData: coinData,
      interval: '1m',
    );
    CoinGraphController.to.inrRate = inrRate;

    return GetBuilder<CoinGraphController>(
      builder: (_) {
        return Column(
          children: [
            CoinGraphController.to.kChartCandles.isEmpty
                ? const Center(
                    child: CupertinoActivityIndicator(),
                  )
                : Flexible(
                    child: Container(
                      color: backgroundColor,
                      child: KChartWidget(
                        CoinGraphController.to.kChartCandles,
                        chartStyle,
                        chartColors,
                        isLine: isLine,
                        onSecondaryTap: onSecondaryTap,
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
                    ),
                  ),
            Row(
              children: [
                _interValButton(
                  title: '1m',
                ),
                _interValButton(
                  title: '1h',
                ),
                _interValButton(
                  title: '1d',
                ),
                _interValButton(
                  title: '1w',
                ),
                _interValButton(
                  title: '1M',
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _interValButton({
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 3),
      child: InkWell(
        onTap: () async {
          await CoinGraphController.to.getCandles(
            coinData: coinData,
            interval: title,
          );
          CoinGraphController.to.interval = title;
        },
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Text(
            title,
            style: TextStyle(
              color: title == CoinGraphController.to.interval
                  ? intervalSelectedTextColor ?? Colors.green
                  : intervalUnselectedTextColor ?? Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: intervalTextSize ?? 10,
            ),
          ),
        ),
      ),
    );
  }
}
