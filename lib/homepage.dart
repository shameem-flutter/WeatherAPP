import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/weathermodel.dart';
import 'package:flutter_application_1/services/weatherservice.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final WeatherService _weatherService = WeatherService();
  WeatherModel? _weather;
  bool _isLoading = false;
  String _errorMessage = '';
  bool _useCelcius = true;
  final List<String> _popularLocations = [
    'India',
    'London',
    'New York',
    'Tokyo',
    'Berlin',
    'Sydney',
    'Paris',
  ];

  String _getBackgroundImage(String condition) {
    condition = condition.toLowerCase();
    if (condition.contains('sunny') || condition.contains('clear')) {
      return 'assets/sunny.jpg';
    } else if (condition.contains('rain') || condition.contains('drizzle')) {
      return 'assets/rainybw.jpg';
    } else if (condition.contains('snow')) {
      return 'assets/snowy.jpg';
    } else if (condition.contains('cloud') || condition.contains('overcast')) {
      return 'assets/cloudy.jpg';
    } else if (condition.contains('mist')) {
      return 'assets/mist.jpg';
    } else {
      return 'assets/default.jpg';
    }
  }

  Future<void> _fetchWeather(String location) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final weather = await _weatherService.getWeather(location);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'failed to fetch weather data: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,

        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: IconButton(
              icon: Icon(
                _useCelcius ? Icons.thermostat : Icons.thermostat_outlined,
              ),
              onPressed: () {
                setState(() {
                  _useCelcius = !_useCelcius;
                });
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              _weather != null
                  ? _getBackgroundImage(_weather!.condition)
                  : 'assets/background.jpg',
            ),

            fit: BoxFit.cover,
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DropdownSearch<String>(
                  popupProps: PopupProps.menu(showSearchBox: true),
                  items: _popularLocations,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Select or type a location",
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      hintText: "Search for a city or country",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  selectedItem: _weather?.city,
                  dropdownBuilder: (context, selectedItem) {
                    return Text(
                      selectedItem ?? '',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    );
                  },

                  onChanged: (value) {
                    if (value != null) {
                      _fetchWeather(value);
                    }
                  },
                ),

                SizedBox(height: 20),
                if (_isLoading)
                  CircularProgressIndicator()
                else if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  )
                else if (_weather != null)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            '${_weather!.city}, ${_weather!.country}',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            _weather!.localtime,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.network(
                                'https:${_weather!.icon}',
                                width: 64,
                                height: 64,
                              ),
                              SizedBox(width: 10),
                              Text(
                                '${_useCelcius ? _weather!.temp_c.round() : _weather!.temp_f.round()}${_useCelcius ? 'c' : 'f'}',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                _weather!.condition,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _buildWeatherInfo(
                                    'Humidity',
                                    '${_weather!.humidity}%',
                                  ),
                                  _buildWeatherInfo(
                                    'Wind',
                                    '${_weather!.wind_kph}Km/h',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherInfo(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 05),
      ],
    );
  }
}
