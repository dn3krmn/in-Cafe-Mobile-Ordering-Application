import 'dart:collection';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Models/quantityModel.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/bottomNavigationBar.dart';
import 'package:e_shop/Widgets/orderCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:image/image.dart';
import 'package:provider/provider.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Models/item.dart';
import '../Models/quantityModel.dart';

double width;
double height;
var veri;

class Onaylanan extends StatefulWidget {
  @override
  _OnaylananState createState() => _OnaylananState();
}

class _OnaylananState extends State<Onaylanan> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
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
          title: Text(
            "Onaylanan Siparişler",
            style: TextStyle(
                fontSize: 45.0,
                color: Colors.white,
                fontFamily: "Italianno-Regular"),
          ),
          centerTitle: true,
          actions: [
            Stack(
              children: [
                /* IconButton(
                  icon: Icon(
                    Icons.add_to_photos_outlined,
                    color: Colors.white,
                  ),
                ),*/
              ],
            ),
          ],
          /*leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Route route =
              MaterialPageRoute(builder: (c) => StoreHome(qr: widget.qr1));
              Navigator.push(context, route);
            },
          ),*/
        ),
        //drawer: MyDrawer(),
        body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection("Onaylanan")
                .orderBy("orderTime", descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Text("Ürün yok");
              }
              return ListView(
                children: snapshot.data.documents.map((document) {
                  return InkWell(
                    splashColor: Colors.deepPurple,
                    child: SingleChildScrollView(
                      //padding: EdgeInsets.all(6.0),
                      child: Container(
                        decoration: new BoxDecoration(
                          gradient: new LinearGradient(
                            colors: [Colors.grey[300], Colors.grey[300]],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(1.0, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp,
                          ),
                        ),
                        padding: EdgeInsets.all(10.0),
                        margin: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Sipariş veren masa : " + document["orderBy"],
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
                                    "Sipariş zamanı : " + document["orderTime"],
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ),
                            Padding(
                                padding: EdgeInsets.all(4.0),
                                child: document["nakitMi"] == true
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
                                  "Müşteri istekleri : " + document["message"],
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Toplam fiyat : " +
                                      document[EcommerceApp.totalAmount]
                                          .toString() +
                                      "₺",
                                  style: TextStyle(
                                    fontSize: 18.0,
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
                                      whereIn: document[EcommerceApp.productID])
                                  .getDocuments(),
                              builder: (c, dataSnapshot) {
                                return dataSnapshot.hasData
                                    ? OrderCard(
                                        miktar: document["urunMiktari"],
                                        itemCount:
                                            dataSnapshot.data.documents.length,
                                        data: dataSnapshot.data.documents,
                                      )
                                    : Center(
                                        child: circularProgress(),
                                      );
                              },
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.deepOrangeAccent,
                                ),
                                onPressed: () {
                                  deleteSiparis(context, document['orderTime']);
                                },
                              ),
                            ),
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

  deleteSiparis(BuildContext context, String ordertime) {
    EcommerceApp.firestore.collection('Onaylanan').document(ordertime).delete();

    Route route = MaterialPageRoute(builder: (c) => Onaylanan());
    Navigator.pushReplacement(context, route);
  }
}
/*
Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    /*onTap: () {
      Route route =
      MaterialPageRoute(builder: (c) => ProductPage(itemModel: model));
      Navigator.push(context, route);
    },*/
    splashColor: Colors.deepPurple,
    child: SingleChildScrollView(
      //padding: EdgeInsets.all(6.0),
      child: Container(
        height: 190.0,
        width: width,
        child: Row(
          children: [
            Image.network(
              model.thumbnailUrl,
              width: 110.0,
              height: 140.0,
            ),
            SizedBox(
              width: 4.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            model.title,
                            style:
                                TextStyle(color: Colors.black, fontSize: 14.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            model.shortInfo,
                            style: TextStyle(
                                color: Colors.black54, fontSize: 12.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Row(
                              children: [
                                Text(
                                  "Fiyat: ",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Text(
                                  "₺ ",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16.0),
                                ),
                                Text(
                                  (model.price).toString(),
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                //Flexible(child:Container()),

                                Container(
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.minimize,
                                          color: Colors.deepOrangeAccent,
                                        ),
                                        onPressed: () {
                                          //changeQuantityInCartDecrese(model.shortInfo, context);
                                        },
                                      ),
                                      Container(
                                        child: Text(
                                            "" /*checkQuantityFromFirebase(model.shortInfo, 3, context).toString()*/),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.deepOrangeAccent,
                                        ),
                                        onPressed: () {
                                          //changeQuantityInCartIncrese(model.shortInfo, context);
                                        },
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),

                  Flexible(
                    child: Container(),
                  ),

                  //to implement the cart item add/remove feature
                  Align(
                    alignment: Alignment.centerRight,
                    child: removeCartFunction == null
                        ? IconButton(
                            icon: Icon(
                              Icons.add_shopping_cart,
                              color: Colors.deepOrangeAccent,
                            ),
                            onPressed: () {
                              // addItemToCart(model.shortInfo, context,widget.qr1);
                            },
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.deepOrangeAccent,
                            ),
                            onPressed: () {
                              removeCartFunction();
                              Route route =
                                  MaterialPageRoute(builder: (c) => CartPage());
                              Navigator.push(context, route);
                            },
                          ),
                  ),

                  Divider(
                    height: 10.0,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}*/

Widget card({
  color: Colors.redAccent,
}) {
  return Container(
      height: 150.0,
      width: width * .34,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          //color: primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                offset: Offset(0, 5),
                blurRadius: 10.0,
                color: Colors.grey[200]),
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ));
}

addItemToCart(String shortInfoAsID, BuildContext context, String qr) {
  List tempCartList =
      EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
  /*EcommerceApp.firestore.collection('qrcodes').document(EcommerceApp.qrId).get().then((veri){
    print(veri.data['qrId']);

  });*/
  Firestore.instance.collection("qrcodes").getDocuments().then((snapshot) {
    snapshot.documents.forEach((i) {
      veri = i.data["qrId"];
      // Route route = MaterialPageRoute(
      //     builder: (c) => Payment(masaNo: result.code,));
      // Navigator.pushReplacement(context, route);
    });
  });
  //print(veri
  print(qr);

  print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
  print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
  print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
  print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
  tempCartList.add(shortInfoAsID);

  EcommerceApp.firestore.collection('qrcodes').document(qr).updateData({
    EcommerceApp.userCartList: tempCartList,
  }).then((v) {
    Fluttertoast.showToast(msg: shortInfoAsID + " sepete başarıyla eklendi.");
    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, tempCartList);
    //userCart daki ürünlerin toplamını sayarak toplam değere ulaşıyor.
    Provider.of<CartItemCounter>(context, listen: false).displayResult();
  });
}
