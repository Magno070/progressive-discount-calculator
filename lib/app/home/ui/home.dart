import 'package:flutter/material.dart';
import 'package:progressive_discount_test/app/discount_model.dart';
import 'package:progressive_discount_test/app/month_result_container.dart';

class ProgressiveDiscountApp extends StatefulWidget {
  const ProgressiveDiscountApp({super.key});

  @override
  State<ProgressiveDiscountApp> createState() => _ProgressiveDiscountAppState();
}

class _ProgressiveDiscountAppState extends State<ProgressiveDiscountApp> {
  final _formKey = GlobalKey<FormState>(); // Chave para o formulário

  final TextEditingController priceController = TextEditingController(
    text: 1.toString(),
  );
  final TextEditingController clientsAmountController = TextEditingController(
    text: 1.toString(),
  );

  List<DiscountModel> discountItems = [
    DiscountModel.fromJson({
      "discount": 1.0,
      "initialRange": 1,
      "finalRange": 100,
    }),
  ];
  bool isShowingResults = false;

  final List<TextEditingController> _discountValueControllers = [];
  final List<TextEditingController> _initialRangeControllers = [];
  final List<TextEditingController> _finalRangeControllers = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    _disposeControllers();
    priceController.dispose();
    clientsAmountController.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    for (var item in discountItems) {
      _addControllersForItem(item);
    }
  }

  void _addControllersForItem(DiscountModel item) {
    _discountValueControllers.add(
      TextEditingController(text: item.discount.toString()),
    );
    _initialRangeControllers.add(
      TextEditingController(text: item.initialRange.toString()),
    );
    _finalRangeControllers.add(
      TextEditingController(text: item.finalRange.toString()),
    );
  }

  void _disposeControllers() {
    for (var controller in _discountValueControllers) {
      controller.dispose();
    }
    for (var controller in _initialRangeControllers) {
      controller.dispose();
    }
    for (var controller in _finalRangeControllers) {
      controller.dispose();
    }
  }

  void _addDiscountItem(DiscountModel newItem) {
    setState(() {
      discountItems.add(newItem);
      _addControllersForItem(newItem);
    });
  }

  Map<String, dynamic> _calculateNextDiscountValues() {
    double newDiscount;
    int newInitialRange;
    int newFinalRange;

    try {
      if (discountItems.isEmpty) {
        newDiscount = 1;
        newInitialRange = 1;
        newFinalRange = 100;
      } else if (discountItems.length == 1) {
        final lastDiscount = discountItems.last.discount;
        final lastFinalRange = discountItems.last.finalRange;

        newDiscount = lastDiscount * 2;
        newInitialRange = lastFinalRange + 1;
        newFinalRange = lastFinalRange * 2;
      } else {
        final lastDiscount = discountItems.last.discount;
        final secondLastDiscount =
            discountItems[discountItems.length - 2].discount;

        final lastFinalRange = discountItems.last.finalRange;
        final secondLastFinalRange =
            discountItems[discountItems.length - 2].finalRange;

        newDiscount = lastDiscount + (lastDiscount - secondLastDiscount);
        newInitialRange = lastFinalRange + 1;
        newFinalRange =
            lastFinalRange + (lastFinalRange - secondLastFinalRange);
      }
    } catch (e) {
      final lastItem = discountItems.last;
      newDiscount = lastItem.discount + 1;
      newInitialRange = lastItem.finalRange + 1;
      newFinalRange = newInitialRange + 99;
    }

    if (newFinalRange <= newInitialRange) {
      newFinalRange = newInitialRange + 99;
    }

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
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      appBar: _appBar(context),
      body: _body(context),
    );
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
    TextStyle textStyle = TextStyle(fontWeight: FontWeight.w600);
    Column label() => Column(
      children: [
        Text(
          'Inserir faixas de descontos',
          style: TextStyle(
            color: const Color(0xFF111111),
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        Divider(thickness: 1, color: const Color(0xFF9E9E9E)),
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          "Início",
                          textAlign: TextAlign.start,
                          style: textStyle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Fim",
                          textAlign: TextAlign.start,
                          style: textStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "Desconto da faixa",
                  textAlign: TextAlign.end,
                  style: textStyle,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    Widget discountsBuilder() {
      Widget discountTile({required int index}) {
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _initialRangeControllers[index],
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                        onChanged: (text) {
                          discountItems[index].initialRange =
                              int.tryParse(text) ?? 0;
                        },
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                      child: Divider(
                        height: 1.5,
                        thickness: 1.5,
                        color: const Color(0xFF9E9E9E),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _finalRangeControllers[index],
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                        onChanged: (text) {
                          discountItems[index].finalRange =
                              int.tryParse(text) ?? 0;
                        },
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    suffix: Text("%"),
                    border: UnderlineInputBorder(),
                  ),
                  controller: _discountValueControllers[index],
                  onChanged: (text) {
                    discountItems[index].discount =
                        double.tryParse(text) ?? 0.0;
                  },
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: discountItems.length,
        itemBuilder: (context, index) {
          return discountTile(index: index);
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
              _addDiscountItem(
                DiscountModel.fromJson({
                  "discount": nextValues['discount'],
                  "initialRange": nextValues['initialRange']?.toInt(),
                  "finalRange": nextValues['finalRange']?.toInt(),
                }),
              );
            },
            child: Text('Novo desconto'),
          ),
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: const Color(0xFF9E9E9E)),
          ),
          width: 230,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                label(),
                Expanded(child: discountsBuilder()),
                addDiscountTile(),
                TextFormField(
                  controller: clientsAmountController,
                  decoration: InputDecoration(
                    labelText: 'Quantidade de clientes',
                  ),
                  keyboardType: TextInputType.numberWithOptions(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um valor';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor, insira um número válido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Preço Inicial'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um valor';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor, insira um número válido';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        if (isShowingResults)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
              child: MonthResultContainer(
                days: 1,
                initialPrice: double.tryParse(priceController.text) ?? 1.0,
                initialClientsAmount: clientsAmountController.text.isEmpty
                    ? 1
                    : int.tryParse(clientsAmountController.text) ?? 1,
                ranges: discountItems,
              ),
            ),
          )
        else
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isShowingResults = true;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Text("Calcular"),
              ),
            ),
          ),
      ],
    );
  }
}
