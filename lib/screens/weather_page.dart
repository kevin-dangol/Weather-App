import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  final weatherService = WeatherService('478dac1c24d7a387208009f30d9cbf8f');
  Weather? weather;

  Future fetchWeather() async{

    String cityName = await weatherService.getCurrentCity();

    try{

      final result = await weatherService.getWeather(cityName);
      
      setState(() {
        weather = result;
      });

      debugPrint('weather: $result');

    } catch(e){

      return e.toString();

    }

  }

  String animation(String? condition){

    if(condition==null) return 'lib/assets/little sun.json';

    switch(condition.toLowerCase()) {

      case 'thunderstorm':
        return 'lib/assets/Weather-storm.json';
      case 'drizzle':
        return 'lib/assets/cloudyRain.json';
      case 'rain':
        return 'lib/assets/cloudyRain.json';
      case 'snow':
        return 'lib/assets/Weather-snow.json';
      case 'atmosphere':
        return 'lib/assets/Weather-partly cloudy.json';
      case 'clear':
        return 'lib/assets/little sun.json';
      case 'clouds':
        return 'lib/assets/cloudy.json';
      default:
        return 'lib/assets/little sun.json';


    }
    

  }

  @override
  void initState() {
    super.initState();
    
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.black,
      
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
        
          children: [

            Icon(
              CupertinoIcons.placemark_fill,
              color: Colors.white,
              size: 60,
            ),
        
            Text(

              weather?.cityName ?? 'Loading...',

              style: GoogleFonts.oswald(
                textStyle: const TextStyle(

                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,

                ),
              ),

            ),

            Lottie.asset(

              animation(weather?.condition),
              width: 400,
              height: 400,

            ),
        
            Align(
              alignment: AlignmentGeometry.center,
              child: Text(weather != null
                ? '${weather!.temp.round()} °C'
                : 'Loading...',
              
                style: GoogleFonts.oswald(
                  textStyle: const TextStyle(
              
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
              
                  ),
                ),
                
              ),
            ),

            Align(
              alignment: AlignmentGeometry.center,
              child: Text(
                weather?.condition ?? '',
                style: GoogleFonts.oswald(
                  textStyle: const TextStyle(
              
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
              
                  ),
                ),
                
              ),
            ),
        
          ],
        
        ),
      ),
    );
  }
}