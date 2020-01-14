import 'package:location/location.dart';
import 'package:flutter/services.dart';

class STLocationGetter{
//  STLocationGetter(){
//  }
  Future<Map<String,dynamic>> getLocation() async{
    LocationData currentLocation;
    var location = new Location();
    Map<String,dynamic> ret = {};
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      currentLocation = await location.getLocation();
      ret = {"latitude":currentLocation.latitude.toString(),
              "longitude":currentLocation.longitude.toString()};
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print("location permission denied");
      }
      currentLocation = null;
    }
    return ret;
  }

}
