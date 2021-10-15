import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Counters/totalMoney.dart';
//import 'package:e_shop/Models/QRModel.dart';
import 'package:e_shop/Models/cartModel.dart';
import 'package:e_shop/Models/quantityModel.dart';
import 'package:e_shop/Store/payment.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/appbar.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:e_shop/Store/products.dart';
import 'package:provider/provider.dart';
import '../main.dart';
//import

double width;
double height;
int q = 0;
var verii;
var miktar = 0;
double sum = 0;

class CartPage extends StatefulWidget {
  final String qr2;

  CartPage({this.qr2});
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double totalAmount;

  @override
  void initState() {
    super.initState();
    totalAmount = 0;
    setState(() {
      Provider.of<TotalAmount>(context, listen: false).display(0);
    });
  }

  getir1(String shortInfoAsId) {
    EcommerceApp.firestore
        .collection("qrcodes")
        .document(widget.qr2)
        .get()
        .then((DocumentSnapshot doc) {
      setState(() {
        miktar = doc.data["urunMiktari"]['$shortInfoAsId'];
      });
    });

    return miktar;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: SizedBox(
        width: width / 2.3,
        height: height / 20,
        child: FloatingActionButton.extended(
          onPressed: () {
            if (EcommerceApp.sharedPreferences
                    .getStringList(EcommerceApp.userCartList)
                    .length ==
                1) {
              Fluttertoast.showToast(msg: "Sepetinizde ürün bulunmamaktadır.");
            } else {
              Route route = MaterialPageRoute(
                  builder: (c) =>
                      Payment(totalAmount: totalAmount, qr3: widget.qr2));
              Navigator.push(context, route);
            }
          },
          label: Text(
            "Sepeti Onayla",
            style: TextStyle(
                color: Colors.white,
                fontSize: width / 25,
                fontWeight: FontWeight.w500),
          ),
          backgroundColor: Colors.amberAccent,
          icon: Icon(Icons.navigate_next),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: MyAppBarCart(qr4: widget.qr2),
      //drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(
              builder: (context, amountProvider, cartProvider, c) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: cartProvider.count == 0
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              child: Text(
                                "Toplam Fiyat: ₺ ${amountProvider.totalAmount.toString()}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
          /* StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection("qrcodes")
                .where("imageUrl", isEqualTo: widget.qr2)
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ?Text("Böyle Bir Masa Yok")
                  : ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (c, index) {
                    return FutureBuilder<QuerySnapshot>(
                        future: Firestore.instance
                          .collection("items")
                          .where("shortInfo",
                          whereIn: snapshot.data.documents[index]
                              .data[EcommerceApp.userCartList])
                          .getDocuments(),
                        builder: (c, snap) {
                          return  !snap.hasData
                          ? SliverToBoxAdapter(
                            child: Center(
                              child: circularProgress(),
                              ),
                              )
                                  : snap.data.documents.length == 0
                                  ? beginbuildingCart(widget.qr2)
                          : SliverList(
                          delegate: SliverChildBuilderDelegate(
                          (context, index) {
                           ItemModel model = ItemModel.fromJson(
                          snap.data.documents[index].data);
                           print(index);
                          if (index == 0) {
                          totalAmount = 0;
                          totalAmount = model.price + totalAmount;
                          } else {
                          totalAmount = model.price + totalAmount;
                          }

                          if (snap.data.documents.length - 1 == index) {
                          WidgetsBinding.instance
                              .addPostFrameCallback((t) {
                          Provider.of<TotalAmount>(context,
                          listen: false)
                              .display(totalAmount);
                          });
                          }
                            return sourceInfoo(model,context, widget.qr2,
                            removeCartFunction: () =>
                            removeItemFromUserCart(
                            model.shortInfo, widget.qr2));
                            },
                            childCount: snap.hasData
                            ? snap.data.documents.length
                                : 0,
                            ),
                            );
                            },

                      );
                },
              );
            },
          ),*/
          StreamBuilder<QuerySnapshot>(
            stream: EcommerceApp.firestore
                .collection("items")
                .where("shortInfo",
                    whereIn: EcommerceApp.sharedPreferences
                        .getStringList(EcommerceApp.userCartList))
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : snapshot.data.documents.length == 0
                      ? beginbuildingCart(widget.qr2, totalAmount)
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              ItemModel model = ItemModel.fromJson(
                                  snapshot.data.documents[index].data);
                              EcommerceApp.firestore
                                  .collection("qrcodes")
                                  .document(widget.qr2)
                                  .get()
                                  .then((DocumentSnapshot doc) {
                                var p =
                                    doc.data["urunMiktari"][model.shortInfo];
                                if (index == 0) {
                                  totalAmount = 0;
                                  totalAmount = (model.price * p) + totalAmount;
                                } else {
                                  totalAmount = (model.price * p) + totalAmount;
                                }
                                //QuantityModel qmodel= QuantityModel.fromJson(snapshot.data.documents[index].data);
                                if (snapshot.data.documents.length - 1 ==
                                    index) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((t) {
                                    Provider.of<TotalAmount>(context,
                                            listen: false)
                                        .display(totalAmount);
                                  });
                                }
                              });
                              return StreamBuilder(
                                  stream: EcommerceApp.firestore
                                      .collection("qrcodes")
                                      .document(widget.qr2)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    print(totalAmount);
                                    print("totalAmount");

                                    return !snapshot.hasData
                                        ? Center(
                                            child: circularProgress(),
                                          )
                                        : sourceInfoo(
                                            model,
                                            context,
                                            widget.qr2,
                                            snapshot.data["urunMiktari"]
                                                [model.shortInfo], // quantity,
                                            removeCartFunction: () =>
                                                removeItemFromUserCart(
                                                    model.shortInfo,
                                                    widget.qr2));
                                  });
                            },
                            childCount: snapshot.hasData
                                ? snapshot.data.documents.length
                                : 0,
                          ),
                        );
            },
          ),
          /* StreamBuilder<QuerySnapshot>(
             stream: EcommerceApp.firestore
            .collection("qrcodes")
            .where("imageUrl", isEqualTo: widget.qr2)
            .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                    child: Center(
                  child: circularProgress(),
                ),
              )
                  : snapshot.data.documents.length == 0
                  ? beginbuildingCart(widget.qr2)
                  : SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                  CartModel cmodel = CartModel.fromJson(snapshot.data.documents[index].data);
                  return increaseDecrease(cmodel,);
                },
                  childCount: snapshot.hasData
                      ? snapshot.data.documents.length
                      : 0,
                ),
              );
            },
          ),*/
        ],
      ),
    );
  }

  Widget sourceInfoo(
      ItemModel model, BuildContext context, String qr, int cmodel,
      {Color background, removeCartFunction}) {
    width = MediaQuery.of(context).size.width;
    //var verii = getir1(model.shortInfo).toString();
    return InkWell(
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
                width: width / 50,
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
                            child: Center(
                              child: Text(
                                model.shortInfo,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
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
                                    (model.price).toString(),
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "₺ ",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 16.0),
                                  ),
                                  SizedBox(
                                    width: 170.0,
                                    height: 41.0,
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(30, 2, 2, 2),
                                      decoration: BoxDecoration(
                                          color: Color(0xddFFFFFF),
                                          border: Border.all(
                                              color: Colors.orange, width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(55.0)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          GestureDetector(
                                              onTap: () {
                                                checkQuantityFromFirebase(
                                                    model.shortInfo,
                                                    2,
                                                    context,
                                                    qr,
                                                    model.price);
                                                totalAmount -= (model.price);
                                                Provider.of<TotalAmount>(
                                                        context,
                                                        listen: false)
                                                    .display(totalAmount);
                                              },
                                              child: Container(
                                                  width: 15.0,
                                                  child: Center(
                                                      child: Text(
                                                    '-',
                                                    style: TextStyle(
                                                        fontSize: 21.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.orange,
                                                        decoration:
                                                            TextDecoration
                                                                .none),
                                                  )))),
                                          Container(
                                            child: Center(
                                                child: Text(
                                              cmodel.toString(),
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange,
                                                  decoration:
                                                      TextDecoration.none),
                                            )),
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                checkQuantityFromFirebase(
                                                    model.shortInfo,
                                                    1,
                                                    context,
                                                    qr,
                                                    model.price);
                                                totalAmount += (model.price);
                                                Provider.of<TotalAmount>(
                                                        context,
                                                        listen: false)
                                                    .display(totalAmount);
                                              },
                                              child: Container(
                                                  width: 15.0,
                                                  child: Center(
                                                      child: Text(
                                                    '+',
                                                    style: TextStyle(
                                                        fontSize: 21.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.orange,
                                                        decoration:
                                                            TextDecoration
                                                                .none),
                                                  ))))
                                        ],
                                      ),
                                    ),
                                  ),
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
                                Route route = MaterialPageRoute(
                                    builder: (c) => CartPage(qr2: widget.qr2));
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
  }

  beginbuildingCart(String qr2, double totalAmount) {
    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).display(0);
    return SliverToBoxAdapter(
      child: Card(
        //color: Theme.of(context).primaryColor.withOpacity(0.5),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.insert_emoticon,
                color: Colors.white,
              ),
              Text("Sepetinizde ürün bulunmamaktadır."),
              Text("Sepete ürün ekleyebilirsiniz."),
              Padding(
                padding: EdgeInsets.only(top: 200.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0)),
                  child: Text(
                    "Alışverişe Devam Et",
                    style: TextStyle(fontSize: 25.0, color: Colors.white),
                  ),
                  color: Colors.amberAccent,
                  onPressed: () {
                    Route route = MaterialPageRoute(
                        builder: (c) => StoreHome(
                              qr: widget.qr2,
                            ));
                    Navigator.pushReplacement(context, route);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  removeItemFromUserCart(String shortInfoAsId, String qr2) {
    List tempCartList =
        EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
    tempCartList.remove(shortInfoAsId);
    var ref = EcommerceApp.firestore.collection("qrcodes");
    ref.document(qr2).get().then((DocumentSnapshot doc) {
      var product = doc.data['urunMiktari'];
      List templist = [];
      product.forEach((k, v) => templist.add(QuantityModel(k, v)));
      var map2 = {};
      templist.forEach((product) => map2[product.name] = product.quantity);
      map2.remove('$shortInfoAsId');
      EcommerceApp.firestore
          .collection("qrcodes")
          .document(qr2)
          .updateData({'urunMiktari': map2});
    });
    EcommerceApp.firestore.collection('qrcodes').document(qr2).updateData({
      EcommerceApp.userCartList: tempCartList,
    }).then((v) {
      Fluttertoast.showToast(msg: "Ürün sepetten silindi!");
      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, tempCartList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
      Route route = MaterialPageRoute(builder: (c) => CartPage(qr2: qr2));
      Navigator.push(context, route);
      //totalAmount = 0;
    });
  }

  checkQuantityFromFirebase(String shortInfoAsId, int button,
      BuildContext context, String qr, int price) {
    //Verileri almamızı sağlıyor
    var ref = EcommerceApp.firestore.collection("qrcodes");
    ref.document(qr).get().then((DocumentSnapshot doc) {
      var product = doc.data['urunMiktari'];
      var productQuantity = doc.data["urunMiktari"]['$shortInfoAsId'];

      if (productQuantity == null) {
        productQuantity = 0;
      }
      if (button == 1) {
        ++productQuantity;
        writeProductQuantityToFirestore(
            product, productQuantity, shortInfoAsId, qr);
      } else if (button == 2) {
        if (productQuantity < 1 || productQuantity == -1) {
          productQuantity = 1;
        }
        --productQuantity;

        writeProductQuantityToFirestore(
            product, productQuantity, shortInfoAsId, qr);
      }
      if (productQuantity == 0) {
        removeItemFromUserCart(shortInfoAsId, qr);
      }
    });
  }

  writeProductQuantityToFirestore(
      product, int productQuantity, String shortInfoAsId, String qr) {
    //Verileri firebase e yazabilmek için önce bir listeye dönüştürüp içine verimizi ekliyoruz.
    //Sonrasında o listeyi map e çeviriyoruz ve firebase e kaydediyoruz.
    //Böylece sepete eklenen veri firebase e aktarılmış oluyor.
    List templist = [];
    //map i list e dönüştürüyoruz
    product.forEach((k, v) => templist.add(QuantityModel(k, v)));
    //list in içine veriyi ekliyoruz
    templist.add(QuantityModel('$shortInfoAsId', productQuantity));
    var map2 = {};
    //list i map e dönüştürüyoruz
    templist.forEach((product) => map2[product.name] = product.quantity);
    //Yeni verinin eklendiği map i firebase e yüklüyoruz.
    EcommerceApp.firestore
        .collection("qrcodes")
        .document(qr)
        .updateData({'urunMiktari': map2});

    // EcommerceApp.firestore.collection("qrcodes").document(qr).updateData({"toplamTutar":toplamFiyat});
  }
}
