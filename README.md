# 🗺️ Flutter Streetview Web

[![Pub Version](https://img.shields.io/pub/v/flutter_streetview_web.svg)](https://pub.dev/packages/flutter_streetview_web)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.0.0-blue.svg)](https://flutter.dev)

A Flutter widget for integrating Google Street View using WebView. Leverages the Google Maps JavaScript API to provide a seamless Street View experience within your Flutter app.

🚀 Features

- 🗺 Display Google Street View within Flutter
- 📍 Add custom markers (PNG & SVG)
- 🎨 Customizable loading and error screens (`loadingBuilder`, `errorBuilder`)
- Customizable StreetView controls
- Flutter ↔️ JavaScript communication
- Comprehensive error handling

🔑 Prerequisites  
Google Maps API Key: Obtain from Google Cloud Console. Enable Required APIs: Maps JavaScript API, Street View Static API.

## 🔐 Getting Google Maps API Key

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable these APIs:
   - Maps JavaScript API
   - Street View Static API
4. Create credentials (API Key)
5. Set application restrictions (recommended)
6. Copy your API key

**Important:** Add your domain to HTTP referrers in API key restrictions.

🎯 Basic Usage

```dart
import 'package:flutter_streetview_web/flutter_street_view.dart';

FlutterStreetView(
  apiKey: "YOUR_GOOGLE_MAPS_API_KEY",
  latitude: 41.107490, // Istanbul/Beykoz coordinates
  longitude: 29.078115,
)
```

📐 Resizable Street View
You can wrap FlutterStreetView inside a SizedBox (or any container) to control its width and height:

```dart
SizedBox(
  width: 300,
  height: 200,
  child: FlutterStreetView(
    apiKey: "YOUR_GOOGLE_MAPS_API_KEY",
      latitude: 41.107490,
      longitude: 29.078115,
  ),
)
```

✅ This allows embedding Street View in a smaller portion of your UI instead of occupying the full screen.

📍 Adding Markers

# Flutter Streetview Web - Marker Customization

You can customize markers in Street View using `MarkerOptions` and `MarkerIconType`.

---

## MarkerIconType

Defines the type of marker icon you want to display in Street View:

- **defaultIcon** – Uses the default Google Street View marker. No additional parameters are needed.
- **png** – Uses a PNG image from `customIconPath`.
- **svg** – Uses an SVG image from `customIconPath`.
  Note: iconType is automatically determined based on the parameters you provide:
- `customIconPath` ends with `.png` → **png** 🟢
- `customIconPath` ends with `.svg` → **svg** 🔵
- If no `customIconPath` → **defaultIcon** ⚪

---

## MarkerOptions

Options to customize a marker in Street View:

- **markerLat** (`double?`) – Latitude of the marker. Required for displaying a marker.

- **markerLng** (`double?`) – Longitude of the marker. Required for displaying a marker.

- **iconType** (`MarkerIconType`) – Type of the marker icon. Automatically set depending on `customIconPath`. Default: `defaultIcon`.

- **customIconPath** (`String?`) – Path to your custom PNG or SVG asset.

- **scaledWidth** (`double?`) – Width of the marker icon in pixels. Default: `40`.

- **scaledHeight** (`double?`) – Height of the marker icon in pixels. Default: `40`.

- **anchorX** (`double?`) – X coordinate of the anchor point. Default: `0`.

- **anchorY** (`double?`) – Y coordinate of the anchor point. Default: `50`.

---

### Example Usage

Default marker:

```dart
FlutterStreetView(
  apiKey: "YOUR_KEY",
    latitude: 41.107490,
    longitude: 29.078115,
  markerOptions: MarkerOptions(
    markerLat: 41.0082,
    markerLng: 28.9784,
    iconType: MarkerIconType.defaultIcon, // Optional
  ),
)
```

Custom PNG marker:

```dart
FlutterStreetView(
  apiKey: "YOUR_KEY",
      latitude: 41.107490,
      longitude: 29.078115,
  markerOptions: MarkerOptions(
    markerLat: 41.0082,
    markerLng: 28.9784,
    iconType: MarkerIconType.png,
    customIconPath: "assets/icons/location_pin.png",
    scaledWidth: 48,
    scaledHeight: 48,
    anchorX: 0,
    anchorY: 50,
  ),
)
```

Custom SVG marker:

```dart
FlutterStreetView(
  apiKey: "YOUR_KEY",
    latitude: 41.107490,
    longitude: 29.078115,
  markerOptions: MarkerOptions(
    markerLat: 41.0082,
    markerLng: 28.9784,
    iconType: MarkerIconType.svg,
    customIconPath: "assets/icons/location_pin.svg",
    scaledWidth: 48,
    scaledHeight: 48,
  ),
)
```

⚙️ StreetView Options

```dart
FlutterStreetView(
  apiKey: "YOUR_KEY",
  latitude: 41.107490,
  longitude: 29.078115,
  streetViewOptions: const StreetViewOptions(
    panControl: true,
    zoomControl: true,
    linksControl: true,
    fullscreenControl: true,
    motionTrackingControl: true,
    addressControl: true,
    showRoadLabels: true,
    clickToGo: true,
    scrollwheel: true,
    disableDefaultUI: false,
    povHeading: 0,
    povPitch: 0,
    povZoom: 0,
  ),
)
```

🎨 Customization  
Custom loading indicator:

```dart
FlutterStreetView(
  apiKey: "YOUR_KEY",
  latitude: 41.107490,
  longitude: 29.078115,
  loadingBuilder: (context) => Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
    ),
  ),
)
```

Custom error screen:

```dart
FlutterStreetView(
  apiKey: "YOUR_KEY",
  latitude: 41.107490,
  longitude: 29.078115,
  errorBuilder: (context, errorMessage) => Center(
    child: Container(
      padding: EdgeInsets.all(16),
      color: Colors.red[100],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 48),
          SizedBox(height: 16),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red[800]),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _controller.reload(),
            child: Text('Retry'),
          ),
        ],
      ),
    ),
  ),
)
```

📡 Event Handling  
Handle messages from JavaScript:

```dart
FlutterStreetView(
  apiKey: "YOUR_KEY",
  latitude: 41.107490,
  longitude: 29.078115,
  onMessageReceived: (message) {
    print('Received message from Street View: $message');
  },
)
```

Error handling:

```dart
FlutterStreetView(
  apiKey: "YOUR_KEY",
  latitude: 41.107490,
  longitude: 29.078115,
  onError: (error) {
    print('Street View Error: ${error.errorType} - ${error.message}');
    switch (error.errorType) {
      case StreetViewErrorType.apiKeyMissing:
        break;
      case StreetViewErrorType.locationUnavailable:
        break;
    }
  },
)
```

🚨 Error Types

- ⚠️ API Key Missing: Make sure your Google Maps API Key is valid!
- ⚠️ Location Unavailable: Street View is not available for the specified location.
- ⚠️ Web View Error: WebView encountered an error.
- ⚠️ Asset Load Error: Failed to load custom marker asset.
- ⚠️ Initialization Failed: Failed to initialize Street View.

🔄 Programmatic Control

```dart
final WebViewController _controller;
_controller.reload();
_controller.runJavaScript('changeLocation(40.7128, -74.0060);');
_controller.setNavigationDelegate(NavigationDelegate(
  onNavigationRequest: (request) {
    return NavigationDecision.navigate;
  },
));
```

## 🔧 Troubleshooting

### Common Issues

**Blank Screen**

- Check API key validity
- Verify internet connection
- Check console for JavaScript errors

**Marker Not Showing**

- Verify asset paths are correct
- Check marker coordinates are within view

**Slow Performance**

- Optimize marker images
- Reduce WebView complexity

### Debug Mode

Enable debug logging:

```dart
FlutterStreetView(
  onMessageReceived: (message) {
    debugPrint('StreetView: $message');
  },
)

📝 Notes

- Internet Connection: Requires active internet connection for Google Maps API
- API Key Restrictions: Configure API key restrictions in Google Cloud Console
- Platform Support: Works on iOS and Android
- Performance: For best performance, use compressed images for custom markers
- Caching: WebView content is cached for better performance

📄 License
MIT License

🙏 Acknowledgments
Google Maps JavaScript API team, Flutter team, webview_flutter package maintainers. Enjoy exploring the world with Street View in your Flutter app! 🌍
```
