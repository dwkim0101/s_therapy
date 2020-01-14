import 'package:weather/weather.dart';
import 'package:shared_preferences/shared_preferences.dart';

class STWeatherGetter{
  static const String _apiKey = "9662b30d6588ebad399b3099f61c20a3";
  static WeatherStation weatherStation;
  STWeatherGetter(){
    if (weatherStation != null) return;
    weatherStation = WeatherStation(_apiKey);
  }

  Future<bool> requestPermission() async{
    return weatherStation.manageLocationPermission();
  }


  void _saveToPreference(STWeather weather) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("date", weather.date);
    prefs.setString("placeName", weather.placeName);
    prefs.setString("currentTemp", weather.currentTemp);
    prefs.setString("weather", weather.weather);
    prefs.setString("sunrise", weather.sunrise);
    prefs.setString("sunset", weather.sunset);
  }

  Future<bool> _isAlreadySaved() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("date") == null) return false;
    String savedDay = DateTime.parse(prefs.getString("date")).day.toString();
    return DateTime.now().day.toString() == savedDay;
  }

  Future<STWeather> getWeather() async{
    bool alreadySaved = await _isAlreadySaved();
    if (alreadySaved == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("return from preference");
      STWeather weatherData = STWeather();
      weatherData._currentTemp = prefs.getString("currentTemp");
      weatherData._date = prefs.getString("date");
      weatherData._placeName = prefs.getString("placeName");
      weatherData._weather = prefs.getString("weather");
      weatherData._sunrise = prefs.getString("sunrise");
      weatherData._sunset = prefs.getString("sunset");
      return weatherData;
    }
    print("return from weather cp server");
    return _queryWeather();
  }

  Future<STWeather> _queryWeather() async{
    Weather w = await weatherStation.currentWeather();
    print(w.toString());
    STWeather weatherData = STWeather();
    weatherData._currentTemp = w.temperature.toString();
    weatherData._date = w.date.toString();
    weatherData._placeName = w.areaName;
    weatherData._weather = w.weatherMain;
    weatherData._sunrise = w.sunrise.toString();
    weatherData._sunset = w.sunset.toString();
    _saveToPreference(weatherData);
    return weatherData;
  }
}

class STWeather{
  String _placeName;
  String _date;
  String _weather;
  String _currentTemp;
  String _sunrise;
  String _sunset;

  printAllData(){
    print('Place Name : $_placeName');
    print("date : $_date");
    print("weather : $_weather");
    print("currentTemp : $_currentTemp");
    print("sunrise : $_sunrise");
    print("sunset : $_sunset");
  }
  String get placeName => _placeName;
  String get date => _date;
  String get weather => _weather;
  String get currentTemp => _currentTemp;
  String get sunrise => _sunrise;
  String get sunset => _sunset;
}