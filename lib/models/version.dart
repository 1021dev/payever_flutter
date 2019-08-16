class Version{

  String _minVersion;
  String _currentVersion;
  String _appleStoreUrl;
  String _playStoreUrl;

  Version(this._currentVersion,this._minVersion,this._appleStoreUrl,this._playStoreUrl);

  String get minVersion     => _minVersion;
  String get currentVersion => _currentVersion;
  
  String storeLink(bool isApple) => isApple?_appleStoreUrl:_playStoreUrl;

}