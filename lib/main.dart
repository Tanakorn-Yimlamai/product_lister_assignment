import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/products/presentation/product_provider.dart';
import 'features/products/presentation/product_list.dart';

void main() {
  runApp(const ProductSellApp());
}

class ProductSellApp extends StatelessWidget {
  const ProductSellApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        title: 'Product Sell App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.black, 
            brightness: Brightness.light,
          ),
          highlightColor: Colors.transparent,
          textTheme: GoogleFonts.interTextTheme(),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.black,            
            selectionHandleColor: Colors.black, 
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.white,
          ),
        ),
        home: const ProductListScreen(),
      ),
    );
  }
}