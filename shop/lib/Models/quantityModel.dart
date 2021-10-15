import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class QuantityModel {
  String name;
  int quantity;

  QuantityModel(this.name, this.quantity);

  @override
  String toString() {
    return '{ ${this.name}, ${this.quantity} }';
  }

  QuantityModel.fromJson(Map<String, dynamic> json) {
    quantity = json['$quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$quantity'] = this.quantity;
    return data;
  }
}
