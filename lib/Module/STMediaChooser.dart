// import 'package:sound_therapy/Module/FireBase.dart';

import 'STFitnessGetter.dart';
// import 'STWeatherGetter.dart';
import 'STLocationGetter.dart';

import 'dart:async'; 
import 'dart:convert'; 
import 'package:http/http.dart' as http;


class STMediaChooser{
  static dynamic fitData = {};
  STFitnessGetter _fitnessGetter;
  // STWeatherGetter _weatherGetter;
  STLocationGetter _locationGetter;
  STMediaChooser(){
    _fitnessGetter = STFitnessGetter();
    // _weatherGetter = STWeatherGetter();
    _locationGetter = STLocationGetter();
  }

  Future<String> recommandMediaUrl(String category) async{
    /*
    var ret = _fitnessGetter.read();
    _weatherGetter.getWeather().then((data){
      print("================= Weather Data ===============");
      data.printAllData();
      print("================= Weather Data ===============");
    });
    */
    // var ret = _fitnessGetter.read();
    // if (FireBase.instance.isSignedIn()) {
    //   //FireBase.instance.setUserStateChagedCb((){});
    //   String userinfo = await FireBase.instance.fetch();
    //   print(userinfo);  
    // }
    Future<String> selectMusic(bodyData) async { 
      http.Response response = await http.post( 
        Uri.encodeFull('http://pkc1672.iptime.org:3001/music_chooser'), 
        headers: {"Accept": "application/json"},
        body:{"userData":json.encode(bodyData)}
      );
      print(response.body);
      return response.body;
    }
    _fitnessGetter.read().then((data){
      fitData = data;
    });
    dynamic locationData = await _locationGetter.getLocation();
    Map<String,dynamic> data = {
                "Location": locationData,
                "Fitness":fitData,
                "Category":category
              };
    String url = await selectMusic(data);
    print(url);
    return url;
    

    // String url = "http://pkc1672.iptime.org:3001/music/adrenaline Mode v2-20190918T140434Z-001/adrenaline Mode v2-20190918T140434Z-001/Track-01.mp3";
    // if (category == "D") url = "http://pkc1672.iptime.org:3001/music/adrenaline Mode v2-20190918T140434Z-001/adrenaline Mode v2-20190918T140434Z-001/Track-02.mp3";
    // if (category == "H") url = "http://pkc1672.iptime.org:3001/music/adrenaline Mode v2-20190918T140434Z-001/adrenaline Mode v2-20190918T140434Z-001/Track-03.mp3";
    // if (category == "F") url = "http://pkc1672.iptime.org:3001/music/adrenaline Mode v2-20190918T140434Z-001/adrenaline Mode v2-20190918T140434Z-001/Track-04.mp3";
    // if (category == "R") url = "http://pkc1672.iptime.org:3001/music/adrenaline Mode v2-20190918T140434Z-001/adrenaline Mode v2-20190918T140434Z-001/Track-05.mp3";
    // print(url);
    // return url;
  }
}