
class CoinTradeHistory {
  String date,type,price,amount;
  CoinTradeHistory({
    required this.type,
    required this.price,
    required this.amount,
    required this.date
  });
}

List<CoinTradeHistory> coinTradeHistoryList = [];