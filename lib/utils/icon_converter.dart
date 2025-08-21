import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

class IconConverter {
  static Future<String> svgToBase64(String assetPath) async {
    try {
      final svgContent = await rootBundle.loadString(assetPath);
      return 'data:image/svg+xml;base64,${base64Encode(utf8.encode(svgContent))}';
    } catch (e) {
      throw Exception('SVG to Base64 conversion failed: $e');
    }
  }

  static Future<String> pngToBase64(String assetPath) async {
    try {
      final byteData = await rootBundle.load(assetPath);
      return 'data:image/png;base64,${base64Encode(byteData.buffer.asUint8List())}';
    } catch (e) {
      throw Exception('PNG to Base64 conversion failed: $e');
    }
  }
}
