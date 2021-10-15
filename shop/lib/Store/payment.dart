import 'dart:ui';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:e_shop/main.dart';
import '../main.dart';
import '../Models/creditcard.dart';
import 'package:e_shop/Counters/totalMoney.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

var masa1 = "";
var verii = "";
Map urun = {};

class Payment extends StatefulWidget {
  final String qr3;
  final double totalAmount;
  const Payment({Key key, this.totalAmount, this.qr3}) : super(key: key);
  @override
  _Payment createState() => _Payment();
}

class _Payment extends State<Payment>
    with AutomaticKeepAliveClientMixin<Payment> {
  MaskedTextController ccMask =
      MaskedTextController(mask: "0000 0000 0000 0000");
  bool get wantKeepAlive => true;
  final _formKey = GlobalKey<FormState>();
  final _user = CreditCard();
  double totalAmount;
  var _ratingController;
  var _yilController;

  /*EcommerceApp.firestore.collection('qrcodes').document(qr).get().then((DocumentSnapshot doc) {
  product = doc.data['imageUrl'];
  });*/
  getir1() {
    EcommerceApp.firestore
        .collection("qrcodes")
        .document(widget.qr3)
        .get()
        .then((ver) {
      masa1 = ver.data["imageUrl"];
      /*setState(() {
        masa1 = ver.data["imageUrl"];
      });*/
    });

    return masa1;
  }

  getir2() {
    Map mapUrun = {};
    EcommerceApp.firestore
        .collection("qrcodes")
        .document(widget.qr3)
        .get()
        .then((DocumentSnapshot doc) {
      urun = doc.data['urunMiktari'];
      urun.forEach((k, v) {
        mapUrun[k] = v;
      });
    });
    return mapUrun;
  }

  @override
  Widget build(BuildContext context) {
    var verii = getir1().toString();
    Map ver = getir2();
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.orange[400], Colors.orangeAccent],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Ödeme secenekleri",
          style: TextStyle(
              fontSize: 45.0,
              color: Colors.white,
              fontFamily: "Italianno-Regular"),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Route route = MaterialPageRoute(
                builder: (c) => CartPage(
                      qr2: widget.qr3,
                    ));
            Navigator.push(context, route);
          },
        ),
      ),
      body: Material(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /* Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  //padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Kart Bilgileri",
                    style: TextStyle(
                        letterSpacing: 1.0,
                        fontSize: 25,
                        color: Colors.grey[800]),
                  ),
                ),*/
                Container(
                  //color: Colors.blueGrey[50],
                  width: 400,
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 400,
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Kart Üzerindeki İsim",
                                  style: TextStyle(
                                      letterSpacing: 0.6,
                                      color: Colors.grey[800]),
                                ),
                              ),
                            ),
                            TextFormField(
                                enabled: nakitsePasifYap(),
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (_user.nakit == false) {
                                    //false ise
                                    if (value == null || value.isEmpty) {
                                      return 'Lütfen kart üzerindeki ismi giriniz';
                                    }
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Kart Üzerindeki İsim',
                                  border: OutlineInputBorder(
                                      //label: L
                                      borderRadius: BorderRadius.circular(3)),
                                ),
                                onSaved: (val) =>
                                    setState(() => _user.name = val)),
                          ],
                        ),
                      ),
                      Container(
                        width: 400,
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Kart Numarası",
                                  style: TextStyle(
                                      letterSpacing: 0.6,
                                      color: Colors.grey[800]),
                                ),
                              ),
                            ),
                            TextFormField(
                                enabled: nakitsePasifYap(),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (_user.nakit == false) {
                                    //false ise
                                    if (value == null || value.isEmpty) {
                                      return 'Lütfen kart numaranızı giriniz';
                                    }
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'XXXX XXXX XXXX XXXX',
                                  border: OutlineInputBorder(
                                      //label: L
                                      borderRadius: BorderRadius.circular(3)),
                                ),
                                controller: ccMask,
                                maxLength: 19,
                                onSaved: (val) =>
                                    setState(() => _user.number = val)),
                          ],
                        ),
                      ),
                      Container(
                        // color: Colors.blueGrey[50],
                        width: 400,
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            //Son Kullanma Tarihi Bölümü
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Son Kullanma Tarihi",
                                        style: TextStyle(
                                            letterSpacing: 0.6,
                                            color: Colors.grey[800]),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Flexible(
                                        child: DropdownButtonFormField<int>(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                          ),
                                          value: _ratingController,
                                          items: [
                                            01,
                                            02,
                                            03,
                                            04,
                                            05,
                                            06,
                                            07,
                                            08,
                                            09,
                                            10,
                                            11,
                                            12
                                          ]
                                              .map((label) => DropdownMenuItem(
                                                    child:
                                                        Text(label.toString()),
                                                    value: label,
                                                  ))
                                              .toList(),
                                          hint: Text('Ay'),
                                          onChanged: (value) {
                                            setState(() {
                                              _user.month = value;
                                            });
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      ),
                                      Flexible(
                                        child: DropdownButtonFormField<int>(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                          items: [
                                            21,
                                            22,
                                            23,
                                            24,
                                            25,
                                            26,
                                            27,
                                            28,
                                            29,
                                            30
                                          ]
                                              .map((label) => DropdownMenuItem(
                                                    child:
                                                        Text(label.toString()),
                                                    value: label,
                                                  ))
                                              .toList(),
                                          hint: Text('Yıl'),
                                          onChanged: (value) {
                                            setState(() {
                                              _user.year = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            //CVV Bölümü
                            Container(
                              margin: EdgeInsets.fromLTRB(25, 0, 0, 0),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "CVV",
                                        style: TextStyle(
                                            letterSpacing: 0.6,
                                            color: Colors.grey[800]),
                                      ),
                                    ),
                                  ),
                                  TextField(
                                      enabled: nakitsePasifYap(),
                                      keyboardType: TextInputType.number,
                                      autocorrect: true,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(3),
                                      ],
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(3)),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          _user.cvv = value;
                                        });
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  /* child: */
                ),
                /*
                TextFormField(
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                    decoration:
                    InputDecoration(labelText: 'Last name'),
                    // ignore: missing_return
                    validator: (value){
                      if (value.isEmpty) {
                        return 'Please enter your last name.';
                      }
                    },
                    onSaved: (val) =>
                        setState(() => _user.lastName = val)),*/
                Divider(
                    height: 30,
                    thickness: 2,
                    indent: 15,
                    endIndent: 15,
                    color: Colors.grey),
                /*   Container(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                  child: Text('Subscribe'),
                ),*/
                SwitchListTile(
                    activeColor: Colors.orange[800],
                    title: const Text('Nakit Öde'),
                    value: _user.nakit,
                    onChanged: (bool val) => setState(() => _user.nakit = val)),
                /*  Container(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                  child: Text('Interests'),
                ),
                CheckboxListTile(title: const Text('Cooking'),value: _user.passions[User.PassionCooking],
                    onChanged: (val) {setState(() =>
                      _user.passions[User.PassionCooking] = val);),
*/
                Divider(
                    height: 45,
                    thickness: 2,
                    indent: 15,
                    endIndent: 15,
                    color: Colors.grey),
                Container(
                  width: 400,
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Not Ekleyin",
                            style: TextStyle(
                                letterSpacing: 0.6, color: Colors.amber[800]),
                          ),
                        ),
                      ),
                      TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Not...',
                            border: OutlineInputBorder(
                                //label: L
                                borderRadius: BorderRadius.circular(3)),
                          ),
                          onSaved: (value) =>
                              setState(() => _user.message = value)),
                    ],
                  ),
                ),
                Center(
                  child: Text(
                    "Toplam Fiyat: ₺ ${widget.totalAmount.toString()}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      //fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      FormState form = _formKey.currentState;
                      if (form.validate()) {
                        //Gerekli bilgiler girilmeden bilgiler firebase e kaydedilmeyecek
                        /* ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('Processing Data')));*/
                        form.save();
                        addOrderDetails(widget.qr3, verii, ver);
                      }
                    },
                    color: Colors.orange,
                    child: Text(
                      'Ödemeyi Onayla',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  nakitsePasifYap() {
    if (_user.nakit == true) {
      return false;
    }
  }

  addOrderDetails(String qr, String m, Map ver) {
    writeOrderDetailsForAdmin({
      // EcommerceApp.addressID: widget.addressId,
      // EcommerceApp.totalAmount: widget.totalAmount,
      "orderBy":
          m, // EcommerceApp.sharedPreferences.getString(EcommerceApp.qrId),
      EcommerceApp.productID: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList),
      "urunMiktari": ver,
      //EcommerceApp.paymentDetails: "Kapıda Ödeme",
      EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EcommerceApp.orderDate: DateTime.now().toString(),
      EcommerceApp.CardOwnerName: _user.name,
      EcommerceApp.CardNumber: _user.number,
      EcommerceApp.isCash: _user.nakit,
      EcommerceApp.CVV: _user.cvv,
      EcommerceApp.CardDate:
          _user.month.toString() + '/' + _user.year.toString(),
      EcommerceApp.isSuccess: true,
      EcommerceApp.totalAmount: widget.totalAmount,
      EcommerceApp.message: _user.message,
    }).whenComplete(() => {emptyCartNow(qr)});
  }

  emptyCartNow(String qr) {
    EcommerceApp.firestore.collection('qrcodes').document(qr).updateData({
      EcommerceApp.urunMiktari: {},
    });
    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ["garbageValue"]);
    List tempList =
        EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
    Firestore.instance.collection("qrcodes").document(qr).updateData({
      EcommerceApp.userCartList: tempList,
    }).then((value) {
      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, tempList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });
    Fluttertoast.showToast(msg: "Siparişiniz Alımıştır");

    Route route = MaterialPageRoute(builder: (_) => StoreHome(qr: widget.qr3));
    Navigator.pushReplacement(context, route);
  }

  /*Future writeOrderDetailsForUser(Map<String, dynamic> data) async {
    await EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.qrId))
        .collection(EcommerceApp.collectionOrders)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.qrId) +
                data['orderTime'])
        .setData(data);
  }*/

  Future writeOrderDetailsForAdmin(Map<String, dynamic> data) async {
    await EcommerceApp.firestore
        .collection(EcommerceApp.collectionOrders)
        //.document(data['orderBy'])
        //.document(EcommerceApp.sharedPreferences.getString(EcommerceApp.qrId) +
        //   data['orderTime'])
        .document(data['orderBy'] + " - " + data['orderDate'])
        .setData(data);
  }
}
