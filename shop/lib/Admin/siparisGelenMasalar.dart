import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:flutter/material.dart';
import 'adminOrderCard.dart';

double width;

class SiparisGelenMasalar extends StatefulWidget {
  String qr;
  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;
  final String orderBy;
  String masaAdi;
  final bool onay;

  SiparisGelenMasalar({
    Key key,
    this.itemCount,
    this.data,
    this.orderBy,
    this.orderID,
    this.masaAdi,
    this.onay,
  }) : super(key: key);
  @override
  _SiparisGelenMasalarState createState() => _SiparisGelenMasalarState();
}

class _SiparisGelenMasalarState extends State<SiparisGelenMasalar> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
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
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => UploadPage());
              Navigator.push(context, route);
            },
          ),
          title: Text(
            "Masalar",
            style: TextStyle(
                fontSize: 40.0, color: Colors.white, fontFamily: "Signatra"),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection("qrcodes")
                .limit(15)
                .orderBy("imageUrl", descending: false)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Text("Ürün yok");
              }
              return ListView(
                children: snapshot.data.documents.map((document) {
                  return InkWell(
                    onTap: () {
                      Route route = MaterialPageRoute(
                          builder: (c) => AdminShiftOrders(
                                masaAdi: document['imageUrl'],
                              ));
                      Navigator.push(context, route);
                    },
                    splashColor: Colors.blue.withOpacity(0.5),
                    child: Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Container(
                        height: 50.0,
                        width: width / 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            changeColor(document['imageUrl']),
                            /*Container(

                                alignment: Alignment.center,
                                height: 50,
                                width: width/1.5,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                    left: 0, top: 0, right: 0, bottom: 0),
                                child: Text(
                                  (document['imageUrl']).toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                color: changeColor(document['imageUrl']),
                                //decoration: ,

                            )*/
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
      ),
    );
  }

  changeColor(String qr) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("orders")
          .where("orderBy", isEqualTo: qr)
          .snapshots(),
      builder: (c, snapshot) {
        print(qr);
        return snapshot.data.documents.isEmpty
            ? Container(
                alignment: Alignment.center,
                height: 50,
                width: width / 1.5,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
                child: Text(
                  qr,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                color: Colors.red
                //decoration: ,

                )
            : Container(
                alignment: Alignment.center,
                height: 50,
                width: width / 1.5,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
                child: Text(
                  qr,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                color: Colors.green
                //decoration: ,

                );
        /*ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (c, index) {
            return FutureBuilder<QuerySnapshot>(
                future: Firestore.instance
                    .collection("orders")
                    .where("productIDs")
                    .getDocuments(),
                builder: (c, snap) {
                  return snap.hasData
                      ? Colors.redAccent
                      : Container(
                    color: Colors.green.shade300,
                  );
                });
          },
        )
            : Center(
          child: circularProgress(),
        );*/
      },
    );
  }
}
