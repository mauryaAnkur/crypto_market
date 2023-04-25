/// Coin model which holds a single coin data.
/// It contains 14 required variables that hold a single coin data:
/// coinID, coinImage, coinName, coinShortName, coinPrice,
/// coinLastPrice, coinSymbol, coinPairWith, coinHighDay, coinLowDay,
/// coinDecimalPair, coinDecimalCurrency and coinListed.
///

class Coin {
  /// ID of coin
  /// if you don't have coin ID then enter any random number
  String id;

  /// Image of coin
  String image;

  /// Name of coin
  String name;

  /// short name of coin
  String shortName;

  /// price of coin
  String price;

  /// last price of coin
  /// if you don't have last price of coin then enter price of coin
  String lastPrice;

  /// percentage change of coin
  String percentage;

  /// symbol of coin
  String symbol;

  ///
  String pairWith;

  ///
  String highDay;
  String lowDay;
  int decimalCurrency;

  Coin({
    required this.id,
    required this.image,
    required this.name,
    required this.shortName,
    required this.price,
    required this.lastPrice,
    required this.percentage,
    required this.symbol,
    required this.pairWith,
    required this.highDay,
    required this.lowDay,
    required this.decimalCurrency,
  });

  @override
  String toString() {
    return 'Coin{coinID: $id, coinImage: $image, coinName: $name, coinShortName: $shortName, coinPrice: $price, coinLastPrice: $lastPrice, coinPercentage: $percentage, coinSymbol: $symbol, coinPairWith: $pairWith, coinHighDay: $highDay, coinLowDay: $lowDay, coinDecimalCurrency: $decimalCurrency}';
  }
}
