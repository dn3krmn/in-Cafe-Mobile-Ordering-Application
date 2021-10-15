import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String name;
  Timestamp publishedDate;
  String thumbnailUrl;
  String status;

  CategoryModel({
    this.name,
    this.publishedDate,
    this.thumbnailUrl,
    this.status,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.publishedDate != null) {
      data['publishedDate'] = this.publishedDate;
    }
    data['thumbnailUrl'] = this.thumbnailUrl;
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
