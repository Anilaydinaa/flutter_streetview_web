
enum MarkerIconType { defaultIcon, png, svg }

class MarkerOptions {
  final double? markerLat;
  final double? markerLng;
  final MarkerIconType iconType;
  final String? customIconPath;
  final double scaledWidth;
  final double scaledHeight;
  final double anchorX;
  final double anchorY;

  const MarkerOptions({
    this.markerLat,
    this.markerLng,
    this.iconType = MarkerIconType.defaultIcon,
    this.customIconPath,
    this.scaledWidth = 40,
    this.scaledHeight = 40,
    this.anchorX = 0,
    this.anchorY = 50,
  });

  bool get hasMarker => markerLat != null && markerLng != null;
}
