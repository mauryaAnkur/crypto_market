
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../GetX/all_coin_getx.dart';
import '../Model/coin_model.dart';

class AllCoin extends StatelessWidget {

  final List<Coin> coinsList;
  final List<String> currencyList;
  final List<String> tickerList;
  final double inrRate;

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
  final bool? showCoinImage;
  final BorderRadius? cardPercentageBorder;
  final double? cardPercentageHeight;
  final double? cardPercentageWidth;
  final Function(BuildContext, Coin)? onCoinTap;


  AllCoin({
    Key? key,

    required this.coinsList,
    required this.currencyList,
    required this.tickerList,
    required this.inrRate,

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

    this.showCoinImage = true,
    this.cardPercentageBorder,
    this.cardPercentageHeight,
    this.cardPercentageWidth,
    this.onCoinTap,

  }) : super(key: key);


  // bool isP2PSelected = false;

  List tabItems = [];
  int selectedTabIndex = 0;
  // int selectedTabIndex = CoinController.to.selectedTabIndex.value;

  tabItemsList() {
    tabItems.addAll(currencyList);
    tabItems.insert(showWishlistAtFirst ? 0 : tabItems.length, 'Wishlist');
  //   tabItems.insert(tabItems.length, 'P2P');
  }


  @override
  Widget build(BuildContext context) {
    selectedTabIndex = showWishlistAtFirst ? 1 : 0;
    CoinController.to.getCoins(coinsList, tickerList);
    CoinController.to.getSelectCurrencyList(currencyList.elementAt(0).toString());
    tabItemsList();

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GetBuilder<CoinController>(
      builder: (_) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: currencyTabBackgroundDecoration ?? BoxDecoration(
                    color: currencyTabBackgroundColor ?? Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                  margin: EdgeInsets.symmetric(horizontal: width * 0.04),
                  child: SizedBox(
                    height: height * 0.05,
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        itemCount: tabItems.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => currencyNameCard(index, context)),
                  ),
                ),
                SizedBox(height: height * 0.01,),
                // isP2PSelected ? SizedBox() :
                !showHeading ? const SizedBox() : Container(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          CoinController.to.selectedCurrencyCoins.sort((a, b) {
                            return a.coinName.toLowerCase().compareTo(b.coinName.toLowerCase());
                          });
                            //sortList = false;
                        },
                        child: SizedBox(
                            width: width * 0.38,
                            child: Text('Coin Name', textAlign: TextAlign.start, style: headingTextStyle ?? TextStyle(color: Theme.of(context).textTheme.bodyText2!.color, fontSize: 12, fontWeight: FontWeight.w600),)),
                      ),
                      GestureDetector(
                        onTap: () {
                          CoinController.to.selectedCurrencyCoins.sort((a, b) {
                            return double.parse(a.coinPrice).compareTo(double.parse(b.coinPrice));
                          });
                            //sortList = false;
                        },
                        child: SizedBox(
                          width: width * 0.22,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Price', textAlign: TextAlign.center, style: headingTextStyle ?? TextStyle(color: Theme.of(context).textTheme.bodyText2!.color, fontSize: 12, fontWeight: FontWeight.w600),),
                              Icon(Icons.arrow_upward_sharp, size: 14, color: Theme.of(context).textTheme.bodyText2!.color,)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        //width: width * 0.2,
                          child: Text('24H Change', textAlign: TextAlign.center, style: headingTextStyle ?? TextStyle(color: Theme.of(context).textTheme.bodyText2!.color, fontSize: 12, fontWeight: FontWeight.w600),)),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: SizedBox(
                    height: height * 0.7,
                    child:
                    // isP2PSelected
                    //     ? P2PScreen()
                    //     : selectedTabIndex == 0
                    //     ? ConstantClass.isLogin
                    //     ? allWishlist.isNotEmpty
                    //     ? ListView.builder(
                    //     shrinkWrap: true,
                    //     itemCount: allWishlist.length,
                    //     itemBuilder: (context, index) {
                    //       return itemsCard(index, context, allWishlist[index]);
                    //     })
                    //     : Center(child: Text("No favourite cryptos.", style: TextStyle(fontSize: 17, color: Theme.of(context).textTheme.bodyText1!.color, fontWeight: FontWeight.w700),),)
                    //     : Login(height, width, context, 'to add/watch wishlist')
                    //     :
                    // selectedTabIndex == showWishlistAtFirst ? 0 : tabItems.length ?  :
                    ListView.builder(
                        // shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                        itemCount: CoinController.to.selectedCurrencyCoins.length,
                        itemBuilder: (context, index) {
                          return itemsCard(index, context, CoinController.to.selectedCurrencyCoins[index]);
                        }),
                  ),
                ),
                // ListView.builder(
                //     itemCount: CoinController.to.selectedCurrencyCoins.length,
                //     shrinkWrap: true,
                //     physics: NeverScrollableScrollPhysics(),
                //     itemBuilder: (context, index) {
                //       // print('coin  list length =====> ${CoinController().allCoinsList}');
                //       return itemsCard(index, context, CoinController.to.selectedCurrencyCoins[index]);
                //     }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget currencyNameCard(int index, context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        if(tabItems[index].toString().toLowerCase() == 'wishlist') {
          selectedTabIndex = index;
          // isP2PSelected = false;
        }
        // else if(tabItems[index].toString().toLowerCase() == 'p2p') {
        //   selectedTabIndex = index;
        //   isP2PSelected = true;
        // }
        // else {

          selectedTabIndex = index;
          // isP2PSelected = false;
          CoinController.to.getSelectCurrencyList(tabItems.elementAt(index).toString());
          CoinController.to.selectedTabIndex(index);
        // }
      },
      child: Container(
        width: width * 0.16,
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: selectedTabIndex == index
              ? currencyTabSelectedItemColor ?? Colors.blueAccent
              : currencyTabItemColor ?? Colors.blue.shade100,
          borderRadius: currencyTabItemBorderRadius ?? BorderRadius.circular(2),
        ),
        child: Center(
          child: tabItems.elementAt(index).toString().toLowerCase() == 'wishlist'
              ? const Icon(Icons.star, color: Colors.amber, size: 16,) : Text(
            tabItems.elementAt(index).toString(),
            style: TextStyle(
              color: selectedTabIndex == index ? currencyTabSelectedTextColor ?? Colors.white : currencyTabTextColor ?? Colors.black,
              fontSize: currencyTabFontSize, fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget itemsCard(index, context, Coin coin) {

    double oldPrice = coin.coinLastPrice.isEmpty ? double.parse(coin.coinPrice) : double.parse(coin.coinLastPrice);
    coin.coinLastPrice = coin.coinPrice;

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        InkWell(
          onTap: () {
            onCoinTap!(context, coin);
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: height * 0.003),
            padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.014),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.network(coin.coinImage, height: width * 0.085, width: width * 0.085, fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(
                            height: width * 0.083,
                            width: width * 0.083,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade400, width: 1)
                            ),
                            child: Center(
                              child: Text(
                                  coin.coinName.isEmpty
                                      ? '-'
                                      : coin.coinName[0]),
                            ),
                          ),
                    ),
                    SizedBox(width: width * 0.014,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: width * 0.24,
                          child: Row(
                            children: [
                              Text("${coin.coinShortName} / ", style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyText1!.color, fontWeight: FontWeight.w700),),
                              Text(coin.coinPairWith, style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyText2!.color, fontWeight: FontWeight.w700),),
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.005,),
                        Text(coin.coinName, style: TextStyle(color: Theme.of(context).textTheme.bodyText2!.color, fontSize: 10),)
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: width * 0.22,
                  child: Text(
                    coin.coinPairWith.toLowerCase() == 'inr'
                        ? (double.parse(coin.coinPrice.toString()) * inrRate).toStringAsFixed(int.parse(coin.coinDecimalPair))
                        : double.parse(coin.coinPrice.toString()).toStringAsFixed(int.parse(coin.coinDecimalPair)),
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12,
                      color: double.parse(coin.coinPrice) > oldPrice ? Colors.lightGreen : double.parse(coin.coinPrice) < oldPrice ? Colors.red : Theme.of(context).textTheme.bodyText1!.color ,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  width: cardPercentageWidth ?? width * 0.16,
                  height: cardPercentageHeight ?? height * 0.025,
                  decoration: BoxDecoration(
                    color: coin.coinPercentage.toString().startsWith('-') ? Colors.red : Colors.lightGreen,
                    borderRadius: cardPercentageBorder ?? BorderRadius.circular(0),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Center(child: FittedBox(child: Text('${coin.coinPercentage}%', style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700),))),
                  //child: Text(percent + '%', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700),),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

}
