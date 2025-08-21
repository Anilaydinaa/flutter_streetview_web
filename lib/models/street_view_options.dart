class StreetViewOptions {
  final bool panControl;
  final bool zoomControl;
  final bool linksControl;
  final bool fullscreenControl;
  final bool motionTrackingControl;
  final bool addressControl;
  final bool showRoadLabels;
  final bool clickToGo;
  final bool scrollwheel;
  final bool disableDefaultUI;
  final int povHeading;
  final int povPitch;
  final int povZoom;

  const StreetViewOptions({
    this.panControl = true,
    this.zoomControl = true,
    this.linksControl = true,
    this.fullscreenControl = true,
    this.motionTrackingControl = true,
    this.addressControl = true,
    this.showRoadLabels = true,
    this.clickToGo = true,
    this.scrollwheel = true,
    this.disableDefaultUI = false,
    this.povHeading = 0,
    this.povPitch = 0,
    this.povZoom = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'panControl': panControl,
      'zoomControl': zoomControl,
      'linksControl': linksControl,
      'fullscreenControl': fullscreenControl,
      'motionTrackingControl': motionTrackingControl,
      'addressControl': addressControl,
      'showRoadLabels': showRoadLabels,
      'clickToGo': clickToGo,
      'scrollwheel': scrollwheel,
      'disableDefaultUI': disableDefaultUI,
      'povHeading' : povHeading,
      'povPitch' : povPitch,
      'povZoom' : povZoom,
    };
  }
}
