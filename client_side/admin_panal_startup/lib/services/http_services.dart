import 'dart:convert';
import 'package:get/get_connect.dart';
import 'package:get/get.dart';

import '../models/category.dart';
import '../models/sub_category.dart';
import '../models/brand.dart';
import '../models/variant_type.dart';
import '../models/variant.dart';
import '../models/product.dart';
import '../models/coupon.dart';
import '../models/poster.dart';
import '../models/order.dart';
import '../models/my_notification.dart';

class HttpService {
  final String baseUrl = 'http://localhost:3000';
  final GetConnect _connect = GetConnect();

  // Generic GET
  Future<Response> getItems({required String endpointUrl}) async {
    try {
      return await _connect.get('$baseUrl/$endpointUrl');
    } catch (e) {
      return Response(
          body: json.encode({'error': e.toString()}), statusCode: 500);
    }
  }

  // --- Specific Get Methods (used in DataProvider) ---

  Future<List<Category>> getCategories() async {
    final response = await getItems(endpointUrl: 'categories');
    return _parseList<Category>(response, (json) => Category.fromJson(json));
  }

  Future<List<SubCategory>> getSubCategories() async {
    final response = await getItems(endpointUrl: 'subcategories');
    return _parseList<SubCategory>(
        response, (json) => SubCategory.fromJson(json));
  }

  Future<List<Brand>> getBrands() async {
    final response = await getItems(endpointUrl: 'brands');
    return _parseList<Brand>(response, (json) => Brand.fromJson(json));
  }

  Future<List<VariantType>> getVariantTypes() async {
    final response = await getItems(endpointUrl: 'variant-types');
    return _parseList<VariantType>(
        response, (json) => VariantType.fromJson(json));
  }

  Future<List<Variant>> getVariants() async {
    final response = await getItems(endpointUrl: 'variants');
    return _parseList<Variant>(response, (json) => Variant.fromJson(json));
  }

  Future<List<Product>> getProducts() async {
    final response = await getItems(endpointUrl: 'products');
    return _parseList<Product>(response, (json) => Product.fromJson(json));
  }

  Future<List<Coupon>> getCoupons() async {
    final response = await getItems(endpointUrl: 'coupons');
    return _parseList<Coupon>(response, (json) => Coupon.fromJson(json));
  }

  Future<List<Poster>> getPosters() async {
    final response = await getItems(endpointUrl: 'posters');
    return _parseList<Poster>(response, (json) => Poster.fromJson(json));
  }

  Future<List<Order>> getOrders() async {
    final response = await getItems(endpointUrl: 'orders');
    return _parseList<Order>(response, (json) => Order.fromJson(json));
  }

  Future<List<MyNotification>> getNotifications() async {
    final response = await getItems(endpointUrl: 'notifications');
    return _parseList<MyNotification>(
        response, (json) => MyNotification.fromJson(json));
  }

  // --- Helpers ---

  List<T> _parseList<T>(Response response, T Function(dynamic json) fromJson) {
    if (response.statusCode == 200) {
      final body = response.body;
      if (body is List) {
        return body.map((item) => fromJson(item)).toList();
      }
    }
    throw Exception('Failed to parse data');
  }

  // --- POST, PUT, DELETE ---

  Future<Response> addItem({
    required String endpointUrl,
    required dynamic itemData,
  }) async {
    try {
      return await _connect.post('$baseUrl/$endpointUrl', itemData);
    } catch (e) {
      return Response(
          body: json.encode({'message': e.toString()}), statusCode: 500);
    }
  }

  Future<Response> updateItem({
    required String endpointUrl,
    required String itemId,
    required dynamic itemData,
  }) async {
    try {
      return await _connect.put('$baseUrl/$endpointUrl/$itemId', itemData);
    } catch (e) {
      return Response(
          body: json.encode({'message': e.toString()}), statusCode: 500);
    }
  }

  Future<Response> deleteItem({
    required String endpointUrl,
    required String itemId,
  }) async {
    try {
      return await _connect.delete('$baseUrl/$endpointUrl/$itemId');
    } catch (e) {
      return Response(
          body: json.encode({'message': e.toString()}), statusCode: 500);
    }
  }
}
