import 'package:flutter/material.dart';

import '../Model/coin_model.dart';

Widget coinCard({
  required BuildContext context,
  required Coin coin,
  required double inrRate,
  final Function(BuildContext, Coin)? onTap,
}) {
  double oldPrice = coin.lastPrice.isEmpty
      ? double.parse(coin.price)
      : double.parse(coin.lastPrice);
  coin.lastPrice = coin.price;

  final height = MediaQuery.of(context).size.height;
  final width = MediaQuery.of(context).size.width;
  return Column(
    children: [
      InkWell(
        onTap: () {
          onTap;
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: height * 0.003),
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.04, vertical: height * 0.014),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.network(
                    coin.image,
                    height: width * 0.085,
                    width: width * 0.085,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: width * 0.083,
                      width: width * 0.083,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.grey.shade400, width: 1)),
                      child: Center(
                        child: Text(coin.name.isEmpty ? '-' : coin.name[0]),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.014,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width * 0.24,
                        child: Row(
                          children: [
                            Text(
                              "${coin.shortName} / ",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              coin.pairWith,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.005,
                      ),
                      Text(
                        coin.name,
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: width * 0.22,
                child: Text(
                  coin.pairWith.toLowerCase() == 'inr'
                      ? (double.parse(coin.price.toString()) * inrRate)
                          .toStringAsFixed(coin.decimalCurrency)
                      : double.parse(coin.price.toString())
                          .toStringAsFixed(coin.decimalCurrency),
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 12,
                    color: double.parse(coin.price) > oldPrice
                        ? Colors.lightGreen
                        : double.parse(coin.price) < oldPrice
                            ? Colors.red
                            : null,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                width: width * 0.16,
                height: height * 0.025,
                decoration: BoxDecoration(
                  color: coin.percentage.toString().startsWith('-')
                      ? Colors.red
                      : Colors.lightGreen,
                  borderRadius: BorderRadius.circular(0),
                ),
                padding: const EdgeInsets.all(2),
                child: Center(
                  child: FittedBox(
                    child: Text(
                      '${coin.percentage}%',
                      style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
