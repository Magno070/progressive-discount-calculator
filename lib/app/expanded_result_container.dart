// results.dart

import 'package:flutter/material.dart';
import 'package:progressive_discount_test/app/discount_model.dart';
import 'package:progressive_discount_test/helpers/discount_calculator.dart';

class ExpandedResultContainer extends StatefulWidget {
  final List<DiscountModel> values;
  final double initialPrice;
  final int clientsAmount;
  final VoidCallback clearFunction;
  const ExpandedResultContainer({
    super.key,
    required this.values,
    required this.initialPrice,
    required this.clientsAmount,
    required this.clearFunction,
  });

  @override
  State<ExpandedResultContainer> createState() =>
      _ExpandedResultContainerState();
}

class _ExpandedResultContainerState extends State<ExpandedResultContainer> {
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
    _calculateTotals(clientsQuantity: widget.clientsAmount);
  }

  @override
  void didUpdateWidget(covariant ExpandedResultContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.values != oldWidget.values ||
        widget.initialPrice != oldWidget.initialPrice ||
        widget.clientsAmount != oldWidget.clientsAmount) {
      _calculateTotals(clientsQuantity: widget.clientsAmount);
    }
  }

  void _calculateTotals({required int clientsQuantity}) {
    double tempTotalValue = 0;
    double tempFinalValue = 0;

    final Map<String, dynamic> calculatedClientsTotalValue =
        DiscountCalculatorService.calculateClientsTotalValue(
          clientsQuantity: clientsQuantity,
          initialPrice: widget.initialPrice,
          discounts: widget.values,
        );

    tempFinalValue = calculatedClientsTotalValue["totalWithDiscount"];
    tempTotalValue = calculatedClientsTotalValue["total"];

    // Atualiza o estado do widget com os valores finais
    setState(() {
      totalValue = tempTotalValue;
      finalValue = tempFinalValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEBEBEB),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: widget.clearFunction,
                icon: Icon(Icons.close),
              ),
              SizedBox(width: 16),
              Text(
                "Cálculo da diária de ${widget.clientsAmount} clientes, sobre o valor de R\$ ${widget.initialPrice}",
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
      ),
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
    return Container(
      constraints: BoxConstraints(maxHeight: 40),
      child: Row(
        children: [
          buildHeaderTableCell(text: "N", flex: 1),
          verticalDivider,
          buildHeaderTableCell(text: "Faixa"),
          verticalDivider,
          buildHeaderTableCell(text: "Total de diárias da faixa"),
          verticalDivider,
          buildHeaderTableCell(text: "Desconto(%)"),
          verticalDivider,
          buildHeaderTableCell(text: "Valor diária individual"),
          verticalDivider,
          buildHeaderTableCell(text: "Valor total da faixa"),
        ],
      ),
    );
  }

  buildHeaderTableCell({required String text, int flex = 3}) {
    final TextStyle headerStyle = TextStyle(
      color: const Color(0xFF3F3F3F),
      fontWeight: FontWeight.w600,
      fontSize: 18,
      overflow: TextOverflow.ellipsis,
    );
    return Expanded(
      flex: flex,
      child: Text(text, style: headerStyle, textAlign: TextAlign.center),
    );
  }

  Widget buildTableRows() {
    return ListView.builder(
      itemCount: widget.values.length,
      itemBuilder: (context, index) {
        bool shouldCalculate = true;
        final int clientsToCalculate;
        final clientsAmount = widget.clientsAmount;

        if (clientsAmount > widget.values[index].finalRange) {
          clientsToCalculate =
              widget.values[index].finalRange -
              widget.values[index].initialRange +
              1;
        } else {
          clientsToCalculate =
              clientsAmount - widget.values[index].initialRange + 1;
          if (clientsToCalculate <= 0) {
            shouldCalculate = false;
          }
        }

        final totalRange =
            "${widget.values[index].initialRange} - ${widget.values[index].finalRange}";

        return Column(
          children: [
            tableRowModel(
              index: index + 1,
              clientsToCalculate: shouldCalculate ? clientsToCalculate : 0,
              totalRange: totalRange,
              discount: widget.values[index].discount,
              initialPrice: widget.initialPrice,
              clearDivider: index == 0,
              colorBinary: index % 2,
              finalRange: widget.values[index].finalRange,
            ),
            index == widget.values.length - 1
                ? Divider(height: 2)
                : SizedBox.square(),
          ],
        );
      },
    );
  }

  Widget tableRowModel({
    required int index,
    required int clientsToCalculate,
    required String totalRange,
    required double discount,
    required double initialPrice,
    required int finalRange,
    bool clearDivider = false,
    required int colorBinary,
  }) {
    Map<String, double> calculateDiscount() {
      final double discountMultiplier = 1 - (discount / 100);

      final double localTotalValue = clientsToCalculate * initialPrice;

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
      child: Stack(
        children: [
          clearDivider ? SizedBox.shrink() : Divider(height: 2),
          Container(
            color: colorBinary == 0
                ? const Color(0xFFDBDBDB)
                : const Color.fromARGB(255, 202, 202, 202),
            child: Row(
              children: [
                tableCell(flex: 1, child: Text(index.toString())),
                verticalDivider,
                tableCell(flex: 3, child: Text(totalRange)),
                verticalDivider,
                tableCell(
                  flex: 3,
                  child: Text(
                    (clientsToCalculate).toString(),
                    style: TextStyle(
                      color: clientsToCalculate == 0
                          ? Colors.red
                          : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                verticalDivider,
                tableCell(flex: 3, child: Text("$discount %")),
                verticalDivider,
                tableCell(
                  flex: 3,
                  child: Text(
                    "R\$ ${widget.initialPrice * (1 - (discount / 100))}",
                  ),
                ),
                verticalDivider,
                tableCell(
                  flex: 3,
                  child: Text(
                    "R\$ ${values["totalWithDiscount"]!.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: clientsToCalculate == 0
                          ? Colors.red
                          : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
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
