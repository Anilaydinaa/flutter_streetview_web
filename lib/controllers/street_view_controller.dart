import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/street_view_options.dart';

class StreetViewController {
  final WebViewController webViewController;

  StreetViewController(this.webViewController);

  Future<void> setApiKey(String apiKey) async {
    await webViewController.runJavaScript('setApiKey("$apiKey");');
  }

  Future<void> changeLocation(double lat, double lng) async {
    await webViewController.runJavaScript('changeLocation($lat, $lng);');
  }

  Future<void> addMarker(double lat, double lng) async {
    await webViewController.runJavaScript('addMarker($lat, $lng);');
  }

  Future<void> removeMarker() async {
    await webViewController.runJavaScript('removeMarker();');
  }

  Future<void> setCustomIcon(
    String base64Icon,
    double scaledWidth,
    double scaledHeight,
    double anchorX,
    double anchorY,
  ) async {
    await webViewController.runJavaScript('''
      setCustomIcon(
        "$base64Icon",
        $scaledWidth,
        $scaledHeight,
        $anchorX,
        $anchorY
      );
    ''');
  }

  Future<void> setOptions(StreetViewOptions options) async {
    await webViewController.runJavaScript(
      'setStreetViewOptions(${json.encode(options.toMap())});',
    );
  }
}