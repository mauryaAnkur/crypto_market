/// Trade History model which holds a single coin trade history data.
/// It contains 4 required variables that hold a single coin trade history data:
/// type, price, amount, date,
///
class TradeHistory {
  String date, type, price, amount;

  TradeHistory(
      {required this.type,
      required this.price,
      required this.amount,
      required this.date});
}

List<TradeHistory> tradeHistoryList = [];
