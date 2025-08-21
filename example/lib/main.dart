import 'package:flutter/material.dart';
import 'package:flutter_streetview_web/flutter_streetview.dart';
import 'package:flutter_streetview_web/models/marker_options.dart';
import 'package:flutter_streetview_web/models/street_view_options.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Street View Web View Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StreetViewExample(),
    );
  }
}

class StreetViewExample extends StatefulWidget {
  const StreetViewExample({super.key});

  @override
  State<StreetViewExample> createState() => _StreetViewExampleState();
}

class _StreetViewExampleState extends State<StreetViewExample> {
  final String apiKey = 'YOUR_API_KEY_HERE';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Street View Example'),
      ),
      body: FlutterStreetView(
        // REQUIRED: Street View location
        latitude: 41.107490, 
        longitude: 29.078115,
        apiKey: apiKey,

        // OPTIONAL: Customize the Street View options
        streetViewOptions: const StreetViewOptions(
          panControl: false,
          zoomControl: false,
          linksControl: false,
          fullscreenControl: false,
          motionTrackingControl: false,
          addressControl: false,
          showRoadLabels: false,
          scrollwheel: false,
          povHeading: 0,
          povPitch: 0,
        ),

        // OPTIONAL: Add a custom marker
         markerOptions: const MarkerOptions(
          markerLat: 41.107490,
          markerLng: 29.078115,
          scaledWidth: 48,
          scaledHeight: 48,
          anchorX: 0,
          anchorY: 0,
        ),

        // OPTIONAL: Listen for JavaScript messages
        onMessageReceived: (message) {
          debugPrint('Received message: $message');
        },

        // RECOMMENDED: Handle errors and notify the user
        onError: (error) {
          debugPrint('Error: ${error.errorType} - ${error.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${error.message}'),
              backgroundColor: Colors.red,
            ),
          );
        },

        // OPTIONAL: Custom loading widget
        loadingBuilder: (context) => const Center(
          child: Text("Loading Street View..."),
        ),

        // OPTIONAL: Custom error widget
        errorBuilder: (context, errorMessage) =>
            Center(child: Text(errorMessage)),
      ),
    );
  }
}
