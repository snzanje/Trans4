// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_steganography/decoder.dart';
import 'package:flutter_steganography/encoder.dart';
import 'package:flutter_steganography/requests/encode_request.dart';
import 'package:flutter_steganography/requests/decode_request.dart';

/*
Uint8List steg(File f, String msg, String k) {
  File file = f;

  // the key is use to encrypt your message with AES256 algorithm
  EncodeRequest request = EncodeRequest(file.readAsBytesSync(), msg, key: k);

  // for async
  //Uint8List response = await encodeMessageIntoImageAsync(request);

  //for sync
  Uint8List response = encodeMessageIntoImage(request);
  print("Encryption module working");
  return response;
}

String dsteg(Uint8List file, String k) {
  DecodeRequest request = DecodeRequest(file, key: k);

  //sync
  String response = decodeMessageFromImage(request);

  //async
  //String response = await decodeMessageFromImage(request);
  return response;
}

*/

//for testing
Uint8List steg(File f, String msg, String k) {
  File file = f;

  EncodeRequest request = EncodeRequest(file.readAsBytesSync(), msg, key: k);
  Uint8List response = encodeMessageIntoImage(request);
  print("Encryption module done");

  DecodeRequest request1 = DecodeRequest(response, key: k);
  String response1 = decodeMessageFromImage(request1);
  print(response1);

  return response;
}
