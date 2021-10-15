import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'Counters/ItemQuantity.dart';
import 'Counters/cartitemcounter.dart';
import 'Counters/totalMoney.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = Firestore.instance;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => CartItemCounter()),
        //ChangeNotifierProvider(create: (c) => ItemQuantity()),
        ChangeNotifierProvider(create: (c) => TotalAmount()),
      ],
      child: MaterialApp(
          title: 'Lavinya',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.white,
          ),
          home: SplashScreen()),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    displaySplash();
  }

  displaySplash() {
    Timer(Duration(seconds: 7), () async {
      Route route = MaterialPageRoute(builder: (_) => AuthenticScreen());
      Navigator.push(context, route);
      /*
      if (await EcommerceApp.auth.currentUser() != null) {
        Route route = MaterialPageRoute(builder: (_) => NavigationBar());
        Navigator.push(context, route);
        // StoreHome();
      } else {
        Route route = MaterialPageRoute(builder: (_) => AuthenticScreen());
        Navigator.push(context, route);
      }*/
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "images/welcome.png",
                width: 280,
                height: 280,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Lavinya'ya Hosgeldiniz",
                style: TextStyle(
                    color: Colors.lightGreen,
                    fontSize: 55.0,
                    fontFamily: "Italianno-Regular"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
