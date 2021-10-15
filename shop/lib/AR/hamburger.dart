import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class Hamburger extends StatefulWidget {
  Hamburger({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HamburgerState createState() => _HamburgerState();
}

class _HamburgerState extends State<Hamburger> {
  ArCoreController arCoreController;

  _onArCoreViewCreated(ArCoreController _arcoreController) {
    arCoreController = _arcoreController;
    /*_addToon(arCoreController);
    _addSphere(arCoreController);
    _addCube(arCoreController);
    _addCyclinder(arCoreController);*/
    _addHamburger(arCoreController);
  }

  _addHamburger(ArCoreController controller) {
    final node = ArCoreReferenceNode(
      name: 'Hamburger_01',
      object3DFileName: 'Hamburger_01.sfb',
      scale: vector.Vector3(0.2, 0.2, 0.2),
      position: vector.Vector3(0, -0.3, -0.5),
      rotation: vector.Vector4(0, 180, 0, 0),
    );
    controller.addArCoreNode(node);
  }

  /*_addToon(ArCoreController controller){
    final node = ArCoreReferenceNode(
      name: 'Toon',
      object3DFileName: 'Toon.sfb',
      scale: vector.Vector3(0.5,0.5,0.5),
      position: vector.Vector3(0,-1,-1),
      rotation: vector.Vector4(0,180,0,0),
    );
    controller.addArCoreNode(node);
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
*/
  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        ),
        title: Text(
          "Hamburger",
          style: TextStyle(
              fontSize: 45.0,
              color: Colors.white,
              fontFamily: "Italianno-Regular"),
        ),
        centerTitle: true,
      ),
      body: ArCoreView(
        onArCoreViewCreated: _onArCoreViewCreated,
      ),
    );
  }
}
