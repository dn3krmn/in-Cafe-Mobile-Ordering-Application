import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Store/products.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bottomNavigationBar.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget bottom;
  final String qr4;
  MyAppBar({this.bottom, this.qr4});

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
      actions: [
        Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => CartPage());
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
                                    .getStringList(EcommerceApp.userCartList)
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
    );
  }

  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}
