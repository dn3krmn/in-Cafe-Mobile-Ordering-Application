import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/bottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ReadQr extends StatefulWidget {
  @override
  _ReadQrState createState() => _ReadQrState();
}

class _ReadQrState extends State<ReadQr> {
  Barcode result;
  bool scanned = false;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  //Çalışırken yeniden yüklemeyi başlatmak için, platform android ise
  // kamerayı duraklatmalı veya platform iOS ise kamerayı devam ettirmeliyiz.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeigth = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: _buildQrView(context),
            ),
            /* Expanded(
              child: Container(
                color: Colors.black12,
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.orange,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      if (!scanned) {
        Firestore.instance
            .collection("qrcodes")
            .getDocuments()
            .then((snapshot) {
          snapshot.documents.forEach((i) {
            if (i.data["imageUrl"] != result.code) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Masa numaranız doğru değil.."),
              ));
            } else {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(i.data["imageUrl"] + " 'e hoşgeldiniz."),
              ));
              scanned = true;

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StoreHome(qr: i.data["qrId"])),
              );
              // Route route = MaterialPageRoute(
              //     builder: (c) => Payment(masaNo: result.code,));
              // Navigator.pushReplacement(context, route);
            }
          });
        });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
