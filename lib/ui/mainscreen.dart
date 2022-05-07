// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors, avoid_print, missing_return, override_on_non_overriding_member, unused_local_variable

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:trans4/ui/main_screen_page2.dart';
import 'package:trans4/ui/widgets/custom_shape.dart';
import 'package:trans4/ui/widgets/customappbar.dart';
import 'package:trans4/ui/widgets/responsive_ui.dart';
import 'package:trans4/ui/widgets/textformfield.dart';
import 'package:trans4/ui/widgets/img_pick.dart';
import 'package:encrypt/encrypt.dart' as en;
import 'package:trans4/utils/stegno.dart';

class MainScreenPage extends StatefulWidget {
  @override
  _MainScreenPageState createState() => _MainScreenPageState();
}

class _MainScreenPageState extends State<MainScreenPage> {
  @override
  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  TextEditingController keyControl = TextEditingController();
  TextEditingController msgControl = TextEditingController();
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Scaffold(
      key: globalKey,
      body: Container(
        height: _height,
        width: _width,
        margin: const EdgeInsets.only(bottom: 5),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Opacity(opacity: 0.88, child: CustomAppBar()),
              clipShape(),
              ImgPick(height: _height), //whole ui is made in img pick
              form(),
            ],
          ),
        ),
      ),
    );
  }

//theme
  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 8
                  : (_medium ? _height / 7 : _height / 6.5),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purpleAccent],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height / 12
                  : (_medium ? _height / 11 : _height / 10),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purpleAccent],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 20.0),
      child: Form(
        child: Column(
          children: <Widget>[
            SizedBox(height: _height / 90.0),
            customKeyCheck(),
            SizedBox(height: _height / 80.0),
            textB(1),
            SizedBox(height: _height / 60.0),
            textB(2),
            SizedBox(height: _height / 40.0),
            button('Start Encryption', 1),
            SizedBox(height: _height / 35.0),
            button('Decrypt', 2)
          ],
        ),
      ),
    );
  }

  Widget textB(int n) {
    if (n == 1) {
      return CustomTextField(
        keyboardType: TextInputType.text,
        icon: Icons.vpn_key_outlined,
        hint: "Enter Private Key",
        textEditingController: keyControl,
      );
    }
    if (n == 2) {
      return CustomTextField(
        keyboardType: TextInputType.text,
        icon: Icons.textsms_outlined,
        hint: "Enter Secret Message",
        textEditingController: msgControl,
      );
    }
  }

  Widget customKeyCheck() {
    return Container(
      margin: EdgeInsets.only(top: _height / 80.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            checkBoxValue = checkBoxValue ? false : true;
            checkBoxValue ? getRand() : keyControl.clear();
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Checkbox(
                activeColor: Colors.blue,
                value: checkBoxValue,
                onChanged: (bool newValue) {
                  setState(() {
                    checkBoxValue = newValue;
                    checkBoxValue ? getRand() : keyControl.clear();
                  });
                }),
            Text(
              "Generate Random Key",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: _large ? 32 : (_medium ? 22 : 16)),
            ),
          ],
        ),
      ),
    );
  }

  void encr() //encryption with aes
  {
    String userkey = keyControl.text;
    if (userkey.length < 16) {
      userkey = userkey.padRight(16, '.');
    } else if (userkey.length > 16) {
      userkey = userkey.substring(0, 16);
    }
    final key = en.Key.fromSecureRandom(32);
    final iv = en.IV.fromUtf8(userkey.toString());
    final encrypter = en.Encrypter(en.AES(key));
    //print(key);
    //print(key.length);
    final encrypted = encrypter.encrypt(msgControl.text, iv: iv);
    /*final decrypted = encrypter.decrypt(encrypted, iv: iv);
    print(decrypted);
    print(encrypted.base64);*/

    //steganography
  }

  Widget button(String t, int n) {
    Uint8List resultfile;
    return RaisedButton(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      onPressed: () {
        if (n == 1) //start encryption button
        {
          //encr();//aes function
          File _image = getImg();
          if (_image == null) {
            globalKey.currentState.showSnackBar(
                const SnackBar(content: Text("Please upload Image first")));
          } else {
            resultfile = steg(_image, msgControl.text,
                keyControl.text); //stegnography function
          }
        }
        if (n == 2) {
          /*testing decode
          String _response = dsteg(resultfile, keyControl.text);
          globalKey.currentState
              .showSnackBar(SnackBar(content: Text(_response)));
          print(_response);
          */

          /*decode page*/

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreenPage2(),
            ),
          );
        }
      },
      textColor: Colors.white,
      padding: const EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
//        height: _height / 20,
        width: _large ? _width / 2 : (_medium ? _width / 2 : _width / 2),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[Colors.blue, Colors.purpleAccent],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text(
          t,
          style: TextStyle(
              fontSize: _large ? 28 : (_medium ? 22 : 20),
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void getRand() {
    Random r = new Random();
    var r1 = r.nextInt(900000) + 100000;
    keyControl.text = r1.toString();
    globalKey.currentState.showSnackBar(const SnackBar(
        content:
            Text("Please note generated key before final encryption !!!")));
  }
}
