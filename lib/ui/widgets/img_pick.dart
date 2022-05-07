// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

File _image;
File getImg() //gives path of uploaded img
{
  return _image;
}

class ImgPick extends StatefulWidget {
  const ImgPick({key, this.height}) : super(key: key);
  final double height;

  @override
  State<ImgPick> createState() => _ImgPickState();
}

class _ImgPickState extends State<ImgPick> {
  Future<void> _showDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Choose Source"),
            content: Container(
              alignment: Alignment.center,
              height: 125,
              child: Column(children: [
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: const Text("Gallery"),
                  onTap: () async {
                    XFile image = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);

                    setState(() {
                      _image = File(image.path);
                      Navigator.of(context).pop();
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text("Camera"),
                  onTap: () async {
                    XFile image = await ImagePicker()
                        .pickImage(source: ImageSource.camera);

                    setState(() {
                      _image = File(image.path);
                      Navigator.of(context).pop();
                    });
                  },
                )
              ]),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height / 5,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
              spreadRadius: 0.0,
              color: Colors.black26,
              offset: Offset(1.0, 10.0),
              blurRadius: 17.0),
        ],
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: GestureDetector(
        onTap: () => _showDialog(),
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
}
