import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/getProduct.dart';
import 'package:e_shop/Admin/onaylanansiparisler.dart';
import 'QrCodeGenerator.dart';
import 'adminShiftOrders.dart';

import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'getCategory.dart';
import 'getQr.dart';
import 'package:e_shop/Admin/siparisGelenMasalar.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  bool get wantKeepAlive => true;
  File file;
  File Cfile;
  TextEditingController _categoryNameTextEditingController =
      TextEditingController();
  TextEditingController _pCategoryTextEditingController =
      TextEditingController();
  TextEditingController _longDescriptionTextEditingController =
      TextEditingController();
  String categoryId = DateTime.now().millisecondsSinceEpoch.toString();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _shortInfoTextEditingController =
      TextEditingController();
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    if (file != null) {
      return displayAdminUploadFormProduct();
    } else if (Cfile != null) {
      return displayAdminUploadFormCategory();
    } else {
      return displayAdminHomeScreen();
    }
  }

  displayAdminHomeScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.blue[400], Colors.blue[400]],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.view_module, color: Colors.white),
        ),
        title: Text(
          "Yonetici islemleri",
          style: TextStyle(
              color: Colors.black,
              fontSize: 34.0,
              fontWeight: FontWeight.normal,
              fontFamily: "Signatra"),
        ),
        actions: [
          FlatButton(
            child: Text(
              "Çıkış Yap",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => SplashScreen());
              Navigator.push(context, route);
            },
          ),
        ],
      ),
      body: getAdminHomeScreenBody(),
    );
  }

  getAdminHomeScreenBody() {
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [Colors.white60, Colors.white60],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: ListView(
        children: <Widget>[
          Divider(),
          ListTile(
            leading: Icon(Icons.wysiwyg),
            title: Text("Gelen Siparişler"),
            onTap: () {
              Route route =
                  MaterialPageRoute(builder: (c) => SiparisGelenMasalar());
              Navigator.push(context, route);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.article_rounded),
            title: Text("Onaylanan Siparişler"),
            onTap: () {
              Route route = MaterialPageRoute(builder: (c) => Onaylanan());
              Navigator.push(context, route);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.add),
            title: Text("Ürün Ekle"),
            onTap: () => takeImage(context),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.change_history),
            title: Text("Ürün Listesi"),
            onTap: () {
              Route route = MaterialPageRoute(builder: (c) => GetProduct());
              Navigator.push(context, route);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.add_circle),
            title: Text("Kategori Ekle"),
            onTap: () => takeImageC(context),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.category),
            title: Text("Kategori Listesi"),
            onTap: () {
              Route route = MaterialPageRoute(builder: (c) => GetCategory());
              Navigator.push(context, route);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.qr_code),
            title: Text("QR Masa Ekle"),
            onTap: () {
              Route route =
                  MaterialPageRoute(builder: (c) => QRCodeGenerator());
              Navigator.push(context, route);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.qr_code_scanner_sharp),
            title: Text("QR Masaları Listele"),
            onTap: () {
              Route route = MaterialPageRoute(builder: (c) => GetQr());
              Navigator.push(context, route);
            },
          ),
          Divider(),
        ],
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: Text(
              "Ürün fotoğrafı",
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                child: Text("Galeriden ürün ekle",
                    style: TextStyle(
                      color: Colors.green,
                    )),
                onPressed: pickPhotoFromGallery,
              ),
              SimpleDialogOption(
                child: Text("İptal et",
                    style: TextStyle(
                      color: Colors.green,
                    )),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  pickPhotoFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      file = imageFile;
    });
  }

  displayAdminUploadFormProduct() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.white60, Colors.white60],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: clearFormInfo),
        title: Text(
          "Yeni Ürün Ekleyin",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          FlatButton(
            onPressed: uploading ? null : () => uploadImageAndSaveItemInfo(),
            child: Text(
              "Ekle",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading ? linearProgress() : Text(""),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(file), fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 12.0)),
          ListTile(
            leading: Icon(
              Icons.cloud_upload,
              color: Colors.black,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.black),
                controller: _shortInfoTextEditingController,
                decoration: InputDecoration(
                  hintText: "Ürün Adını Giriniz",
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          ListTile(
            leading: Icon(
              Icons.cloud_upload,
              color: Colors.black,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.black),
                controller: _longDescriptionTextEditingController,
                decoration: InputDecoration(
                  hintText: "Ürün için kısa açıklama",
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          ListTile(
            leading: Icon(
              Icons.cloud_upload,
              color: Colors.black,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.black),
                controller: _priceTextEditingController,
                decoration: InputDecoration(
                  hintText: "Fiyat",
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          ListTile(
            leading: Icon(
              Icons.cloud_upload,
              color: Colors.black,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.black),
                controller: _pCategoryTextEditingController,
                decoration: InputDecoration(
                  hintText: "Kategori Girin",
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  clearFormInfo() {
    setState(() {
      file = null;
      _priceTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _longDescriptionTextEditingController.clear();
      _pCategoryTextEditingController.clear();
    });
  }

  uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    String imageDownloadUrl = await uploadItemImage(file);
    saveItemInfo(imageDownloadUrl);
  }

  Future<String> uploadItemImage(mFileImage) async {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child("Items");
    StorageUploadTask uploadTask =
        storageReference.child("product_$productId.jpg").putFile(mFileImage);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveItemInfo(String downloadUrl) {
    final itemRef = Firestore.instance.collection("items");
    itemRef.document(productId).setData({
      "shortInfo": _shortInfoTextEditingController.text.trim(),
      "price": int.parse(_priceTextEditingController.text),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
      "longDescription": _longDescriptionTextEditingController.text.trim(),
      "pCategory": _pCategoryTextEditingController.text.trim(),
      "productId": productId,
    });

    setState(() {
      file = null;
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _longDescriptionTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _priceTextEditingController.clear();
      _pCategoryTextEditingController.clear();
    });
  }

  takeImageC(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: Text(
              "Ürün fotoğrafı",
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                child: Text("Galeriden ürün ekle",
                    style: TextStyle(
                      color: Colors.green,
                    )),
                onPressed: pickPhotoFromGalleryC,
              ),
              SimpleDialogOption(
                child: Text("İptal et",
                    style: TextStyle(
                      color: Colors.green,
                    )),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  pickPhotoFromGalleryC() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      Cfile = imageFile;
    });
  }

  displayAdminUploadFormCategory() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.white60, Colors.white60],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: clearFormInfoC),
        title: Text(
          "Kategori Ekleyin",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          FlatButton(
            onPressed: uploading ? null : () => uploadImageAndSaveItemInfoC(),
            child: Text(
              "Ekle",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading ? linearProgress() : Text(""),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(Cfile), fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 12.0)),
          ListTile(
            leading: Icon(
              Icons.cloud_upload,
              color: Colors.black,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.black),
                controller: _categoryNameTextEditingController,
                decoration: InputDecoration(
                  hintText: "Kategori Girin..",
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  clearFormInfoC() {
    setState(() {
      Cfile = null;
      _categoryNameTextEditingController.clear();
    });
  }

  uploadImageAndSaveItemInfoC() async {
    setState(() {
      uploading = true;
    });
    String imageDownloadUrl = await uploadItemImageC(Cfile);

    saveItemInfoC(imageDownloadUrl);
  }

  Future<String> uploadItemImageC(mFileImage) async {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child("Category");
    StorageUploadTask uploadTask =
        storageReference.child("product_$categoryId.jpg").putFile(mFileImage);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveItemInfoC(String downloadUrl) {
    final itemRef = Firestore.instance.collection("Category");
    itemRef.document(categoryId).setData({
      "name": _categoryNameTextEditingController.text.trim(),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
      "categoryId": categoryId,
    });
    setState(() {
      Cfile = null;
      uploading = false;
      categoryId = DateTime.now().millisecondsSinceEpoch.toString();
      _categoryNameTextEditingController.clear();
    });
  }
}
