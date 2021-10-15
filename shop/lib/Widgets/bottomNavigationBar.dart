/*import 'package:e_shop/AR/ar.dart';
import 'package:e_shop/Account/myaccount.dart';
import 'package:e_shop/Orders/myOrders.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:flutter/material.dart';

class NavigationBar extends StatefulWidget {
  final String qr1;
  NavigationBar({this.qr1});
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int _currentIndex = 0;

  final List<Widget> pages = [
    StoreHome(),
    MyOrders(),
    CartPage(),
    MyAccount(),
    MyApp(),
  ];

  //static get qr1 => widget.qr1;
  void tapped(int index) {
    setState(() {
      //toreHome(qr);S
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
            backgroundColor: Colors.amberAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Kategoriler',
            backgroundColor: Colors.amberAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Sepetim',
            backgroundColor: Colors.amberAccent,
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Hesabım',
              backgroundColor: Colors.amberAccent),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'AR',
            backgroundColor: Colors.amberAccent,
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.amber[800],
        onTap: tapped,
      ),
    );
  }
}
*/
