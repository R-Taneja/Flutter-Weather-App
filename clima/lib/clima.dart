import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

//Add your API key here
const apiKey = '';

class Clima extends StatefulWidget {
  @override
  _ClimaState createState() => _ClimaState();
}

class _ClimaState extends State<Clima> {
  @override
  void initState() {
    super.initState();
    getLocation();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Position position;
  List<Placemark> placemark;
  String location;
  http.Response response;
  double temperature;
  int tempc;
  String description;

  void getLocation() async {
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest);
    placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);

    location = placemark[0].locality + ", " + placemark[0].country;
    setState(() {});
    getWeather();
  }

  void getWeather() async {
    response = await http.get(
        'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey');

    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = jsonDecode(data);
      temperature = decodedData['main']['temp'];
      description = decodedData['weather'][0]['main'];
      if (description == "Clouds") {
        description = "Cloudy";
      }

      temperature -= 273.1;
      tempc = temperature.round();
      setState(() {});
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/background.jpg'), fit: BoxFit.cover),
          ),
        ),
        Scaffold(
          backgroundColor: Color.fromRGBO(38, 50, 56, 0.65),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    DateTime.now().day.toString() +
                        " • " +
                        DateTime.now().month.toString() +
                        " • " +
                        DateTime.now().year.toString(),
                    style: TextStyle(
                      color: Colors.white60,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    placemark != null ? location : "Loading...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          tempc != null ? tempc.toString() : "--",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 80.0,
                          ),
                        ),
                        Text(
                          'o',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 30.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    description != null ? description + "." : "Loading...",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 40.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
