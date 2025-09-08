import 'package:flutter/material.dart';

class ResultsContainer extends StatefulWidget {
  final List<Map<String, dynamic>> values;
  const ResultsContainer({super.key, required this.values});

  @override
  State<ResultsContainer> createState() => _ResultsContainerState();
}

class _ResultsContainerState extends State<ResultsContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.all(color: const Color(0xFF4CAF50), width: 1.2),
      ),
      child: ListView.builder(
        itemCount: widget.values.length,
        itemBuilder: (build, context) {
          return Placeholder();
        },
      ),
    );
  }
}
