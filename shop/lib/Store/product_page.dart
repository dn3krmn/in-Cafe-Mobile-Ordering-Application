import 'package:e_shop/Store/products.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:e_shop/Models/item.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/Store/storehome.dart';

class ProductPage extends StatefulWidget {
  final String resim;
  final String adi;
  final String aciklama;
  final int fiyat;

  ProductPage({this.resim,this.adi,this.aciklama,this.fiyat});
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  //int quantityOfItems = 1;
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
    ), centerTitle: true,
    title: Text(widget.adi,
    style: TextStyle(
    fontSize: 45.0, color: Colors.white, fontFamily: "Italianno-Regular"),
    ),),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(15.0),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      // Center(child: Image.network(widget.itemModel.thumbnailUrl)),
                      Container(
                        color: Colors.grey[300],
                        child: SizedBox(
                          height: 1.0,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            widget.resim,
                          ),
                          SizedBox(
                            width: 4.0,
                            height: 15,
                          ),

                          Text(
                            widget.adi,
                            style: boldTextStyle,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            widget.aciklama,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13.0),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(widget.fiyat.toString()+"₺",
                            style: boldTextStyle,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  /*Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Center(
                      child: InkWell(
                        //onTap: () => addItemToCart(widget.itemModel.shortInfo, context),
                        child: Container(
                          decoration: new BoxDecoration(
                            gradient: new LinearGradient(
                              colors: [Colors.orange, Colors.white60],
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(1.0, 0.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp,
                            ),
                          ),
                          width: MediaQuery.of(context).size.width - 40.0,
                          height: 50.0,

                        ),
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);

