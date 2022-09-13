/// Order Volume model which holds a single coin volume data.
/// It contains 3 required String variables that hold a single coin volume data:
/// price, value, percent,
///
class OrderVolume {
  String value, price, percent;

  OrderVolume(
      {required this.price, required this.value, required this.percent});
}
