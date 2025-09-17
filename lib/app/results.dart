// results.dart

import 'package:flutter/material.dart';
import 'package:progressive_discount_test/app/discount_model.dart';

class ResultsContainer extends StatefulWidget {
  final List<DiscountModel> values;
  final double initialPrice;
  final int itemsAmount;
  const ResultsContainer({
    super.key,
    required this.values,
    required this.initialPrice,
    required this.itemsAmount,
  });

  @override
  State<ResultsContainer> createState() => _ResultsContainerState();
}

class _ResultsContainerState extends State<ResultsContainer> {
  final leadersStyle = TextStyle(
    color: const Color(0xFF3F3F3F),
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
  double totalValue = 0;
  double finalValue = 0;

  @override
  void initState() {
    super.initState();
    _calculateTotals();
  }

  @override
  void didUpdateWidget(covariant ResultsContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Recalcula os totais se a lista de valores, o preço inicial
    // ou a quantidade de itens mudarem.
    if (widget.values != oldWidget.values ||
        widget.initialPrice != oldWidget.initialPrice ||
        widget.itemsAmount != oldWidget.itemsAmount) {
      _calculateTotals();
    }
  }

  void _calculateTotals() {
    double tempTotalValue = 0;
    double tempFinalValue = 0;

    for (var discountItem in widget.values) {
      final int itemsLength =
          discountItem.finalRange - discountItem.initialRange + 1;
      final double discountMultiplier = 1 - discountItem.discount / 100;

      final double localTotalValue = itemsLength * widget.initialPrice;
      final double localFinalValue = localTotalValue * discountMultiplier;

      tempTotalValue += localTotalValue;
      tempFinalValue += localFinalValue;
    }

    setState(() {
      totalValue = tempTotalValue;
      finalValue = tempFinalValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => setState(() {}),
              icon: Icon(Icons.refresh),
            ),
            SizedBox(width: 16),
            Text(
              "Cálculo da diária de ${widget.itemsAmount} clientes",
              style: leadersStyle,
            ),
          ],
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF9B9B9B), width: 2),
            ),
            child: Column(
              children: [
                tableHeader(),
                Divider(
                  color: const Color(0xFF9B9B9B),
                  height: 2,
                  thickness: 2,
                ),
                Expanded(child: buildTableRows()),
              ],
            ),
          ),
        ),
        SizedBox(width: double.infinity, child: trailing()),
      ],
    );
  }

  VerticalDivider verticalDivider = VerticalDivider(
    color: const Color(0xFF9B9B9B),
    width: 1,
    thickness: 2,
  );

  Widget trailing() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Simulação feita sobre o valor de R\$ ${widget.initialPrice}:",
              style: leadersStyle,
            ),
            // Text(
            //   "Valor total: R\$ ${totalValue.toStringAsFixed(2)}",
            //   style: leadersStyle,
            // ),
            Text(
              "Valor final: R\$ ${finalValue.toStringAsFixed(2)}",
              style: leadersStyle,
            ),
            Text(
              "Total economizado: R\$ ${(totalValue - finalValue).toStringAsFixed(2)}",
              style: leadersStyle,
            ),
          ],
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Text(
            "TOTAL: R\$ ${finalValue.toStringAsFixed(2)}",
            style: TextStyle(
              color: const Color(0xFF3F3F3F),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget tableHeader() {
    final TextStyle headerStyle = TextStyle(
      color: const Color(0xFF3F3F3F),
      fontWeight: FontWeight.w600,
      fontSize: 18,
    );

    return Container(
      constraints: BoxConstraints(maxHeight: 40),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Início da faixa",
              style: headerStyle,
              textAlign: TextAlign.center,
            ),
          ),
          verticalDivider,
          Expanded(
            child: Text(
              "Fim da faixa",
              style: headerStyle,
              textAlign: TextAlign.center,
            ),
          ),
          verticalDivider,
          Expanded(
            child: Text(
              "Total de diárias da faixa",
              style: headerStyle,
              textAlign: TextAlign.center,
            ),
          ),
          verticalDivider,
          Expanded(
            child: Text(
              "Desconto(%)",
              style: headerStyle,
              textAlign: TextAlign.center,
            ),
          ),
          verticalDivider,
          Expanded(
            child: Text(
              "Valor diária individual",
              style: headerStyle,
              textAlign: TextAlign.center,
            ),
          ),
          verticalDivider,
          Expanded(
            child: Text(
              "Valor total da faixa",
              style: headerStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTableRows() {
    return ListView.builder(
      itemCount: widget.values.length,
      itemBuilder: (context, index) {
        return tableRow(
          initialRange: widget.values[index].initialRange,
          finalRange: widget.values[index].finalRange,
          discount: widget.values[index].discount,
          initialPrice: widget.initialPrice,
        );
      },
    );
  }

  Widget tableRow({
    required int initialRange,
    required int finalRange,
    required double discount,
    required double initialPrice,
  }) {
    Map<String, double> calculateDiscount() {
      final int itemsLength = finalRange - initialRange + 1;

      final double discountMultiplier = 1 - (discount / 100);

      final double localTotalValue = itemsLength * initialPrice;

      final double localFinalValue = localTotalValue * discountMultiplier;

      final Map<String, double> values = {
        "total": localTotalValue,
        "totalWithDiscount": localFinalValue,
      };

      return values;
    }

    final Map<String, double> values = calculateDiscount();

    return Container(
      constraints: BoxConstraints(maxHeight: 32),
      child: Row(
        children: [
          tableCell(child: Text(initialRange.toString())),
          tableCell(child: Text(finalRange.toString())),
          tableCell(child: Text((finalRange - initialRange + 1).toString())),

          tableCell(child: Text("$discount %")),
          tableCell(
            child: Text("R\$ ${widget.initialPrice * (1 - (discount / 100))}"),
          ),
          tableCell(
            child: Text(
              "R\$ ${values["totalWithDiscount"]!.toStringAsFixed(2)}",
            ),
          ),
        ],
      ),
    );
  }

  tableCell({required Widget child, int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Container(alignment: Alignment.center, child: child),
    );
  }
}
