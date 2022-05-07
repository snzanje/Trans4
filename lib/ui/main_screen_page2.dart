// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors, avoid_print, missing_return, override_on_non_overriding_member

import 'package:flutter/material.dart';
import 'package:trans4/ui/widgets/custom_shape.dart';
import 'package:trans4/ui/widgets/customappbar.dart';
import 'package:trans4/ui/widgets/responsive_ui.dart';
import 'package:trans4/ui/widgets/textformfield.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class MainScreenPage2 extends StatefulWidget {
  @override
  _MainScreenPage2State createState() => _MainScreenPage2State();
}

class _MainScreenPage2State extends State<MainScreenPage2> {
  @override
  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  TextEditingController _privatekey = TextEditingController();
  File _image;
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
              pickImage(),
              form(),
            ],
          ),
        ),
      ),
    );
  }

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
            SizedBox(height: _height / 80.0),
            textB(1),
            SizedBox(height: _height / 40.0),
            button('Start Decryption', 1)
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
        textEditingController: _privatekey,
      );
    }
  }

  Widget pickImage() {
    return Container(
      height: _height / 5.5,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
              spreadRadius: 0.0,
              color: Colors.black26,
              offset: Offset(1.0, 10.0),
              blurRadius: 20.0),
        ],
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: GestureDetector(
        onTap: () async {
          XFile image =
              await ImagePicker().pickImage(source: ImageSource.gallery);
          setState(() {
            _image = File(image.path);
          });
        },
        child: _image != null //if img not set then show icon
            ? Image.file(
                _image,
                width: 200,
                height: 200,
                fit: BoxFit.fill,
              )
            : const Icon(
                Icons.add_a_photo,
                size: 40,
                color: Colors.blue,
              ),
      ),
    );
  }

  Widget button(String t, int n) {
    return RaisedButton(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      onPressed: () {
        if (n == 1) {
          globalKey.currentState.showSnackBar(const SnackBar(
              content: Text("Decrypting Secret Message with Media")));
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
}
