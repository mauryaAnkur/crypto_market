import 'package:crypto_market/Crypto_Market/GetX/coin_graph_getx.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/coin_model.dart';
import '../Widgets/interval_button.dart';

class CoinLineChart extends StatelessWidget {
  final Coin coinData;
  final double inrRate;
  final Gradient? chartColor;
  final Color? chartBorderColor;
  final Color? toolTipBgColor;
  final Color? toolTipTextColor;
  final Color? intervalSelectedTextColor;
  final Color? intervalUnselectedTextColor;
  final double? intervalTextSize;
  final MainAxisAlignment? intervalAlignment;

  const CoinLineChart({
    Key? key,
    required this.coinData,
    required this.inrRate,
    this.chartColor,
    this.chartBorderColor,
    this.toolTipBgColor,
    this.toolTipTextColor,
    this.intervalSelectedTextColor,
    this.intervalUnselectedTextColor,
    this.intervalTextSize,
    this.intervalAlignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CoinGraphController.to.inrRate = inrRate;
    CoinGraphController.to.getCandles(
      coinData: coinData,
      interval: '1h',
    );
    return Scaffold(
      body: GetBuilder<CoinGraphController>(
        builder: (chartController) {
          return Column(
            children: [
              Flexible(
                child: SizedBox(
                  child: chartController.lineChart.isEmpty
                      ? const CupertinoActivityIndicator()
                      : LineChart(
                          LineChartData(
                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(show: false),
                            lineTouchData: LineTouchData(
                              enabled: true,
                              touchTooltipData: LineTouchTooltipData(
                                tooltipBgColor:
                                    toolTipBgColor ?? Colors.green.shade50,
                                tooltipRoundedRadius: 8,
                                fitInsideHorizontally: true,
                                getTooltipItems: (spots) => spots
                                    .map(
                                      (spot) => LineTooltipItem(
                                        '${coinData.pairWith.toUpperCase()} '
                                        '${spot.y.toStringAsFixed(2)}\n'
                                        '${DateTime.fromMicrosecondsSinceEpoch(spot.x.toInt() * 1000)}',
                                        TextStyle(
                                          color:
                                              toolTipTextColor ?? Colors.green,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: chartController.lineChart,
                                isCurved: true,
                                barWidth: 2,
                                color: chartBorderColor ?? Colors.green,
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: chartColor ??
                                      LinearGradient(
                                        colors: [
                                          Colors.green.withOpacity(0.8),
                                          Colors.green.withOpacity(0.4),
                                          Colors.green.withOpacity(0.0),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                ),
                                aboveBarData: BarAreaData(
                                  show: true,
                                  color: Colors.transparent,
                                  applyCutOffY: false,
                                ),
                                dotData: FlDotData(
                                  show: false,
                                ),
                              ),
                            ],
                            titlesData: FlTitlesData(show: false),
                          ),
                          swapAnimationDuration:
                              const Duration(milliseconds: 150),
                          swapAnimationCurve: Curves.linear,
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment:
                      intervalAlignment ?? MainAxisAlignment.spaceAround,
                  children: [
                    intervalButton(
                      title: '1m',
                      coinData: coinData,
                      intervalSelectedTextColor: intervalSelectedTextColor,
                      intervalUnselectedTextColor: intervalUnselectedTextColor,
                      intervalTextSize: intervalTextSize,
                    ),
                    intervalButton(
                      title: '1h',
                      coinData: coinData,
                      intervalSelectedTextColor: intervalSelectedTextColor,
                      intervalUnselectedTextColor: intervalUnselectedTextColor,
                      intervalTextSize: intervalTextSize,
                    ),
                    intervalButton(
                      title: '1d',
                      coinData: coinData,
                      intervalSelectedTextColor: intervalSelectedTextColor,
                      intervalUnselectedTextColor: intervalUnselectedTextColor,
                      intervalTextSize: intervalTextSize,
                    ),
                    intervalButton(
                      title: '1w',
                      coinData: coinData,
                      intervalSelectedTextColor: intervalSelectedTextColor,
                      intervalUnselectedTextColor: intervalUnselectedTextColor,
                      intervalTextSize: intervalTextSize,
                    ),
                    intervalButton(
                      title: '1M',
                      coinData: coinData,
                      intervalSelectedTextColor: intervalSelectedTextColor,
                      intervalUnselectedTextColor: intervalUnselectedTextColor,
                      intervalTextSize: intervalTextSize,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
