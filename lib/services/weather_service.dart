// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather.dart';

class WeatherService {

  static const url = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async{

    final response = await http.get(
      Uri.parse(
        '$url?q=$cityName&appid=$apiKey&units=metric'
      )
    );

    if(response.statusCode == 200){

      final result = Weather.fromJson(jsonDecode(response.body));

      return result;
 
    } else{

      throw Exception('Error loading data');

    }

  }

  Future<String> getCurrentCity() async{


    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception('Location permission denied');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied.',
      );
    }


    Position position = await Geolocator.getCurrentPosition(

      desiredAccuracy: LocationAccuracy.high

    );

    List<Placemark> placemarks =  await placemarkFromCoordinates(
      position.latitude,
      position.longitude
    );

    String city =
        placemarks[0].locality ??
        placemarks[0].subAdministrativeArea ??
        placemarks[0].administrativeArea ??
        '';

    return city;

  }

}