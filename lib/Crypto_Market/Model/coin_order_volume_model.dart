/// Order Volume model which holds a single coin volume data.
/// It contains 4 required String variables that hold a single coin volume data:
/// number, price, value, percent,
///
class OrderVolume {
  String number, value, price, percent;

  OrderVolume(
      {required this.number,
      required this.price,
      required this.value,
      required this.percent});
}
