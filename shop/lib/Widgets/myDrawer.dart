import 'package:e_shop/AR/ar.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';

import 'package:e_shop/Store/cart.dart';

import 'package:e_shop/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bottomNavigationBar.dart';

var masa = "";

/*class MyDrawer extends StatefulWidget {
  final String qr;
  MyDrawer({this.qr});
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<_MyDrawer>*/
class MyDrawer extends StatefulWidget {
  final String qr;
  //const StoreHome({Key key}) : super(key: key);
  MyDrawer({Key key, this.qr}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  getir() {
    EcommerceApp.firestore
        .collection("qrcodes")
        .document(widget.qr)
        .get()
        .then((veri) {
      setState(() {
        masa = veri.data["imageUrl"];
      });
    });

    return masa;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.orange, Colors.orange],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              children: [
                Text(
                  getir().toString(),
                  style: TextStyle(
                      fontSize: 35.0,
                      color: Colors.white,
                      fontFamily: "Signatra"),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          Container(
            padding: EdgeInsets.only(top: 1.0),
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.lightGreen, Colors.lightGreen],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.workspaces_filled,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Artırılmış Gerçeklik Uygulaması",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => Ar(qr5: widget.qr));
                    Navigator.push(context, route);
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Çıkış Yap",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    emptyCartNow(widget.qr);
                    //EcommerceApp.auth.signOut().then((c) {
                    Route route =
                        MaterialPageRoute(builder: (c) => AuthenticScreen());
                    Navigator.pushReplacement(context, route);
                    //});
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

emptyCartNow(String qr) {
  EcommerceApp.firestore.collection('qrcodes').document(qr).updateData({
    EcommerceApp.urunMiktari: {},
  });
  EcommerceApp.sharedPreferences
      .setStringList(EcommerceApp.userCartList, ["garbageValue"]);
  List tempList =
      EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
  EcommerceApp.firestore.collection('qrcodes').document(qr).updateData({
    EcommerceApp.userCartList: tempList,
  });
  /*Fluttertoast.showToast(msg: "Siparişiniz Alımıştır");

  Route route = MaterialPageRoute(builder: (_) => SplashScreen());
  Navigator.pushReplacement(context, route);*/
}
/*import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Address/addAddress.dart';
import 'package:e_shop/Store/Search.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Orders/myOrders.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bottomNavigationBar.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.orange, Colors.orange],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              children: [
                Text(
                  EcommerceApp.sharedPreferences.getString(EcommerceApp.imageURL),
                  style: TextStyle(
                      color: Colors.white60,
                      fontSize: 35.0,
                      fontFamily: "Signatra"),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          Container(
            padding: EdgeInsets.only(top: 1.0),
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.lightGreen, Colors.lightGreen],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Ana Sayfa",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => StoreHome());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.reorder,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Siparişlerim",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(builder: (c) => MyOrders());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Sepetim",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(builder: (c) => CartPage());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Çıkış Yap",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    //EcommerceApp.auth.signOut().then((c) {
                      Route route =
                          MaterialPageRoute(builder: (c) => AuthenticScreen());
                      Navigator.pushReplacement(context, route);
                    //});
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/
