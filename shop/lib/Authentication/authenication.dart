import 'package:e_shop/Admin/adminLogin.dart';
import 'package:flutter/material.dart';
import 'ReadQr.dart';
import 'package:e_shop/Config/config.dart';

class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.orange.shade400, Colors.orange.shade50],
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
                fontSize: 55.0,
                color: Colors.white,
                fontFamily: "Italianno-Regular"),
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.lock_rounded,
                  color: Colors.white,
                ),
                text: "QR Kod ile Giriş",
              ),
              Tab(
                icon: Icon(
                  Icons.perm_contact_calendar,
                  color: Colors.white,
                ),
                text: "Yönetici Girişi",
              ),
            ],
            indicatorColor: Colors.white38,
            indicatorWeight: 5.0,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.black12, Colors.white60],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: TabBarView(
            children: [
              ReadQr(),
              AdminSignInScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
