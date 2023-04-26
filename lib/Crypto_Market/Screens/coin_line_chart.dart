import 'package:crypto_market/Crypto_Market/GetX/coin_chart_getx.dart';
import 'package:fl_chart/fl_chart.dart' as chart;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/coin_model.dart';
import '../Widgets/interval_button.dart';

class LineChart extends StatelessWidget {
  final Coin coinData;
  final double inrRate;
  final Gradient? chartColor;
  final Color? chartBorderColor;
  final Color? toolTipBgColor;
  final Color? toolTipTextColor;
  final bool? showToolTip;
  final bool? showInterval;
  final Color? intervalSelectedTextColor;
  final Color? intervalUnselectedTextColor;
  final double? intervalTextSize;
  final MainAxisAlignment? intervalAlignment;

  const LineChart({
    Key? key,
    required this.coinData,
    required this.inrRate,
    this.chartColor,
    this.chartBorderColor,
    this.toolTipBgColor,
    this.toolTipTextColor,
    this.showToolTip,
    this.showInterval,
    this.intervalSelectedTextColor,
    this.intervalUnselectedTextColor,
    this.intervalTextSize,
    this.intervalAlignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChartController.to.inrRate = inrRate;
    ChartController.to.getCandles(
      coinData: coinData,
      interval: '1h',
    );
    return Scaffold(
      body: GetBuilder<ChartController>(
        builder: (chartController) {
          return Column(
            children: [
              Flexible(
                child: SizedBox(
                  child: chartController.lineChart.isEmpty
                      ? const CupertinoActivityIndicator()
                      : chart.LineChart(
                          chart.LineChartData(
                            borderData: chart.FlBorderData(show: false),
                            gridData: chart.FlGridData(show: false),
                            lineTouchData: chart.LineTouchData(
                              enabled: showToolTip ?? true,
                              touchTooltipData: chart.LineTouchTooltipData(
                                tooltipBgColor:
                                    toolTipBgColor ?? Colors.green.shade50,
                                tooltipRoundedRadius: 8,
                                fitInsideHorizontally: true,
                                getTooltipItems: (spots) => spots
                                    .map(
                                      (spot) => chart.LineTooltipItem(
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
                              chart.LineChartBarData(
                                spots: chartController.lineChart,
                                isCurved: true,
                                barWidth: 2,
                                color: chartBorderColor ?? Colors.green,
                                belowBarData: chart.BarAreaData(
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
                                aboveBarData: chart.BarAreaData(
                                  show: true,
                                  color: Colors.transparent,
                                  applyCutOffY: false,
                                ),
                                dotData: chart.FlDotData(
                                  show: false,
                                ),
                              ),
                            ],
                            titlesData: chart.FlTitlesData(show: false),
                          ),
                          swapAnimationDuration:
                              const Duration(milliseconds: 150),
                          swapAnimationCurve: Curves.linear,
                        ),
                ),
              ),
              Visibility(
                visible: showInterval ?? true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment:
                        intervalAlignment ?? MainAxisAlignment.spaceAround,
                    children: [
                      intervalButton(
                        title: '1m',
                        coinData: coinData,
                        intervalSelectedTextColor: intervalSelectedTextColor,
                        intervalUnselectedTextColor:
                            intervalUnselectedTextColor,
                        intervalTextSize: intervalTextSize,
                      ),
                      intervalButton(
                        title: '1h',
                        coinData: coinData,
                        intervalSelectedTextColor: intervalSelectedTextColor,
                        intervalUnselectedTextColor:
                            intervalUnselectedTextColor,
                        intervalTextSize: intervalTextSize,
                      ),
                      intervalButton(
                        title: '1d',
                        coinData: coinData,
                        intervalSelectedTextColor: intervalSelectedTextColor,
                        intervalUnselectedTextColor:
                            intervalUnselectedTextColor,
                        intervalTextSize: intervalTextSize,
                      ),
                      intervalButton(
                        title: '1w',
                        coinData: coinData,
                        intervalSelectedTextColor: intervalSelectedTextColor,
                        intervalUnselectedTextColor:
                            intervalUnselectedTextColor,
                        intervalTextSize: intervalTextSize,
                      ),
                      intervalButton(
                        title: '1M',
                        coinData: coinData,
                        intervalSelectedTextColor: intervalSelectedTextColor,
                        intervalUnselectedTextColor:
                            intervalUnselectedTextColor,
                        intervalTextSize: intervalTextSize,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
