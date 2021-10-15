import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/siparisGelenMasalar.dart';
import 'adminOrderCard.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/orderCard.dart';

class AdminShiftOrders extends StatefulWidget {
  final String masaAdi;

  AdminShiftOrders({
    this.masaAdi,
  });

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<AdminShiftOrders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
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
          centerTitle: true,
          title: Text(
            widget.masaAdi,
            style: TextStyle(
                fontSize: 40.0, color: Colors.white, fontFamily: "Signatra"),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Route route =
                  MaterialPageRoute(builder: (c) => SiparisGelenMasalar());
              Navigator.push(context, route);
            },
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection("orders")
              .where("orderBy", isEqualTo: widget.masaAdi)
              .snapshots(),
          builder: (c, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (c, index) {
                      return FutureBuilder<QuerySnapshot>(
                          future: Firestore.instance
                              .collection("items")
                              .where("shortInfo",
                                  whereIn: snapshot.data.documents[index]
                                      .data[EcommerceApp.productID])
                              .getDocuments(),
                          builder: (c, snap) {
                            return snap.hasData
                                ? AdminOrderCard(
                                    miktar: snapshot.data.documents[index]
                                        .data["urunMiktari"],
                                    itemCount: snap.data.documents.length,
                                    data: snap.data.documents,
                                    orderID: snapshot
                                        .data.documents[index].documentID,
                                    orderBy: snapshot
                                        .data.documents[index].data["orderBy"],
                                    message: snapshot
                                        .data.documents[index].data["message"])
                                : Center(
                                    child: circularProgress(),
                                  );
                          });
                    },
                  )
                : Center(
                    child: circularProgress(),
                  );
          },
        ),
      ),
    );
  }
}

/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/siparisGelenMasalar.dart';
import 'adminOrderCard.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/orderCard.dart';

class AdminShiftOrders extends StatefulWidget {
  final String masaAdi;

  AdminShiftOrders({
    this.masaAdi,
  });

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<AdminShiftOrders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
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
          centerTitle: true,
          title: Text(
            "Siparişlerim",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Route route =
                  MaterialPageRoute(builder: (c) => SiparisGelenMasalar());
              Navigator.push(context, route);
            },
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection("orders")
              .where("orderBy", isEqualTo: widget.masaAdi)
              .snapshots(),
          builder: (c, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (c, index) {
                      return FutureBuilder<QuerySnapshot>(
                          future: Firestore.instance
                              .collection("items")
                              .where("shortInfo",
                                  whereIn: snapshot.data.documents[index]
                                      .data[EcommerceApp.productID])
                              .getDocuments(),
                          builder: (c, snap) {
                            return snap.hasData
                                ? AdminOrderCard(
                                    itemCount: snap.data.documents.length,
                                    data: snap.data.documents,
                                    orderID: snapshot
                                        .data.documents[index].documentID,
                                    orderBy: snapshot
                                        .data.documents[index].data["orderBy"],
                                  )
                                : Center(
                                    child: circularProgress(),
                                  );
                          });
                    },
                  )
                : Center(
                    child: circularProgress(),
                  );
          },
        ),
      ),
    );
  }
}
*/
