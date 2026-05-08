// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
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

      print('fetch: $result');

      return result;

    } else{

      throw Exception('Error loading data');

    }

  }

  Future<String> getCurrentCity() async{

    LocationPermission permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied) {

      permission = await Geolocator.requestPermission();

    }

    Position position = await Geolocator.getCurrentPosition(

      desiredAccuracy: LocationAccuracy.high

    );

    List<Placemark> placemarks =  await placemarkFromCoordinates(position.latitude, position.longitude);
    debugPrint('placemarks: $placemarks');

    String? city = placemarks[0].locality;

    debugPrint('city: $city');

    return city ?? '';

  }

}