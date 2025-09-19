import 'package:flutter/material.dart';
import 'package:progressive_discount_test/app/discount_model.dart';
import 'package:progressive_discount_test/app/expanded_result_container.dart';
import 'package:progressive_discount_test/helpers/discount_calculator.dart';

class MonthResultContainer extends StatefulWidget {
  final double initialPrice;
  final int initialClientsAmount;
  final List<DiscountModel> ranges;
  final int days;
  const MonthResultContainer({
    super.key,
    required this.initialPrice,
    required this.initialClientsAmount,
    required this.ranges,
    required this.days,
  });

  @override
  State<MonthResultContainer> createState() => _MonthResultContainerState();
}

class _MonthResultContainerState extends State<MonthResultContainer> {
  late List<int> localDays = List.generate(widget.days, (index) => index + 1);
  double monthTotalValue = 0;

  @override
  void initState() {
    super.initState();
    _calculateMonthTotal();
  }

  @override
  void didUpdateWidget(covariant MonthResultContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.days != oldWidget.days ||
        widget.initialClientsAmount != oldWidget.initialClientsAmount ||
        widget.initialPrice != oldWidget.initialPrice ||
        widget.ranges != oldWidget.ranges) {
      _calculateMonthTotal();
    }
  }

  void _calculateMonthTotal() {
    double tempTotalMonthValue = 0;
    for (int i = 0; i < widget.days; i++) {
      tempTotalMonthValue +=
          DiscountCalculatorService.calculateClientsFinalValue(
            clientsQuantity: widget.initialClientsAmount,
            initialPrice: widget.initialPrice,
            discounts: widget.ranges,
          );
    }

    setState(() {
      monthTotalValue = tempTotalMonthValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        leading(),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF9B9B9B), width: 2),
            ),
            child: Column(
              children: [
                buildTableHeader(),
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
      ],
    );
  }

  final TextStyle headerStyle = TextStyle(
    color: const Color(0xFF3F3F3F),
    fontWeight: FontWeight.w600,
    fontSize: 18,
    overflow: TextOverflow.ellipsis,
  );

  VerticalDivider verticalDivider = VerticalDivider(
    color: const Color(0xFF9B9B9B),
    width: 1,
    thickness: 2,
  );

  Widget leading() {
    return Row(
      children: [
        Text(
          "Simulação mensal feita sobre a diária de R\$ ${widget.initialPrice.toStringAsFixed(2)} por cliente",
          style: headerStyle,
        ),
        Spacer(),
        Text(
          "Total do mês: R\$ ${monthTotalValue.toStringAsFixed(2)}",
          style: TextStyle(
            color: const Color(0xFF3F3F3F),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildTableHeader() {
    return Container(
      constraints: BoxConstraints(maxHeight: 40),
      child: Row(
        children: [
          buildHeaderTableCell(text: "Dia", flex: 1),
          verticalDivider,
          buildHeaderTableCell(text: "Quantidade de clientes no dia"),
          verticalDivider,
          buildHeaderTableCell(text: "Valor total do dia"),
          verticalDivider,
          buildHeaderTableCell(text: "Detalhes", flex: 1),
        ],
      ),
    );
  }

  Widget buildHeaderTableCell({required String text, int flex = 3}) {
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
      itemCount: widget.days,
      itemBuilder: (context, index) {
        final double localTotalValue =
            DiscountCalculatorService.calculateClientsFinalValue(
              discounts: widget.ranges,
              initialPrice: widget.initialPrice,
              clientsQuantity: widget.initialClientsAmount,
            );

        return Container(
          constraints: BoxConstraints(maxHeight: 28),
          child: tableRowModel(
            day: localDays[index],
            clientsAmount: widget.initialClientsAmount,
            totalRowValue: localTotalValue,
            clearDivider: index == 0,
            colorBinary: index % 2,
          ),
        );
      },
    );
  }

  Widget tableRowModel({
    required int day,
    required int clientsAmount,
    required double totalRowValue,
    bool clearDivider = false,
    required int colorBinary,
  }) {
    return Stack(
      children: [
        clearDivider ? SizedBox.shrink() : Divider(height: 2),
        Container(
          color: colorBinary == 0
              ? const Color(0xFFDBDBDB)
              : const Color.fromARGB(255, 202, 202, 202),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              tableCellModel(
                text: day.toString().length < 2 ? "0$day" : "$day",
                flex: 1,
              ),
              verticalDivider,
              tableCellModel(text: clientsAmount.toString()),
              verticalDivider,
              tableCellModel(text: totalRowValue.toStringAsFixed(2)),
              verticalDivider,
              tableCellModel(
                flex: 1,
                child: Center(
                  child: IconButton(
                    style: IconButton.styleFrom(padding: EdgeInsets.all(0)),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        surfaceTintColor: const Color(0xFFEBEBEB),
                        backgroundColor: const Color(0xFFEBEBEB),
                        titlePadding: EdgeInsets.all(0),
                        actionsPadding: EdgeInsets.all(0),
                        content: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: Scaffold(
                            body: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ExpandedResultContainer(
                                values: widget.ranges,
                                initialPrice: widget.initialPrice,
                                clientsAmount: widget.initialClientsAmount,
                                clearFunction: () =>
                                    Navigator.of(context).pop(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    icon: Icon(Icons.remove_red_eye),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget tableCellModel({
    //Both text and child can't be != null
    String? text,
    Widget? child,
    int flex = 3,
  }) {
    TextStyle tableCellTextStyle = TextStyle();

    return Expanded(
      flex: flex,
      child:
          child ??
          Center(
            child: Text(
              text!,
              style: tableCellTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
    );
  }
}
