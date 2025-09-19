import 'package:flutter/material.dart';
import 'package:progressive_discount_test/app/discount_model.dart';

class DiscountsProvider extends ChangeNotifier {
  List<DiscountModel> _discounts = [
    DiscountModel(discount: 1, initialRange: 1, finalRange: 100),
  ];

  List<DiscountModel> get discounts => _discounts;
  set discounts(List<DiscountModel> discounts) {
    _discounts = discounts;
    notifyListeners();
  }

  void addDiscount(DiscountModel discount) {
    _discounts.add(discount);
    notifyListeners();
  }

  void removeDiscount(DiscountModel discount) {
    _discounts.remove(discount);
    notifyListeners();
  }

  void updateDiscount(DiscountModel discount) {
    final index = _discounts.indexOf(discount);
    if (index != -1) {
      _discounts[index] = discount;
      notifyListeners();
    }
  }
}
