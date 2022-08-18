
class OrderVolume {
  String number,value,price,percent;

  OrderVolume({
    required this.number,
    required this.price,
    required this.value,
    required this.percent
  });

}

List<OrderVolume> coinOrderVolumeBuyList = [];
List<OrderVolume> coinOrderVolumeSellList = [];

List<OrderVolume> coinOrderBookBuyList = [];
List<OrderVolume> coinOrderBookSellList = [];
