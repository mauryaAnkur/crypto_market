
class TradeHistory {

  String date, type, price, amount;

  TradeHistory({
    required this.type,
    required this.price,
    required this.amount,
    required this.date
  });
}

List<TradeHistory> tradeHistoryList = [];