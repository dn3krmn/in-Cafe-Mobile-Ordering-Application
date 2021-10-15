import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Config/config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GetQr extends StatefulWidget {
  @override
  _GetQrState createState() => _GetQrState();
}

double width;

class _GetQrState extends State<GetQr> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "Masalar",
          style: TextStyle(
              fontSize: 40.0, color: Colors.white, fontFamily: "Signatra"),
        )),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => UploadPage());
            Navigator.pushReplacement(context, route);
          },
        ),
        backgroundColor: Colors.blue[400],
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection("qrcodes").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Text("Masa yok");
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
                                        document['imageUrl'],
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
                                    deleteKarekod(context, document['qrId'],
                                        document['imageUrl']);
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

  deleteKarekod(BuildContext context, String qrcode, String name) {
    EcommerceApp.firestore.collection('qrcodes').document(qrcode).delete();

    Route route = MaterialPageRoute(builder: (c) => GetQr());
    Navigator.pushReplacement(context, route);

    Fluttertoast.showToast(msg: name + " silindi.");
  }
}

/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:flutter/material.dart';

class GetQr extends StatefulWidget {
  @override
  _GetQrState createState() => _GetQrState();
}

double width;

class _GetQrState extends State<GetQr> {
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
          "Masalar",
          style: TextStyle(
              fontSize: 40.0, color: Colors.white, fontFamily: "Signatra"),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection("qrcodes")
            .orderBy("imageUrl", descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Text("Masa yok");
          }
          return ListView(
            children: snapshot.data.documents.map((document) {
              return InkWell(
                splashColor: Colors.blue[400].withOpacity(0.5),
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Container(
                    height: 50,
                    width: width/2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            alignment: Alignment.center,
                            height: 50,
                            width: width/1.5,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(
                                left: 0, top: 0, right: 0, bottom: 0),
                            child: Text(
                              (document['imageUrl']).toString(),
                              style:
                              TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            //decoration: ,
                            color: Colors.blue.shade300),
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
}*/
