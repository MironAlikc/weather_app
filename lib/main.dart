import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/core/consts.dart';
import 'package:weather_app/data/weather_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String city = 'City';
  String weather = 'clear';
  String image = 'https://openweathermap.org/img/wn/04n@2x.png';
  String weatherTemp = '11';
  String? errorText;

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    return city == ''
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: const Color.fromARGB(255, 26, 123, 168),
            body: SafeArea(
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      child: SizedBox(
                        height: 50,
                        width: 300,
                        child: TextField(
                          onChanged: (val) {
                            if (val.isEmpty) {
                              errorText = null;
                              setState(() {});
                            }
                          },
                          controller: controller,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            focusColor: Colors.white,
                            hoverColor: Colors.white,
                            errorText: errorText,
                            suffixIcon: IconButton(
                              color: Colors.white,
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                getWeatherData(cityName: controller.text);
                              },
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      city,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Text(
                      weather,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    //  const SizedBox(height: 50),
                    Image.network(image),
                    // const SizedBox(height: 50),
                    Text(
                      weatherTemp,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Text(
                      textAlign: TextAlign.center,
                      formattedDate,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          );
  }

  Future<void> getWeatherData({required String cityName}) async {
    final Dio dio = Dio();
    try {
      final Response response = await dio.get(
        'https://api.openweathermap.org/data/2.5/weather',
        queryParameters: {
          'q': cityName,
          'lang': 'ru',
          'appid': AppConsts.apiKey,
          "units": 'metric',
        },
      );
      final model = WeatherModel.fromJson(response.data);
      city = model.name ?? '';
      weather = model.weather?.first.description ?? ' ';
      image =
          'https://openweathermap.org/img/wn/${model.weather?.first.icon}@2x.png';
      weatherTemp = model.main?.temp.toString() ?? "";
      setState(() {});
    } catch (e) {
      errorText = e.toString();
      setState(() {});
    }
  }
}
