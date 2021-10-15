import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Store/products.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bottomNavigationBar.dart';

class MyAppBarCart extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget bottom;
  final String qr4;
  MyAppBarCart({this.bottom, this.qr4});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
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
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Route route =
              MaterialPageRoute(builder: (c) => StoreHome(qr: qr4)); ////
          Navigator.push(context, route);
        },
      ),
      title: Text(
        "Sepet",
        style: TextStyle(
            fontSize: 50.0,
            color: Colors.white,
            fontFamily: "Italianno-Regular"),
      ),
      bottom: bottom,
    );
  }

  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}
