import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progressive_discount_test/app/home/service/discounts_provider.dart';
import 'package:progressive_discount_test/app/home/ui/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.quicksandTextTheme()),
      home: Provider<DiscountsProvider>(
        create: (context) => DiscountsProvider(),
        child: ProgressiveDiscountApp(),
      ),
    );
  }
}
