import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../GetX/all_coin_getx.dart';
import '../Model/coin_model.dart';
import '../Widgets/coin_card.dart';

///
/// search coins from list
///
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
  final Widget Function(Coin)? coinCardWidget;
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
    this.coinCardWidget,
    this.onSearchCoinTap,
  }) : super(key: key);

  @override
  State<CoinSearch> createState() => _CoinSearchState();
}

class _CoinSearchState extends State<CoinSearch> {
  bool isDark = false;

  bool sortList = false;

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
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  @override
  void initState() {
    CoinController.to.getCoins(widget.coinsList, null, widget.tickerList);
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
          builder: (coinController) {
            return Column(
              children: [
                SizedBox(
                  height: height * 0.03,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: height * 0.05,
                    width: width * 0.9,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: TextFormField(
                      controller: _searchQuery,
                      onChanged: (newValue) {
                        _searchText = newValue;
                      },
                      //autofocus: widget.details['autoFocus'],
                      style: const TextStyle(),
                      decoration: const InputDecoration(
                          filled: false,
                          border: InputBorder.none,
                          hintText: 'Search coins',
                          hintStyle: TextStyle(fontSize: 14),
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 10)),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.04, vertical: height * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            CoinController.to.allCoinsList.sort((a, b) {
                              return a.name
                                  .toLowerCase()
                                  .compareTo(b.name.toLowerCase());
                            });
                            sortList = false;
                          });
                        },
                        child: SizedBox(
                          width: width * 0.38,
                          child: const Text(
                            'Coin Name',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            CoinController.to.allCoinsList.sort((a, b) {
                              return double.parse(a.price)
                                  .compareTo(double.parse(b.price));
                            });
                            sortList = false;
                          });
                        },
                        child: SizedBox(
                          width: width * 0.22,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Text(
                                'Price',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Icon(
                                Icons.arrow_upward_sharp,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                          child: Text(
                        '24H Change',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      )),
                    ],
                  ),
                ),
                _isSearching
                    ? _buildSearchList(CoinController.to.allCoinsList)
                    : SizedBox(
                        height: height * 0.8,
                        child: ListView.builder(
                            padding:
                                EdgeInsets.symmetric(vertical: height * 0.01),
                            physics: const BouncingScrollPhysics(),
                            itemCount: CoinController.to.allCoinsList.length,
                            itemBuilder: (context, index) {
                              return widget.coinCardWidget != null
                                  ? widget.coinCardWidget!(
                                      coinController.allCoinsList[index])
                                  : coinCard(
                                      context: context,
                                      coin:
                                          CoinController.to.allCoinsList[index],
                                      inrRate: widget.inrRate,
                                      onTap: widget.onSearchCoinTap,
                                    );
                            }),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }

  ///
  /// search coins item widget
  ///
  Widget _buildSearchList(allCoinList) {
    if (_searchText.isEmpty) {
      _isSearching = false;

      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: allCoinList.length,
            itemBuilder: (BuildContext context, index) {
              return coinCard(
                context: context,
                coin: allCoinList[index],
                inrRate: widget.inrRate,
                onTap: widget.onSearchCoinTap,
              );
            }),
      );
    } else {
      _isSearching = true;

      List<Coin> searchList = allCoinList
          .where((item) =>
              item.coinName
                  .toString()
                  .toLowerCase()
                  .contains(_searchText.toString().toLowerCase()) ||
              item.coinShortName
                  .toString()
                  .toLowerCase()
                  .contains(_searchText.toString().toLowerCase()))
          .toList();

      return searchList.isEmpty
          ? const Center(
              child: Text(
                'Item Not Found',
              ),
            )
          : SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: searchList.length,
                  itemBuilder: (BuildContext context, index) {
                    return coinCard(
                      context: context,
                      coin: allCoinList[index],
                      inrRate: widget.inrRate,
                      onTap: widget.onSearchCoinTap,
                    );
                  }),
            );
    }
  }

  ///
}
