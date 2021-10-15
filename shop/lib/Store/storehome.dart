import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Models/category.dart';

import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Widgets/bottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Models/item.dart';
import 'products.dart';

double width;
double height;

class StoreHome extends StatefulWidget {
  final String qr;
  //const StoreHome({Key key, this.qr}) : super(key: key);
  StoreHome({Key key, this.qr}) : super(key: key);
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
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
            "Lavinya",
            style: TextStyle(
                fontSize: 50.0,
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
                        builder: (c) => CartPage(qr2: widget.qr));
                    Navigator.pushReplacement(context, route);
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
        ),
        drawer: MyDrawer(qr: widget.qr),
        body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection("Category")
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
                  //return new Text(document['name'] );
                  return InkWell(
                    onTap: () {
                      Route route = MaterialPageRoute(
                          builder: (c) => Products(
                                adi: document['name'],
                                qr1: widget.qr,
                              ));
                      Navigator.push(context, route);
                    },
                    splashColor: Colors.deepPurple,
                    child: Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Container(
                        height: 190.0,
                        width: width,
                        child: Row(
                          children: [
                            Image.network(
                              document['thumbnailUrl'],
                              width: 150.0,
                              height: 150.0,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: height / 9,
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              document['name'],
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16.0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),

                                  Flexible(
                                    child: Container(),
                                  ),

                                  //to implement the cart item add/remove feature
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
                }).toList(),
              );
            }),
      ),
    );
  }
}

/*Widget sourceInfo(CategoryModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: () {
      Route route =
          MaterialPageRoute(builder: (c) => Products(adi: model.name));
      Navigator.push(context, route);
    },
    splashColor: Colors.deepPurple,
    child: Padding(
      padding: EdgeInsets.all(6.0),
      child: Container(
        height: 190.0,
        width: width,
        child: Row(
          children: [
            Image.network(
              model.thumbnailUrl,
              width: 150.0,
              height: 150.0,
            ),
            SizedBox(
              width: 5.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            model.name,
                            style:
                                TextStyle(color: Colors.black, fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),

                  Flexible(
                    child: Container(),
                  ),

                  //to implement the cart item add/remove feature
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
}


*/
