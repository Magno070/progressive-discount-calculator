import 'package:progressive_discount_test/app/discount_model.dart';

class DiscountCalculatorService {
  static double calculateClientsFinalValue({
    required int clientsQuantity,
    required double initialPrice,
    required List<DiscountModel> discounts,
  }) {
    double finalValue = 0;

    for (final discount in discounts) {
      if (clientsQuantity < discount.initialRange) {
        break;
      }

      int itemsInThisRange = 0;

      if (clientsQuantity >= discount.finalRange) {
        itemsInThisRange = discount.finalRange - discount.initialRange + 1;
      } else {
        itemsInThisRange = clientsQuantity - discount.initialRange + 1;
      }

      final double discountMultiplier = 1 - (discount.discount / 100);
      final double localTotalValue = itemsInThisRange * initialPrice;
      finalValue += localTotalValue * discountMultiplier;
    }
    return finalValue;
  }

  static Map<String, double> calculateClientsTotalValue({
    required int clientsQuantity,
    required double initialPrice,
    required List<DiscountModel> discounts,
  }) {
    double finalValue = 0;
    double totalValue = 0;

    for (final discount in discounts) {
      if (clientsQuantity < discount.initialRange) {
        break;
      }

      int itemsInThisRange = 0;

      if (clientsQuantity >= discount.finalRange) {
        itemsInThisRange = discount.finalRange - discount.initialRange + 1;
      } else {
        itemsInThisRange = clientsQuantity - discount.initialRange + 1;
      }

      final double discountMultiplier = 1 - (discount.discount / 100);
      final double localTotalValue = itemsInThisRange * initialPrice;
      finalValue += localTotalValue * discountMultiplier;
      totalValue += localTotalValue;
    }
    return {"total": totalValue, "totalWithDiscount": finalValue};
  }
}
