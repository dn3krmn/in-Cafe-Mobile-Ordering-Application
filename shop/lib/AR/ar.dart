/*import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter AR',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HelloWorld(),
    );
  }
}

class HelloWorld extends StatefulWidget {
  @override
  _HelloWorldState createState() => _HelloWorldState();
}

class _HelloWorldState extends State<HelloWorld> {
  ArCoreController arCoreController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Hello World'),
        ),
        body: ArCoreView(
          onArCoreViewCreated: _onArCoreViewCreated,
        ),
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;

    _addSphere(arCoreController);
    _addCylindre(arCoreController);
    _addCube(arCoreController);
  }

  void _addSphere(ArCoreController controller) {
    final material = ArCoreMaterial(
        color: Color.fromARGB(120, 66, 134, 244));
    final sphere = ArCoreSphere(
      materials: [material],
      radius: 0.1,
    );
    final node = ArCoreNode(
      shape: sphere,
      position: vector.Vector3(0, 0, -1.5),
    );
    controller.addArCoreNode(node);
  }

  void _addCylindre(ArCoreController controller) {
    final material = ArCoreMaterial(
      color: Colors.red,
      reflectance: 1.0,
    );
    final cylindre = ArCoreCylinder(
      materials: [material],
      radius: 0.5,
      height: 0.3,
    );
    final node = ArCoreNode(
      shape: cylindre,
      position: vector.Vector3(0.0, -0.5, -2.0),
    );
    controller.addArCoreNode(node);
  }

  void _addCube(ArCoreController controller) {
    final material = ArCoreMaterial(
      color: Color.fromARGB(120, 66, 134, 244),
      metallic: 1.0,
    );
    final cube = ArCoreCube(
      materials: [material],
      size: vector.Vector3(0.5, 0.5, 0.5),
    );
    final node = ArCoreNode(
      shape: cube,
      position: vector.Vector3(-0.5, 0.5, -3.5),
    );
    controller.addArCoreNode(node);
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }
}*/
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:flutter/material.dart';
//import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';

//import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:e_shop/Widgets/bottomNavigationBar.dart';
import 'donut.dart';
import 'hamburger.dart';

class Ar extends StatefulWidget {
  final String qr5;
  final String title;
  Ar({Key key, this.title, this.qr5}) : super(key: key);

  @override
  _ArState createState() => _ArState();
}

class _ArState extends State<Ar> {
  /*ArCoreController arCoreController;

  _onArCoreViewCreated(ArCoreController _arcoreController) {
    arCoreController = _arcoreController;
    _addSphere(arCoreController);
    _addCube(arCoreController);
    _addCyclinder(arCoreController);
  }

  _addSphere(ArCoreController _arcoreController) {
    final material = ArCoreMaterial(color: Colors.deepPurple);
    final sphere = ArCoreSphere(materials: [material], radius: 0.2);
    final node = ArCoreNode(
      shape: sphere,
      position: vector.Vector3(
        0,
        0,
        -1,
      ),
    );

    _arcoreController.addArCoreNode(node);
  }

  _addCyclinder(ArCoreController _arcoreController) {
    final material = ArCoreMaterial(color: Colors.green, reflectance: 1);
    final cylinder =
    ArCoreCylinder(materials: [material], radius: 0.4, height: 0.3);
    final node = ArCoreNode(
      shape: cylinder,
      position: vector.Vector3(
        0,
        -2.5,
        -3.0,
      ),
    );

    _arcoreController.addArCoreNode(node);
  }

  _addCube(ArCoreController _arcoreController) {
    final material = ArCoreMaterial(color: Colors.pink, metallic: 1);
    final cube =
    ArCoreCube(materials: [material], size: vector.Vector3(1, 1, 1));
    final node = ArCoreNode(
      shape: cube,
      position: vector.Vector3(
        -0.5,
        -0.5,
        -3,
      ),
    );

    _arcoreController.addArCoreNode(node);
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.orange, Colors.white60],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          "Artırılmış Gerçeklik",
          style: TextStyle(
              fontSize: 50.0,
              color: Colors.white,
              fontFamily: "Italianno-Regular"),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Route route = MaterialPageRoute(
                builder: (c) => StoreHome(
                      qr: widget.qr5,
                    ));
            Navigator.push(context, route);
          },
        ),
      ),
      body: Center(
        // ignore: deprecated_member_use
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // ignore: deprecated_member_use
              Container(
                //margin: EdgeInsets.only(top: 50, right: 10),
                height: 60,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: Colors.orangeAccent.shade100,
                ),
                child: FlatButton(
                    child: Text("Donut için tıklayınız"),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Deneme()));
                    }),
              ),
              // ignore: deprecated_member_use
              Container(
                margin: EdgeInsets.only(top: 50),
                height: 60,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: Colors.orangeAccent.shade100,
                ),
                child: FlatButton(
                    child: Text("Hamburger için tıklayınız"),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Hamburger()));
                    }),
              ),
            ]),
      ),
    );
  }
}
