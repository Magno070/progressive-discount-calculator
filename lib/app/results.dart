import 'package:flutter/material.dart';
import 'package:progressive_discount_test/app/discount_model.dart';

class ResultsContainer extends StatefulWidget {
  final List<DiscountModel> values;
  const ResultsContainer({super.key, required this.values});

  @override
  State<ResultsContainer> createState() => _ResultsContainerState();
}

class _ResultsContainerState extends State<ResultsContainer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          border: BoxBorder.all(color: const Color(0xFFc4CAF50), width: 1.2),
        ),
        child: Column(children: [tableHeader(), tableRows()]),
      ),
    );
  }

  Widget tableHeader() {
    return Row(
      children: [
        Expanded(child: Text("Início")),
        Expanded(child: Text("Fim")),
        Expanded(child: Text("Desconto(%)")),
        Expanded(child: Text("Total")),
      ],
    );
  }

  Widget tableRows() {
    return ListView.builder(
      itemCount: widget.values.length,
      itemBuilder: (build, context) {
        return Placeholder();
      },
    );
  }
}
