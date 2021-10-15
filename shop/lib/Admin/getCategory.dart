import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Config/config.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

double width;

class GetCategory extends StatefulWidget {
  const GetCategory({Key key}) : super(key: key);
  @override
  _GetCategoryState createState() => _GetCategoryState();
}

class _GetCategoryState extends State<GetCategory> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
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
          "Kategoriler",
          style: TextStyle(
              fontSize: 40.0, color: Colors.white, fontFamily: "Signatra"),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection("Category")
            .orderBy("publishedDate", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Text("Veri yok");
          }
          return ListView(
            children: snapshot.data.documents.map((document) {
              //return new Text(document['name'] );
              return InkWell(
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
                                height: 10.0,
                              ),
                              Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        document['name'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0),
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
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.deepOrangeAccent,
                                  ),
                                  onPressed: () {
                                    deleteCategory(
                                        context,
                                        document['categoryId'],
                                        document['name']);
                                  },
                                ),
                              ),
                              //to implement the cart item add/remove feature

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
        },
      ),
    );
  }

  deleteCategory(BuildContext context, String category, String name) {
    EcommerceApp.firestore.collection('Category').document(category).delete();

    Route route = MaterialPageRoute(builder: (c) => GetCategory());
    Navigator.pushReplacement(context, route);

    Fluttertoast.showToast(msg: name + " silindi.");
  }
}
