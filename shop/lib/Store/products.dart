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

class Products extends StatefulWidget {
  //Kategori ismini almak için kullanılıyor
  final String qr1;
  final String adi;
  Products({this.adi, this.qr1});
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
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
                colors: [Colors.orange, Colors.orangeAccent],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          title: Text(
            widget.adi,
            style: TextStyle(
                fontSize: 45.0,
                color: Colors.white,
                fontFamily: "Italianno-Regular"),
          ),
          centerTitle: true,
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Route route = MaterialPageRoute(
                        builder: (c) => CartPage(qr2: widget.qr1));
                    Navigator.push(context, route);
                  },
                ),
                Positioned(
                  child: Stack(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 20.0,
                        color: Colors.green,
                      ),
                      Positioned(
                        top: 3.0,
                        bottom: 4.0,
                        left: 4.0,
                        child: Consumer<CartItemCounter>(
                            builder: (context, counter, _) {
                          return Text(
                            (EcommerceApp.sharedPreferences
                                        .getStringList(
                                            EcommerceApp.userCartList)
                                        .length -
                                    1)
                                .toString(),
                            style: TextStyle(
                                color: Colors.white60,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Route route =
                  MaterialPageRoute(builder: (c) => StoreHome(qr: widget.qr1));
              Navigator.push(context, route);
            },
          ),
        ),
        //drawer: MyDrawer(),
        body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection("items")
                .where("pCategory", isEqualTo: widget.adi)
                .limit(15)
                .orderBy("publishedDate", descending: true)
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
                          builder: (c) => ProductPage(
                                resim: document['thumbnailUrl'],
                                adi: document['shortInfo'],
                                aciklama: document['longDescription'],
                                fiyat: document['price'],
                              ));
                      Navigator.push(context, route);
                    },
                    splashColor: Colors.deepPurple,
                    child: SingleChildScrollView(
                      //padding: EdgeInsets.all(6.0),
                      child: Container(
                        height: height / 5,
                        width: width,
                        child: Row(
                          children: [
                            Image.network(
                              document['thumbnailUrl'],
                              width: width / 3,
                              height: height / 1.5,
                            ),
                            SizedBox(
                              width: width / 70,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: height / 80,
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              document['shortInfo'],
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18.0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: height / 30,
                                  ),
                                  /*Container(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            document['longDescription'],
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 13.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: height/90,
                                  ),*/
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                      color: Colors.red,
                                                      fontSize: 16.0),
                                                ),
                                                Text(
                                                  (document['price'])
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                //Flexible(child:Container()),
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
                                      child: //removeCartFunction == null
                                          /*?*/ IconButton(
                                        icon: Icon(
                                          Icons.add_shopping_cart,
                                          color: Colors.deepOrangeAccent,
                                        ),
                                        onPressed: () {
                                          checkItemInCart(document['shortInfo'],
                                              context, widget.qr1);
                                        },
                                      )),

                                  Divider(
                                    height: height / 90,
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
                }).toList(),
              );
            }),
      ),
    );
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

void checkItemInCart(String shortInfoAsID, BuildContext context, String qr) {
  EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList)
          .contains(shortInfoAsID)
      ? Fluttertoast.showToast(msg: "Ürün zaten sepete eklendi.")
      : addItemToCart(shortInfoAsID, context, qr);
}

addItemToCart(String shortInfoAsID, BuildContext context, String qr) {
  List tempCartList =
      EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
  var ref = EcommerceApp.firestore.collection("qrcodes");
  ref.document(qr).get().then((DocumentSnapshot doc) {
    var product = doc.data['urunMiktari'];
    var productQuantity = doc.data["urunMiktari"]['$shortInfoAsID'];
    if (productQuantity == null) {
      productQuantity = 1;
    }
    List templist = [];
    product.forEach((k, v) => templist.add(QuantityModel(k, v)));
    templist.add(QuantityModel('$shortInfoAsID', productQuantity));
    var map2 = {};
    templist.forEach((product) => map2[product.name] = product.quantity);
    EcommerceApp.firestore
        .collection("qrcodes")
        .document(qr)
        .updateData({'urunMiktari': map2});
  });
  Firestore.instance.collection("qrcodes").getDocuments().then((snapshot) {
    snapshot.documents.forEach((i) {
      veri = i.data["qrId"];
      // Route route = MaterialPageRoute(
      //     builder: (c) => Payment(masaNo: result.code,));
      // Navigator.pushReplacement(context, route);
    });
  });
  print(veri);
  print(qr);

  print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
  print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
  print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
  print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
  tempCartList.add(shortInfoAsID);

  EcommerceApp.firestore.collection('qrcodes').document(qr).updateData({
    EcommerceApp.userCartList: tempCartList,
  }).then((v) {
    Fluttertoast.showToast(msg: "Ürün sepete başarıyla eklendi.");
    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, tempCartList);
    //userCart daki ürünlerin toplamını sayarak toplam değere ulaşıyor.
    Provider.of<CartItemCounter>(context, listen: false).displayResult();
  });
}
