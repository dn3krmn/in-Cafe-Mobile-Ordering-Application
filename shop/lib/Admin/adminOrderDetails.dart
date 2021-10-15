import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/siparisGelenMasalar.dart';

import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/orderCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'adminShiftOrders.dart';

String getOrderId = "";
String order = "";

class AdminOrderDetails extends StatelessWidget {
  final Map miktar;
  final String orderID;
  final String orderBy;
  final String message;

  AdminOrderDetails({
    Key key,
    this.orderID,
    this.orderBy,
    this.message,
    this.miktar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getOrderId = orderID;
    order = orderBy;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: EcommerceApp.firestore
                .collection(EcommerceApp.collectionOrders)
                .document(getOrderId)
                .get(),
            builder: (c, snapshot) {
              Map dataMap;
              if (snapshot.hasData) {
                dataMap = snapshot.data.data;
              }
              return snapshot.hasData
                  ? Container(
                      child: Column(
                        children: [
                          AdminStatusBanner(
                            status: dataMap[EcommerceApp.isSuccess],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Sipariş veren masa : " + dataMap["orderBy"],
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          /*SizedBox(
                            height: 10.0,
                          ),*/
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Sipariş zamanı : " + dataMap["orderDate"],
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                          ),
                          Padding(
                              padding: EdgeInsets.all(4.0),
                              child: dataMap["nakitMi"] == true
                                  ? Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Ödeme yöntemi : Nakit ödenecek",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ))
                                  : Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Ödeme yöntemi : Kredi kartı ile ödendi",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ))),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Müşteri istekleri : " + dataMap["message"],
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            height: 2.0,
                          ),
                          FutureBuilder<QuerySnapshot>(
                            future: EcommerceApp.firestore
                                .collection("items")
                                .where("shortInfo",
                                    whereIn: dataMap[EcommerceApp.productID])
                                .getDocuments(),
                            builder: (c, dataSnapshot) {
                              return dataSnapshot.hasData
                                  ? OrderCard(
                                      miktar: miktar,
                                      itemCount:
                                          dataSnapshot.data.documents.length,
                                      data: dataSnapshot.data.documents,
                                    )
                                  : Center(
                                      child: circularProgress(),
                                    );
                            },
                          ),
                          Divider(
                            height: 2.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Toplam fiyat : " +
                                    dataMap[EcommerceApp.totalAmount]
                                        .toString() +
                                    "₺",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          FutureBuilder<DocumentSnapshot>(
                            future: EcommerceApp.firestore
                                .collection(EcommerceApp.qrcodes)
                                .document(orderBy)
                                .get(),
                            builder: (c, snap) {
                              return snap.hasData
                                  ? AdminShippingDetails(
                                      totalAmount:
                                          dataMap[EcommerceApp.totalAmount],
                                      siparisZamani: dataMap["orderDate"],
                                      siparisMasa: dataMap["orderBy"],
                                      odeme: dataMap["nakitMi"],
                                      not: dataMap["message"],
                                      veri: dataMap[EcommerceApp.productID],
                                      miktar: miktar,

                                      /*model:AddressModel.fromJson(snap.data.data),*/
                                    )
                                  : Center(
                                      child: circularProgress(),
                                    );
                            },
                          ),
                        ],
                      ),
                    )
                  : Center(
                      // child: circularProgress(),
                      );
            },
          ),
        ),
      ),
    );
  }
}

class AdminStatusBanner extends StatelessWidget {
  final bool status;
  final bool onay;

  AdminStatusBanner({Key key, this.status, this.onay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String msg;
    IconData iconData;

    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? msg = "Başarılı" : msg = "Başarısız";

    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [Colors.blue[400], Colors.blue[400]],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      height: 55.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Route route =
                  MaterialPageRoute(builder: (c) => SiparisGelenMasalar());
              Navigator.pushReplacement(context, route);
            },
            child: Container(
              child: Icon(
                Icons.arrow_drop_down_circle,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 25.0,
          ),
          Text(
            "Sipariş Verildi " + msg,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 5.0,
          ),
          CircleAvatar(
            radius: 8.0,
            backgroundColor: Colors.grey,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminShippingDetails extends StatelessWidget {
  final double totalAmount;
  final bool odeme;
  final String not;
  final String siparisMasa;
  final String siparisZamani;
  final List veri;
  final Map miktar;
  AdminShippingDetails(
      {Key key,
      this.totalAmount,
      this.not,
      this.odeme,
      this.siparisMasa,
      this.siparisZamani,
      this.veri,
      this.miktar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: () {
                confirmParcelShifted(context, getOrderId, siparisMasa, odeme,
                    not, siparisZamani, totalAmount, veri, miktar);
              },
              child: Container(
                decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                    colors: [Colors.blue[400], Colors.blue[400]],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                width: MediaQuery.of(context).size.width - 40.0,
                height: 50.0,
                child: Center(
                  child: Text(
                    "Siparişi Onayla",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  confirmParcelShifted(
      BuildContext context,
      String mOrderId,
      String orderBy,
      bool odeme,
      String not,
      String siparisZamani,
      double total,
      List veri,
      Map miktar) {
    writeOrderDetailsForAdmin({
      EcommerceApp.productID: veri,
      "orderBy": orderBy,
      EcommerceApp.orderTime: siparisZamani,
      EcommerceApp.isCash: odeme,
      EcommerceApp.totalAmount: total,
      EcommerceApp.message: not,
      "urunMiktari": miktar,
    });
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionOrders)
        .document(mOrderId)
        .delete();

    getOrderId = "";
    bool onay = true;
    Route route = MaterialPageRoute(builder: (c) => SiparisGelenMasalar());
    Navigator.pushReplacement(context, route);

    Fluttertoast.showToast(msg: "Sipariş Onaylandı.");
  }
  /*  EcommerceApp.firestore
        .collection(EcommerceApp.collectionOnaylanan)
        .document(mOrderId)
        .updateData(
      ""
    );*/

  Future writeOrderDetailsForAdmin(Map<String, dynamic> data) async {
    await EcommerceApp.firestore
        .collection(EcommerceApp.collectionOnaylanan)
        //.document(data['orderBy'])
        //.document(EcommerceApp.sharedPreferences.getString(EcommerceApp.qrId) +
        //   data['orderTime'])
        .document(siparisZamani)
        .setData(data);
  }
}

/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/siparisGelenMasalar.dart';

import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/orderCard.dart';
import 'package:e_shop/Models/address.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'adminShiftOrders.dart';

String getOrderId = "";

class AdminOrderDetails extends StatelessWidget {
  final String orderID;
  final String orderBy;
  final String message;

  AdminOrderDetails({
    Key key,
    this.orderID,
    this.orderBy,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getOrderId = orderID;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: EcommerceApp.firestore
                .collection(EcommerceApp.collectionOrders)
                .document(getOrderId)
                .get(),
            builder: (c, snapshot) {
              Map dataMap;
              if (snapshot.hasData) {
                dataMap = snapshot.data.data;
              }
              return snapshot.hasData
                  ? Container(
                child: Column(
                  children: [
                    AdminStatusBanner(
                      status: dataMap[EcommerceApp.isSuccess],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Sipariş veren masa : " + dataMap["orderBy"],
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    /*SizedBox(
                            height: 10.0,
                          ),*/
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Sipariş zamanı : " + dataMap["orderDate"],
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                    Padding(
                        padding: EdgeInsets.all(4.0),
                        child: dataMap["nakitMi"] == true
                            ? Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Ödeme yöntemi : Nakit ödenecek",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ))
                            : Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Ödeme yöntemi : Kredi kartı ile ödendi",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ))),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Müşteri istekleri : " + dataMap["message"],
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      height: 2.0,
                    ),
                    FutureBuilder<QuerySnapshot>(
                      future: EcommerceApp.firestore
                          .collection("items")
                          .where("shortInfo",
                          whereIn: dataMap[EcommerceApp.productID])
                          .getDocuments(),
                      builder: (c, dataSnapshot) {
                        return dataSnapshot.hasData
                            ? OrderCard(
                          itemCount:
                          dataSnapshot.data.documents.length,
                          data: dataSnapshot.data.documents,
                        )
                            : Center(
                          child: circularProgress(),
                        );
                      },
                    ),
                    Divider(
                      height: 2.0,
                    ),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Toplam fiyat : " +
                              dataMap[EcommerceApp.totalAmount]
                                  .toString() +
                              "₺",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    FutureBuilder<DocumentSnapshot>(
                      future: EcommerceApp.firestore
                          .collection(EcommerceApp.qrcodes)
                          .document(orderBy)
                          .get(),
                      builder: (c, snap) {
                        return snap.hasData
                            ? AdminShippingDetails(

                          /*model:
                                          AddressModel.fromJson(snap.data.data),*/
                        )
                            : Center(
                          child: circularProgress(),
                        );
                      },
                    ),
                  ],
                ),
              )
                  : Center(
                // child: circularProgress(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class AdminStatusBanner extends StatelessWidget {
  final bool status;
  final bool onay;

  AdminStatusBanner({Key key, this.status, this.onay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String msg;
    IconData iconData;

    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? msg = "Başarılı" : msg = "Başarısız";

    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [Colors.blue[400], Colors.blue[400]],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      height: 55.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Route route =
              MaterialPageRoute(builder: (c) => SiparisGelenMasalar());
              Navigator.pushReplacement(context, route);
            },
            child: Container(
              child: Icon(
                Icons.arrow_drop_down_circle,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 25.0,
          ),
          Text(
            "Sipariş Verildi " + msg,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 5.0,
          ),
          CircleAvatar(
            radius: 8.0,
            backgroundColor: Colors.grey,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminShippingDetails extends StatelessWidget {
  AdminShippingDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: () {
                confirmParcelShifted(context, getOrderId);
              },
              child: Container(
                decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                    colors: [Colors.blue[400], Colors.blue[400]],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                width: MediaQuery.of(context).size.width - 40.0,
                height: 50.0,
                child: Center(
                  child: Text(
                    "Siparişi Onayla",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  confirmParcelShifted(BuildContext context, String mOrderId) {
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionOrders)
        .document(mOrderId)
        .delete();

    getOrderId = "";
    bool onay = true;
    Route route = MaterialPageRoute(builder: (c) => SiparisGelenMasalar());
    Navigator.pushReplacement(context, route);

    Fluttertoast.showToast(msg: "Sipariş Onaylandı.");
  }
}
*/
