class Coin {
  String coinID;
  String coinImage;
  String coinName;
  String coinShortName;
  String coinPrice;
  String coinLastPrice;
  String coinPercentage;
  String coinSymbol;
  String coinPairWith;
  String coinHighDay;
  String coinLowDay;
  String coinDecimalPair;
  String coinDecimalCurrency;
  bool coinListed;

  Coin({
    required this.coinID,
    required this.coinImage,
    required this.coinName,
    required this.coinShortName,
    required this.coinPrice,
    required this.coinLastPrice,
    required this.coinPercentage,
    required this.coinSymbol,
    required this.coinPairWith,
    required this.coinHighDay,
    required this.coinLowDay,
    required this.coinDecimalPair,
    required this.coinDecimalCurrency,
    required this.coinListed,
  });

  @override
  String toString() {
    return 'Coin{coinID: $coinID, coinImage: $coinImage, coinName: $coinName, coinShortName: $coinShortName, coinPrice: $coinPrice, coinLastPrice: $coinLastPrice, coinPercentage: $coinPercentage, coinSymbol: $coinSymbol, coinPairWith: $coinPairWith, coinHighDay: $coinHighDay, coinLowDay: $coinLowDay, coinDecimalPair: $coinDecimalPair, coinDecimalCurrency: $coinDecimalCurrency, coinListed: $coinListed}';
  }
}
