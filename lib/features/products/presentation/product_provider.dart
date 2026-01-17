import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../data/product_modal.dart';

enum ProductState { initial, loading, loaded, error }

class ProductProvider extends ChangeNotifier {
  final _baseUrl = 'https://dummyjson.com/products';
  
  ProductState _state = ProductState.initial;
  List<Product> _products = [];
  String _errorMessage = '';

  ProductState get state => _state;
  List<Product> get products => _products;
  String get errorMessage => _errorMessage;  

  Future<void> fetchProducts() async {
    _state = ProductState.loading;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> productJsonList = data['products'];

        _products = productJsonList
            .map((item) => Product.fromJson(item))
            .toList();
        
        _state = ProductState.loaded;
      } else {
        _errorMessage = 'เกิดข้อผิดพลาดจากเซิร์ฟเวอร์ (รหัส: ${response.statusCode})';
        _state = ProductState.error;
      }
    } on SocketException {
      _errorMessage = 'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบเครือข่ายของท่าน';     
      _state = ProductState.error;
    } catch (e) {
      _errorMessage = 'เกิดข้อผิดพลาดที่ไม่คาดคิด: $e';
      _state = ProductState.error;
    }

    notifyListeners();
  }

  String _searchQuery = '';

  List<Product> get filteredProducts {
    if (_searchQuery.isEmpty) {
      return _products;
    }
    return _products.where((product) {
      final titleLower = product.title.toLowerCase();
      final brandLower = product.brand.toLowerCase();
      final searchLower = _searchQuery.toLowerCase();
      return titleLower.contains(searchLower) || brandLower.contains(searchLower);
    }).toList();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners(); 
  }
}