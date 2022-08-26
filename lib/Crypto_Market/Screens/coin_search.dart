
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../GetX/all_coin_getx.dart';
import '../Model/coin_model.dart';

class CoinSearch extends StatefulWidget {

  final List<Coin> coinsList;
  final List<String> currencyList;
  final List<String> tickerList;
  final double inrRate;

  /// coins list
  final bool? showCoinImage;
  final BorderRadius? cardPercentageBorder;
  final double? cardPercentageHeight;
  final double? cardPercentageWidth;
  final Function(BuildContext, Coin)? onSearchCoinTap;

  const CoinSearch({
    Key? key,
    required this.coinsList,
    required this.currencyList,
    required this.tickerList,
    required this.inrRate,

    this.showCoinImage = true,
    this.cardPercentageBorder,
    this.cardPercentageHeight,
    this.cardPercentageWidth,
    this.onSearchCoinTap,
  }) : super(key: key);

  @override
  State<CoinSearch> createState() => _CoinSearchState();
}

class _CoinSearchState extends State<CoinSearch> {

  bool isDark = false;

  bool sortList = false;

  ///search
  final key = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = TextEditingController();
  bool _isSearching = false;
  String _searchText = "";

  _CoinSearchState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      }
      else {
        setState(() {
          _isSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }
  ///


  @override
  void initState() {
    CoinController.to.getCoins(widget.coinsList, null, widget.tickerList);
    // Provider.of<CoinsProvider>(context, listen: false).getCoinList();
    // connectToServer(context);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    Theme.of(context).brightness == Brightness.dark
        ? isDark = true
        : isDark = false;

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: GetBuilder<CoinController>(
          builder: (_) {
            return Column(
              children: [
                SizedBox(height: height * 0.03,),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: height * 0.05,
                    width: width * 0.9,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey, width: 1)
                    ),
                    child: TextFormField(
                      controller: _searchQuery,
                      onChanged: (newValue) {
                        _searchText = newValue;
                      },
                      //autofocus: widget.details['autoFocus'],
                      style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
                      decoration: InputDecoration(
                          filled: false,
                          border: InputBorder.none,
                          hintText: 'Search coins',
                          hintStyle: TextStyle(color: Theme.of(context).textTheme.bodyText2!.color, fontSize: 14),
                          contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 10)
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.01,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            CoinController.to.allCoinsList.sort((a, b) {
                              return a.coinName.toLowerCase().compareTo(b.coinName.toLowerCase());
                            });
                            sortList = false;
                          });
                        },
                        child: SizedBox(
                            width: width * 0.38,
                            child: Text('Coin Name', textAlign: TextAlign.start, style: TextStyle(color: Theme.of(context).textTheme.bodyText2!.color, fontSize: 12, fontWeight: FontWeight.w600),)),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            CoinController.to.allCoinsList.sort((a, b) {
                              return double.parse(a.coinPrice).compareTo(double.parse(b.coinPrice));
                            });
                            sortList = false;
                          });
                        },
                        child: SizedBox(
                          width: width * 0.22,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Price', textAlign: TextAlign.end, style: TextStyle(color: Theme.of(context).textTheme.bodyText2!.color, fontSize: 12, fontWeight: FontWeight.w600),),
                              Icon(Icons.arrow_upward_sharp, size: 14, color: Theme.of(context).textTheme.bodyText2!.color,)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          child: Text('24H Change', textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).textTheme.bodyText2!.color, fontSize: 12, fontWeight: FontWeight.w600),)),
                    ],
                  ),
                ),
                _isSearching
                    ? _buildSearchList(CoinController.to.allCoinsList)
                    : SizedBox(
                  height: height * 0.8,
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: height * 0.01),
                      physics: const BouncingScrollPhysics(),
                      itemCount: CoinController.to.allCoinsList.length ,
                      itemBuilder: (context, index) {
                        return itemsCard(index, CoinController.to.allCoinsList[index]);
                      }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// coins card
  Widget itemsCard(index, Coin coin) {

    double oldPrice = coin.coinLastPrice.isEmpty ? double.parse(coin.coinPrice) : double.parse(coin.coinLastPrice);
    coin.coinLastPrice = coin.coinPrice;

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        InkWell(
          onTap: () {
            widget.onSearchCoinTap!(context, coin);
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
                        ? (double.parse(coin.coinPrice.toString()) * widget.inrRate).toStringAsFixed(int.parse(coin.coinDecimalPair))
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
                  width: widget.cardPercentageWidth ?? width * 0.16,
                  height: widget.cardPercentageHeight ?? height * 0.025,
                  decoration: BoxDecoration(
                    color: coin.coinPercentage.toString().startsWith('-') ? Colors.red : Colors.lightGreen,
                    borderRadius: widget.cardPercentageBorder ?? BorderRadius.circular(0),
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


  ///search
  Widget _buildSearchList(allCoinList) {
    if (_searchText.isEmpty) {

      _isSearching = false;

      return SizedBox( height: MediaQuery.of(context).size.height * 0.8,
        child: ListView.builder(padding: EdgeInsets.zero, shrinkWrap: true, itemCount: allCoinList.length, itemBuilder: (BuildContext context, index) {
          return itemsCard(index, allCoinList);
        }),
      );
    }
    else {
      _isSearching = true;

      List<Coin> searchList = allCoinList.where((item) => item.coinName.toString().toLowerCase().contains(_searchText.toString().toLowerCase()) || item.coinShortName.toString().toLowerCase().contains(_searchText.toString().toLowerCase())).toList();

      return searchList.isEmpty
          ? Center(child: Text('Item Not Found', style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),),)
          : SizedBox( height: MediaQuery.of(context).size.height * 0.8,
        child: ListView.builder(padding: EdgeInsets.zero, shrinkWrap: true, itemCount: searchList.length, itemBuilder: (BuildContext context, index) {
          return searchItemsCard(index, searchList[index]);
        }),
      );
    }
  }
  ///


  /// search item card
  Widget searchItemsCard(index, Coin coin) {

    double oldPrice = coin.coinLastPrice.isEmpty ? double.parse(coin.coinPrice) : double.parse(coin.coinLastPrice);
    coin.coinLastPrice = coin.coinPrice;

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        InkWell(
          onTap: () {
            widget.onSearchCoinTap!(context, coin);
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
                        ? (double.parse(coin.coinPrice.toString()) * widget.inrRate).toStringAsFixed(int.parse(coin.coinDecimalPair))
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
                  width: widget.cardPercentageWidth ?? width * 0.16,
                  height: widget.cardPercentageHeight ?? height * 0.025,
                  decoration: BoxDecoration(
                    color: coin.coinPercentage.toString().startsWith('-') ? Colors.red : Colors.lightGreen,
                    borderRadius: widget.cardPercentageBorder ?? BorderRadius.circular(0),
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
  ///
}
