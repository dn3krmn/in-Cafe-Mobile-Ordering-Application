import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Config/config.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

double width;
double height;
String shortInfoAsId = "";

class GetProduct extends StatelessWidget {
  final String shortInfo;
  GetProduct({Key key, this.shortInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    shortInfoAsId = shortInfo;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.blue[400], Colors.blue[400]],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => UploadPage());
            Navigator.push(context, route);
          },
        ),
        title: Text(
          "Ürünler",
          style: TextStyle(
              fontSize: 40.0, color: Colors.white, fontFamily: "Italianno-Regular"),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection("items").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Text("Ürün yok");
          }
          return ListView(
            children: snapshot.data.documents.map((document) {
              return InkWell(
                /* onTap: () {
                  deleteProduct(context, shortInfoAsId);
                },*/
                /*onTap: () {
                      Route route =
                      MaterialPageRoute(builder: (c) => ProductPage(/*itemModel: */));
                      Navigator.push(context, route);
                    },*/
                splashColor: Colors.deepPurple,
                child: SingleChildScrollView(
                  //padding: EdgeInsets.all(6.0),
                  child: Container(
                    height: height/3.5,
                    width: width,
                    child: Row(
                      children: [
                        Image.network(
                          document['thumbnailUrl'],
                          width: width/3,
                          height: height/1.5,
                        ),
                        SizedBox(
                          width: width/100,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: height/50,
                              ),
                              Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        document['shortInfo'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height/80,
                              ),
                              Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        document['longDescription'],
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height/90,
                              ),

                              Flexible(
                                child: Container(),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.deepOrangeAccent,
                                  ),
                                  onPressed: () {
                                    deleteProduct(
                                        context,
                                        document['productId'],
                                        document['shortInfo']);
                                  },
                                ),
                              ),
                              //to implement the cart item add/remove feature

                              Divider(
                                height: height/90,
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
        },
      ),
    );
  }

  deleteProduct(BuildContext context, String product, String name) {
    EcommerceApp.firestore.collection('items').document(product).delete();

    Route route = MaterialPageRoute(builder: (c) => GetProduct());
    Navigator.pushReplacement(context, route);

    Fluttertoast.showToast(msg: name + " silindi");
  }
}
