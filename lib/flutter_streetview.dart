// A Flutter widget that displays Google Street View using WebView
//
// This widget provides a highly customizable Street View experience
// with support for custom markers and advanced configuration options.
//
// Example usage:
// ```dart
/* 
FlutterStreetView(
        // REQUIRED: Street View location
        latitude: 41.107490, 
        longitude: 29.078115,
        apiKey: "YOUR_API_KEY_HERE",

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
          markerLat: 41.0082,
          markerLng: 28.9784,
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
      */
// ```

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'controllers/street_view_controller.dart';
import 'models/marker_options.dart';
import 'models/street_view_options.dart';
import 'models/street_view_web_view_exception.dart';
import 'utils/icon_converter.dart';

class FlutterStreetView extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String apiKey;
  final MarkerOptions? markerOptions;
  final StreetViewOptions streetViewOptions;
  final ValueChanged<String>? onMessageReceived;
  final ValueChanged<StreetViewException>? onError;
  final WidgetBuilder? loadingBuilder;
  final Widget Function(BuildContext, String)? errorBuilder;

  const FlutterStreetView({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.apiKey,
    this.markerOptions,
    this.streetViewOptions = const StreetViewOptions(),
    this.onMessageReceived,
    this.onError,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  State<FlutterStreetView> createState() => _FlutterStreetViewState();
}

class _FlutterStreetViewState extends State<FlutterStreetView> {
  late final WebViewController _webViewController;
  late final StreetViewController _streetViewController;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isInitialized = false;
  bool _isCriticalError = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() {
    _validateInputs();
    _initializeControllers();
    _initializeWebViewController();
  }

  void _validateInputs() {
    if (widget.apiKey.isEmpty) {
      throw ArgumentError('API key cannot be empty');
    }
    if (widget.latitude < -90 || widget.latitude > 90) {
      throw ArgumentError('Latitude must be between -90 and 90');
    }
    if (widget.longitude < -180 || widget.longitude > 180) {
      throw ArgumentError('Longitude must be between -180 and 180');
    }
  }

  void _initializeControllers() {
    _webViewController = WebViewController();
    _streetViewController = StreetViewController(_webViewController);
  }

  Future<void> _loadCustomIcon() async {
    if (widget.markerOptions == null) return;

    try {
      final markerOptions = widget.markerOptions!;
      final String base64Icon;

      switch (markerOptions.iconType) {
        case MarkerIconType.svg:
          if (markerOptions.customIconPath == null) {
            throw StreetViewException(
              StreetViewErrorType.assetLoadError,
              'SVG icon path is null for SVG icon type',
            );
          }
          base64Icon = await IconConverter.svgToBase64(
            markerOptions.customIconPath!,
          );
          break;
        case MarkerIconType.png:
          if (markerOptions.customIconPath == null) {
            throw StreetViewException(
              StreetViewErrorType.assetLoadError,
              'PNG icon path is null for PNG icon type',
            );
          }
          base64Icon = await IconConverter.pngToBase64(
            markerOptions.customIconPath!,
          );
          break;

        case MarkerIconType.defaultIcon:
          return;
      }

      await _streetViewController.setCustomIcon(
        base64Icon,
        markerOptions.scaledWidth,
        markerOptions.scaledHeight,
        markerOptions.anchorX,
        markerOptions.anchorY,
      );
    } catch (e) {
      _handleError(
        StreetViewException(
          StreetViewErrorType.assetLoadError,
          'Custom icon loading failed: $e',
        ),
      );
    }
  }

  Future<void> _setupMarker() async {
    if (widget.markerOptions?.hasMarker ?? false) {
      await _loadCustomIcon();
      await _streetViewController.addMarker(
        widget.markerOptions!.markerLat!,
        widget.markerOptions!.markerLng!,
      );
    }
  }

  Future<void> _setStreetViewOptions() async {
    await _streetViewController.setOptions(widget.streetViewOptions);
  }

  void _handleError(StreetViewException error) {
    setState(() => _errorMessage = error.message);

    if (widget.onError != null) {
      widget.onError!(error);
    }

    debugPrint('StreetView Error: ${error.toString()}');
  }

  void _handleJavaScriptMessage(String message) {
    if (message.startsWith('Error_')) {
      _handleError(
        StreetViewException(
          StreetViewErrorType.apiLoadFailed,
          message.replaceFirst('Error_', ''),
        ),
      );
    } else if (message == 'StreetView_Ready' && !_isInitialized) {
      _initializeStreetView();
    } else {
      widget.onMessageReceived?.call(message);
    }
  }

  Future<void> _initializeStreetView() async {
    try {
      await _streetViewController.setApiKey(widget.apiKey);
      await _setStreetViewOptions();
      await _streetViewController.changeLocation(
        widget.latitude,
        widget.longitude,
      );
      await _setupMarker();

      setState(() {
        _isInitialized = true;
        _isLoading = false;
      });
    } catch (e) {
      _handleError(
        StreetViewException(
          StreetViewErrorType.initializationFailed,
          'Initialization failed: $e',
        ),
      );
    }
  }

  void _initializeWebViewController() {
    _webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) async {
            setState(() => _isLoading = false);
            if (!_isInitialized) _initializeStreetView();
          },
          onWebResourceError: (error) => _handleError(
            StreetViewException(
              StreetViewErrorType.webViewError,
              'Web page loading error: ${error.description}',
            ),
          ),
          onNavigationRequest: (request) => _shouldNavigate(request.url)
              ? NavigationDecision.navigate
              : NavigationDecision.prevent,
        ),
      )
      ..addJavaScriptChannel(
        'MessageHandler',
        onMessageReceived: (message) =>
            _handleJavaScriptMessage(message.message),
      )
      ..loadFlutterAsset(
        'packages/flutter_streetview_web/assets/street_view_web_view.html',
      );
  }

  bool _shouldNavigate(String url) {
    return url.startsWith('https://maps.googleapis.com/') ||
        url.startsWith('file://') ||
        url.startsWith('about:blank');
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null && widget.errorBuilder != null) {
      return widget.errorBuilder!(context, _errorMessage!);
    }

    return Stack(
      children: [
        WebViewWidget(controller: _webViewController),

        if (_isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: .1),
              child: _buildLoadingIndicator(context),
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return widget.loadingBuilder?.call(context) ??
        const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        );
  }
}
