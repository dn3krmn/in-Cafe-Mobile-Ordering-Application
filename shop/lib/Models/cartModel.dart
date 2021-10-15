import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  String title;
  String shortInfo;
  Timestamp publishedDate;
  String thumbnailUrl;
  String longDescription;
  String status;
  String category;
  String pCategory;
  int price;
  int quantity;

  CartModel({
    this.title,
    this.shortInfo,
    this.publishedDate,
    this.thumbnailUrl,
    this.longDescription,
    this.status,
    this.category,
    this.pCategory,
    this.quantity,
  });

  CartModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    shortInfo = json['shortInfo'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    longDescription = json['longDescription'];
    status = json['status'];
    category = json['category'];
    pCategory = json['pCategory'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['shortInfo'] = this.shortInfo;
    data['price'] = this.price;
    if (this.publishedDate != null) {
      data['publishedDate'] = this.publishedDate;
    }
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['longDescription'] = this.longDescription;
    data['category'] = this.category;
    data['pCategory'] = this.pCategory;
    data['status'] = this.status;
    return data;
  }
}

class PublishedDate {
  String date;

  PublishedDate({this.date});

  PublishedDate.fromJson(Map<String, dynamic> json) {
    date = json['$date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$date'] = this.date;
    return data;
  }
}
