class DiscountModel {
  double discount;
  int initialRange;
  int finalRange;
  DiscountModel({
    required this.discount,
    required this.initialRange,
    required this.finalRange,
  });
  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      discount: json["discount"] ?? 0.0,
      initialRange: json["initialRange"] ?? 0,
      finalRange: json["finalRange"] ?? 0,
    );
  }
}
