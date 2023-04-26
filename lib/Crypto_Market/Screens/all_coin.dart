import 'package:crypto_market/Crypto_Market/Widgets/coin_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../GetX/all_coin_getx.dart';
import '../Model/coin_model.dart';

class AllCoin extends StatelessWidget {
  final List<Coin> coinsList;
  final List<String> currencyList;
  final List<String> tickerList;
  final double inrRate;

  /// wishlist
  final List<Coin> wishlistCoinsList;
  final Widget? onWishlistError;

  ///
  final bool showWishlistAtFirst;

  /// currency tab
  final double? currencyTabHeight;
  final double? currencyTabWidth;
  final BoxDecoration? currencyTabBackgroundDecoration;
  final BorderRadius? currencyTabItemBorderRadius;
  final Color? currencyTabBackgroundColor;
  final Color? currencyTabItemColor;
  final Color? currencyTabSelectedItemColor;
  final Color? currencyTabTextColor;
  final Color? currencyTabSelectedTextColor;
  final double? currencyTabFontSize;

  /// heading
  final bool showHeading;
  final TextStyle? headingTextStyle;

  /// coins list
  final BorderRadius? cardPercentageBorder;
  final double? cardPercentageHeight;
  final double? cardPercentageWidth;
  final Widget Function(Coin)? coinCardWidget;
  final Function(BuildContext, Coin)? onCoinTap;

  AllCoin({
    Key? key,
    required this.coinsList,
    required this.currencyList,
    required this.tickerList,
    required this.inrRate,
    required this.wishlistCoinsList,
    this.onWishlistError = const Center(
      child: Text(
        'Empty wishlist...',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    this.showWishlistAtFirst = true,
    this.currencyTabHeight,
    this.currencyTabWidth,
    this.currencyTabBackgroundDecoration,
    this.currencyTabItemBorderRadius,
    this.currencyTabBackgroundColor,
    this.currencyTabItemColor,
    this.currencyTabSelectedItemColor,
    this.currencyTabTextColor,
    this.currencyTabSelectedTextColor,
    this.currencyTabFontSize = 13,
    this.showHeading = true,
    this.headingTextStyle,
    this.cardPercentageBorder,
    this.cardPercentageHeight,
    this.cardPercentageWidth,
    this.coinCardWidget,
    this.onCoinTap,
  }) : super(key: key);

  late final List tabItems = [];

  tabItemsList() {
    tabItems.addAll(currencyList);
    tabItems.insert(showWishlistAtFirst ? 0 : tabItems.length, 'Wishlist');
  }

  @override
  Widget build(BuildContext context) {
    CoinController.to.selectedTabIndex = showWishlistAtFirst ? 1 : 0;
    CoinController.to.getCoins(coinsList, wishlistCoinsList, tickerList);
    CoinController.to
        .getSelectCurrencyList(currencyList.elementAt(0).toString());
    tabItemsList();

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GetBuilder<CoinController>(
      builder: (coinController) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: currencyTabBackgroundDecoration ??
                      BoxDecoration(
                        color:
                            currencyTabBackgroundColor ?? Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                  margin: EdgeInsets.symmetric(horizontal: width * 0.04),
                  child: SizedBox(
                    height: height * 0.05,
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        itemCount: tabItems.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) =>
                            currencyNameCard(index, context)),
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                // isP2PSelected ? SizedBox() :
                !showHeading
                    ? const SizedBox()
                    : Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.04, vertical: height * 0.01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                CoinController.to.selectedCurrencyCoins
                                    .sort((a, b) {
                                  return a.name
                                      .toLowerCase()
                                      .compareTo(b.name.toLowerCase());
                                });
                                //sortList = false;
                              },
                              child: SizedBox(
                                  width: width * 0.38,
                                  child: Text(
                                    'Coin Name',
                                    textAlign: TextAlign.start,
                                    style: headingTextStyle ??
                                        const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  )),
                            ),
                            GestureDetector(
                              onTap: () {
                                CoinController.to.selectedCurrencyCoins
                                    .sort((a, b) {
                                  return double.parse(a.price)
                                      .compareTo(double.parse(b.price));
                                });
                                //sortList = false;
                              },
                              child: SizedBox(
                                width: width * 0.22,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Price',
                                      textAlign: TextAlign.center,
                                      style: headingTextStyle ??
                                          const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const Icon(Icons.arrow_upward_sharp,
                                        size: 14)
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                                //width: width * 0.2,
                                child: Text(
                              '24H Change',
                              textAlign: TextAlign.center,
                              style: headingTextStyle ??
                                  const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                            )),
                          ],
                        ),
                      ),
                SingleChildScrollView(
                  child: SizedBox(
                    height: height * 0.7,
                    child: showWishlistAtFirst
                        ? coinController.selectedTabIndex == 0
                            ? wishlistCoinsList.isEmpty
                                ? onWishlistError
                                : coinsListView(
                                    CoinController.to.wishlistCoinsList)
                            : coinsListView(
                                CoinController.to.selectedCurrencyCoins)
                        : coinController.selectedTabIndex == tabItems.length - 1
                            ? wishlistCoinsList.isEmpty
                                ? onWishlistError
                                : coinsListView(
                                    CoinController.to.wishlistCoinsList)
                            : coinsListView(
                                CoinController.to.selectedCurrencyCoins),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget coinsListView(coinController) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: coinController.length,
        itemBuilder: (context, index) {
          return coinCardWidget != null
              ? coinCardWidget!(coinController[index])
              : coinCard(
                  context: context,
                  coin: coinController[index],
                  inrRate: inrRate,
                  onTap: onCoinTap!,
                );
        });
  }

  Widget currencyNameCard(int index, context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        CoinController.to
            .getSelectCurrencyList(tabItems.elementAt(index).toString());
        CoinController.to.selectedTabIndex = index;
      },
      child: Container(
        width: width * 0.16,
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: CoinController.to.selectedTabIndex == index
              ? currencyTabSelectedItemColor ?? Colors.blueAccent
              : currencyTabItemColor ?? Colors.blue.shade100,
          borderRadius: currencyTabItemBorderRadius ?? BorderRadius.circular(2),
        ),
        child: Center(
          child:
              tabItems.elementAt(index).toString().toLowerCase() == 'wishlist'
                  ? const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    )
                  : Text(
                      tabItems.elementAt(index).toString(),
                      style: TextStyle(
                        color: CoinController.to.selectedTabIndex == index
                            ? currencyTabSelectedTextColor ?? Colors.white
                            : currencyTabTextColor ?? Colors.black,
                        fontSize: currencyTabFontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
        ),
      ),
    );
  }
}
