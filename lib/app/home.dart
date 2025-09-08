import 'package:flutter/material.dart';

class ProgressiveDiscountApp extends StatefulWidget {
  const ProgressiveDiscountApp({super.key});

  @override
  State<ProgressiveDiscountApp> createState() => _ProgressiveDiscountAppState();
}

class _ProgressiveDiscountAppState extends State<ProgressiveDiscountApp>
    with TickerProviderStateMixin {
  late AnimationController _discountsController;
  late Animation<double> _discountsHeigthAnimation;
  List<TextEditingController> discountsItemsValueControllers = [];
  List<TextEditingController> discountsItemsInitialRangeControllers = [];
  List<TextEditingController> discountsItemsFinalRangeControllers = [];

  List<Map<String, dynamic>> discountItems = [
    {"discount": 1.0, "initialRange": 1.0, "finalRange": 100.0},
  ];

  @override
  void initState() {
    _initializeDiscountsAnimation();
    _initializeControllers();
    super.initState();
  }

  @override
  void dispose() {
    _discountsController.dispose();
    _disposeControllers();
    super.dispose();
  }

  void _initializeControllers() {
    for (int i = 0; i < discountItems.length; i++) {
      discountsItemsValueControllers.add(
        TextEditingController(text: discountItems[i]['discount'].toString()),
      );
      discountsItemsInitialRangeControllers.add(
        TextEditingController(
          text: discountItems[i]['initialRange'].toString(),
        ),
      );
      discountsItemsFinalRangeControllers.add(
        TextEditingController(text: discountItems[i]['finalRange'].toString()),
      );
    }
  }

  void _initializeDiscountsAnimation() {
    _discountsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _discountsHeigthAnimation = Tween<double>(begin: 0.0, end: 1000).animate(
      CurvedAnimation(parent: _discountsController, curve: Curves.bounceOut),
    );
    _discountsController.forward();
  }

  void _disposeControllers() {
    for (int i = 0; i < discountsItemsValueControllers.length; i++) {
      discountsItemsValueControllers[i].dispose();
      discountsItemsInitialRangeControllers[i].dispose();
      discountsItemsFinalRangeControllers[i].dispose();
    }
  }

  /// Adiciona um novo item de desconto à lista e atualiza o estado.
  void _addDiscountItem(Map<String, dynamic> newItem) {
    setState(() {
      discountItems.add(newItem);

      discountsItemsValueControllers.add(
        TextEditingController(text: newItem['discount'].toString()),
      );
      discountsItemsInitialRangeControllers.add(
        TextEditingController(text: newItem['initialRange'].toString()),
      );
      discountsItemsFinalRangeControllers.add(
        TextEditingController(text: newItem['finalRange'].toString()),
      );
    });
  }

  /// Calcula os valores do próximo item de desconto com base nos valores atuais dos TextFields.
  Map<String, double> _calculateNextDiscountValues() {
    double newDiscount;
    double newInitialRange;
    double newFinalRange;

    try {
      if (discountsItemsValueControllers.isEmpty) {
        newDiscount = 1;
        newInitialRange = 1;
        newFinalRange = 100;
      } else if (discountsItemsValueControllers.length == 1) {
        final lastDiscount = double.parse(
          discountsItemsValueControllers.last.text,
        );
        final lastFinalRange = double.parse(
          discountsItemsFinalRangeControllers.last.text,
        );

        newDiscount = lastDiscount * 2;
        newInitialRange = lastFinalRange + 1;
        newFinalRange = lastFinalRange * 2;
      } else {
        final lastDiscount = double.parse(
          discountsItemsValueControllers.last.text,
        );
        final secondLastDiscount = double.parse(
          discountsItemsValueControllers[discountsItemsValueControllers.length -
                  2]
              .text,
        );

        final lastFinalRange = double.parse(
          discountsItemsFinalRangeControllers.last.text,
        );
        final secondLastFinalRange = double.parse(
          discountsItemsFinalRangeControllers[discountsItemsFinalRangeControllers
                      .length -
                  2]
              .text,
        );

        newDiscount = lastDiscount + (lastDiscount - secondLastDiscount);
        newInitialRange = lastFinalRange + 1;
        newFinalRange =
            lastFinalRange + (lastFinalRange - secondLastFinalRange);
      }
    } catch (e) {
      // Fallback em caso de erro de parse (ex: campo vazio ou texto inválido)
      final lastItem = discountItems.last;
      newDiscount = (lastItem['discount'] as num).toDouble() + 1.0;
      newInitialRange = (lastItem['finalRange'] as num).toDouble() + 1.0;
      newFinalRange = newInitialRange + 99.0;
    }

    // Garante que a faixa final seja sempre maior que a inicial
    if (newFinalRange <= newInitialRange) {
      newFinalRange = newInitialRange + 99;
    }

    // Garante que o desconto não seja negativo
    if (newDiscount < 0) {
      newDiscount = 0;
    }

    return {
      "discount": newDiscount,
      "initialRange": newInitialRange,
      "finalRange": newFinalRange,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(context), body: _body(context));
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Desconto progressivo.',
        style: TextStyle(color: const Color(0xFFE7E7E7)),
      ),
      backgroundColor: const Color(0xFF838383),
    );
  }

  Widget _body(BuildContext context) {
    Column label() => Column(
      children: [
        Text(
          'Inserir descontos',
          style: TextStyle(color: const Color(0xFF111111), fontSize: 22),
        ),
        Divider(thickness: 1, color: const Color(0xFF9E9E9E)),
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(child: Text("Quantidade", textAlign: TextAlign.start)),
              Expanded(child: Text("Desconto", textAlign: TextAlign.end)),
            ],
          ),
        ),
      ],
    );

    Widget discountsBuilder() {
      Widget discountTile({
        required TextEditingController valueController,
        required TextEditingController initialRangeController,
        required TextEditingController finalRangeController,
      }) {
        return Padding(
          padding: const EdgeInsets.only(top: 4),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: initialRangeController,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      VerticalDivider(color: const Color(0xFF9E9E9E)),
                      Expanded(
                        child: TextField(
                          controller: finalRangeController,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      suffix: Text("%"),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: const Color(0xFF9E9E9E)),
                      ),
                    ),
                    controller: valueController,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return ListView.builder(
        itemCount: discountItems.length,
        itemBuilder: (context, index) {
          return discountTile(
            valueController: discountsItemsValueControllers[index],
            initialRangeController:
                discountsItemsInitialRangeControllers[index],
            finalRangeController: discountsItemsFinalRangeControllers[index],
          );
        },
      );
    }

    Widget addDiscountTile() {
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              final nextValues = _calculateNextDiscountValues();
              _addDiscountItem({
                "discount": nextValues['discount'],
                "initialRange": nextValues['initialRange'],
                "finalRange": nextValues['finalRange'],
              });
            },
            child: Text('Novo desconto'),
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _discountsController,
      builder: (context, child) => Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: BoxBorder.all(width: 1, color: const Color(0xFF9E9E9E)),
        ),
        height: _discountsHeigthAnimation.value,
        width: 240,
        child: Column(
          children: [
            label(),
            Expanded(child: discountsBuilder()),
            addDiscountTile(),
          ],
        ),
      ),
    );
  }
}
