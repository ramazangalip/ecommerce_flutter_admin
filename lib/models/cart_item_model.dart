import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_flutter_admin/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:ecommerce_flutter_admin/provider/product_provider.dart' as ProductProviderProvider;

class CartItemModel {
  final String productId;
  final String productName;
  final String price;
  final String quantity;
  final Timestamp timestamp;
  final String userName;

  CartItemModel({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.timestamp,
    required this.userName,
  });

  factory CartItemModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return CartItemModel(
      productId: data['productId'],
      productName: data['productName'],
      price: data['price'],
      quantity: data['quantity'],
      timestamp: data['timestamp'],
      userName: data['userName'],
    );
  }
}

class ProductProvider with ChangeNotifier {
  List<ProductModel> products = [];
  List<CartItemModel> cartItems = [];
  

  // Diğer metodlar burada...

  Future<List<CartItemModel>> fetchCartItems() async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("cart_items").get();
    cartItems = querySnapshot.docs.map((doc) => CartItemModel.fromFirestore(doc)).toList();
    notifyListeners();
    return cartItems;
  } catch (e) {
    rethrow;
  }
}

}
