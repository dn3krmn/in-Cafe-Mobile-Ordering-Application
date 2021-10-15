import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/Config/config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

class QRCodeGenerator extends StatefulWidget {
  @override
  _QRCodeGeneratorState createState() => _QRCodeGeneratorState();
}

class _QRCodeGeneratorState extends State<QRCodeGenerator> {
  String imageURL;
  String word;

  GlobalKey _globalKey = new GlobalKey();

  final TextEditingController _qrTextEditingController =
  TextEditingController();

  bool inside = false;

  Uint8List imageInMemory;
  //bool loading = false;

  StorageReference storageReference = FirebaseStorage().ref().child("qrcodes");
  File file;
  bool uploading = false;
  uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    var imageDownloadUrl = await _capturePng(file);

    saveItemInfo(imageDownloadUrl);
  }

  var imageurl;
  // ignore: missing_return
  Future<Uint8List> _capturePng(imageInMemory) async {
    try {
      print('inside');
      //inside = true;
      RenderRepaintBoundary boundary =
      _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3);
      ByteData byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      print('png done');
      setState(() {
        imageInMemory = pngBytes;
        inside = false;
        //loading = true;
      });
      //print(imageInMemory);

      StorageUploadTask storageUploadTask = storageReference
          .child("IMG_${DateTime.now().millisecondsSinceEpoch}.png")
          .putData(imageInMemory);

      imageurl =
      await (await storageUploadTask.onComplete).ref.getDownloadURL();
      // Fluttertoast.showToast(msg: "url" + imageurl.toString());
      return imageurl;
    } catch (e) {
      print(e);
    }
  }

  String qrId = DateTime.now().millisecondsSinceEpoch.toString();

  Future saveItemInfo(var downloadUrl) async {
    final itemRef = Firestore.instance.collection("qrcodes");
    itemRef.document(qrId).setData({
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": imageurl,
      //"imageUrl" : imageURL,
      "imageUrl": _qrTextEditingController.text.trim(),
      //EcommerceApp.qrId: qrId,
      "qrId": qrId,
      EcommerceApp.userCartList: ["garbageValue"],
      EcommerceApp.urunMiktari: {}
    });
    await EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ["garbageValue"]);
    await EcommerceApp.sharedPreferences.setString("qrId", qrId);
    setState(() {
      file = null;
      uploading = false;
      qrId = DateTime.now().millisecondsSinceEpoch.toString();
    });

    setState(() {
      _qrTextEditingController.clear();
    });
  }

  void initState() {
    super.initState();
    _requestPermission();
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
    _toastInfo(info);
  }

  _saveScreen() async {
    RenderRepaintBoundary boundary =
    _globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    var result = await ImageGallerySaver.saveImage(pngBytes);
    print(result);
    _toastInfo(result.toString());
    return result;
  }

  _toastInfo(String info) {
    Fluttertoast.showToast(msg: info);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "QR Kod Olustur",
            style: TextStyle(
                fontSize: 30.0, color: Colors.white, fontFamily: "Signatra"),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => UploadPage());
            Navigator.push(context, route);
          },
        ),
        backgroundColor: Colors.blue[400],
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(
                Icons.image_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _saveScreen();
                });
              })
        ],
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    Center(
                      child: Container(
                        height: 250,
                        width: 250,
                        child: Image.asset('images/frame.png'),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: RepaintBoundary(
                          key: _globalKey,
                          child: QrImage(
                            data: '$imageURL',
                            version: QrVersions.auto,
                            size: 200.0,
                            errorStateBuilder: (cxt, err) {
                              return Container(
                                child: Center(
                                  child: Text(
                                    "Bir yanlışlık olmalı...",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 60,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Colors.white70,
                  ),
                  child: Center(
                    child: ListTile(
                      title: Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          cursorColor: Colors.black,
                          controller: _qrTextEditingController,
                          onChanged: (value) {
                            setState(() {
                              word = value;
                            });
                          },
                          decoration: new InputDecoration(
                            /*icon: Container(
                              padding: EdgeInsets.only(left: 2),
                              child: Icon(Icons.create_outlined),
                            ),*/
                            hintText: "Masa Ekleyiniz...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 14, top: 15, right: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 50, right: 10),
                      height: 60,
                      width: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: Colors.blue[200],
                      ),
                      child: FlatButton(
                        child: Text(
                          "QR Kodu Oluşturun",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          if (word != null) {
                            //createQRCode(word);
                            setState(() {
                              imageURL = word;
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 50, left: 10),
                      height: 60,
                      width: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: Colors.blue[200],
                      ),
                      child: FlatButton(
                        child: Text(
                          "QR Kodu Kaydedin",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          if (word != null) {
                            //_capturePng();
                            uploadImageAndSaveItemInfo();
                          }
                          Fluttertoast.showToast(msg: "Masa Eklendi");
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

/*import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

class QRCodeGenerator extends StatefulWidget {
  @override
  _QRCodeGeneratorState createState() => _QRCodeGeneratorState();
}

class _QRCodeGeneratorState extends State<QRCodeGenerator> {
  String imageURL;
  String word;

  GlobalKey _globalKey = new GlobalKey();

  final TextEditingController _qrTextEditingController =
  TextEditingController();

  bool inside = false;

  Uint8List imageInMemory;
  //bool loading = false;

  StorageReference storageReference = FirebaseStorage().ref().child("qrcodes");
  File file;
  bool uploading = false;
  uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    var imageDownloadUrl = await _capturePng(file);

    saveItemInfo(imageDownloadUrl);
  }

  var imageurl;
  // ignore: missing_return
  Future<Uint8List> _capturePng(imageInMemory) async {
    try {
      print('inside');
      //inside = true;
      RenderRepaintBoundary boundary =
      _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3);
      ByteData byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      print('png done');
      setState(() {
        imageInMemory = pngBytes;
        inside = false;
        //loading = true;
      });
      //print(imageInMemory);

      StorageUploadTask storageUploadTask = storageReference
          .child("IMG_${DateTime.now().millisecondsSinceEpoch}.png")
          .putData(imageInMemory);
      /*StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
      //return pngBytes;
      var downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
*/
      imageurl =
      await (await storageUploadTask.onComplete).ref.getDownloadURL();
      // Fluttertoast.showToast(msg: "url" + imageurl.toString());
      return imageurl;
    } catch (e) {
      print(e);
    }
  }

  String qrId = DateTime.now().millisecondsSinceEpoch.toString();

  Future saveItemInfo(var downloadUrl) async {
    final itemRef = Firestore.instance.collection("qrcodes");
    itemRef.document(qrId).setData({
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": imageurl,
      //"imageUrl" : imageURL,
      "imageUrl": _qrTextEditingController.text.trim(),
      //EcommerceApp.qrId: qrId,
      "qrId": qrId,
      EcommerceApp.userCartList: ["garbageValue"],
      EcommerceApp.urunMiktari: {}
    });
    await EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ["garbageValue"]);
    await EcommerceApp.sharedPreferences.setString("qrId", qrId);
    setState(() {
      file = null;
      uploading = false;
      qrId = DateTime.now().millisecondsSinceEpoch.toString();
    });

    setState(() {
      _qrTextEditingController.clear();
    });
  }

  void initState() {
    super.initState();
    _requestPermission();
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
    _toastInfo(info);
  }

  _saveScreen() async {
    RenderRepaintBoundary boundary =
    _globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    var result = await ImageGallerySaver.saveImage(pngBytes);
    print(result);
    _toastInfo(result.toString());
  }

  _toastInfo(String info) {
    Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "QR Kod Olustur",
            style: TextStyle(
                fontSize: 30.0, color: Colors.white, fontFamily: "Signatra"),
          ),
        ),
        leading: Icon(
          Icons.create,
        ),
        backgroundColor: Colors.blue[400],
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(
                Icons.image_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _saveScreen();
                });
              })
        ],
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    Center(
                      child: Container(
                        height: 250,
                        width: 250,
                        child: Image.asset('images/frame.png'),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: RepaintBoundary(
                          key: _globalKey,
                          child: QrImage(
                            data: '$imageURL',
                            version: QrVersions.auto,
                            size: 200.0,
                            errorStateBuilder: (cxt, err) {
                              return Container(
                                child: Center(
                                  child: Text(
                                    "Bir yanlışlık olmalı...",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 60,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Colors.white70,
                  ),
                  child: Center(
                    child: ListTile(
                      title: Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          cursorColor: Colors.black,
                          controller: _qrTextEditingController,
                          onChanged: (value) {
                            setState(() {
                              word = value;
                            });
                          },
                          decoration: new InputDecoration(
                            icon: Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Icon(Icons.create_outlined),
                            ),
                            hintText: "Masa Ekleyiniz...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 14, top: 15, right: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 50, right: 10),
                      height: 60,
                      width: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: Colors.blue[200],
                      ),
                      child: FlatButton(
                        child: Text(
                          "QR Kodu Oluşturun",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          if (word != null) {
                            //createQRCode(word);
                            setState(() {
                              imageURL = word;
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 50, left: 10),
                      height: 60,
                      width: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: Colors.blue[200],
                      ),
                      child: FlatButton(
                        child: Text(
                          "QR Kodu Kaydedin",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          if (word != null) {
                            //_capturePng();
                            uploadImageAndSaveItemInfo();
                          }
                          Fluttertoast.showToast(msg: "Masa Eklendi");
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}*/
