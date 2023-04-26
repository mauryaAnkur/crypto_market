import 'package:crypto_market/Crypto_Market/Model/coin_model.dart';
import 'package:flutter/material.dart';

import '../GetX/coin_chart_getx.dart';

Widget intervalButton({
  required Coin coinData,
  required String title,
  required Color? intervalSelectedTextColor,
  required Color? intervalUnselectedTextColor,
  required double? intervalTextSize,
}) {
  return Padding(
    padding: const EdgeInsets.only(right: 3),
    child: InkWell(
      onTap: () async {
        await ChartController.to.getCandles(
          coinData: coinData,
          interval: title,
        );
        ChartController.to.interval = title;
      },
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Text(
          title,
          style: TextStyle(
            color: title == ChartController.to.interval
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
