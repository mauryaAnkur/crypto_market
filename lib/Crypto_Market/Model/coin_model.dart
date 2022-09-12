/// Coin model which holds a single coin data.
/// It contains 14 required variables that hold a single coin data:
/// coinID, coinImage, coinName, coinShortName, coinPrice,
/// coinLastPrice, coinSymbol, coinPairWith, coinHighDay, coinLowDay,
/// coinDecimalPair, coinDecimalCurrency and coinListed.
///

class Coin {
  /// ID of coin
  /// if you don't have coin ID then enter any random number
  String coinID;

  /// Image of coin
  String coinImage;

  /// Name of coin
  String coinName;

  /// short name of coin
  String coinShortName;

  /// price of coin
  String coinPrice;

  /// last price of coin
  /// if you don't have last price of coin then enter price of coin
  String coinLastPrice;

  /// percentage change of coin
  String coinPercentage;

  /// symbol of coin
  String coinSymbol;

  ///
  String coinPairWith;

  ///
  String coinHighDay;
  String coinLowDay;
  int coinDecimalPair;
  int coinDecimalCurrency;
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
