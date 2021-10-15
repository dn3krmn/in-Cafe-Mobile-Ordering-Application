import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';

/*class AdminSignInPage extends StatelessWidget {
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
          "Mobil Siparis",
          style: TextStyle(
              fontSize: 40.0, color: Colors.white, fontFamily: "Signatra"),
        ),
        centerTitle: true,
      ),
      body: AdminSignInScreen(),
    );
  }
}*/

class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _adminIDTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    //double _screenHeigth = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [Colors.white60, Colors.white60],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  "images/admin.png",
                  height: 170.0,
                  width: 170.0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Admin Girisi",
                style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 45.0,
                    fontWeight: FontWeight.normal,
                    fontFamily: "Signatra"),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _adminIDTextEditingController,
                    data: Icons.person,
                    hintText: "Admin",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTextEditingController,
                    data: Icons.vpn_key,
                    hintText: "Parola",
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            SizedBox(
              height: 50,
              width: 150,
              child: RaisedButton(
                onPressed: () {
                  _adminIDTextEditingController.text.isNotEmpty &&
                          _passwordTextEditingController.text.isNotEmpty
                      ? loginAdmin()
                      : showDialog(
                          context: context,
                          builder: (c) {
                            return ErrorAlertDialog(
                              message: "Lütfen e-mail ve parolanızı girin!",
                            );
                          });
                },
                color: Colors.orange,
                child: Text(
                  "Giriş Yap",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 150.0,
            ),
          ],
        ),
      ),
    );
  }

  loginAdmin() {
    Firestore.instance.collection("admins").getDocuments().then((snapshot) {
      snapshot.documents.forEach((result) {
        if (result.data["id"] != _adminIDTextEditingController.text.trim()) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Kullanıcı numaranız doğru değil.."),
          ));
        } else if (result.data["password"] !=
            _passwordTextEditingController.text.trim()) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Parolanız doğru değil.."),
          ));
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Admin girişi sağlandı." + result.data["name"]),
          ));
          setState(() {
            _adminIDTextEditingController.text = "";
            _passwordTextEditingController.text = "";
          });

          Route route = MaterialPageRoute(builder: (c) => UploadPage());
          Navigator.push(context, route);
        }
      });
    });
  }
}
