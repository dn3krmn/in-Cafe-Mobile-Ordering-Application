import 'package:cloud_firestore/cloud_firestore.dart';

class QRModel {
  String shortInfo;
  Timestamp publishedDate;
  String thumbnailUrl;
  String longDescription;
  String status;
  String category;
  String pCategory;
  int price;
  int qr;
  Map urunMiktari;

  QRModel(
      {this.shortInfo,
      this.publishedDate,
      this.thumbnailUrl,
      this.longDescription,
      this.status,
      this.category,
      this.pCategory,
      this.qr,
      this.urunMiktari});

  QRModel.fromJson(Map<String, dynamic> json) {
    shortInfo = json['shortInfo'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    longDescription = json['longDescription'];
    status = json['status'];
    category = json['category'];
    pCategory = json['pCategory'];
    price = json['price'];
    qr = json['qrId'];
    urunMiktari = json['urunMiktari'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

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
    data['qrId'] = this.qr;
    data['urunMiktari'] = this.urunMiktari;
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
