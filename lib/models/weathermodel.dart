class WeatherModel {
  final String city;
  final String country;
  final double temp_c;
  final double temp_f;
  final String condition;
  final double humidity;
  final double wind_kph;
  final String localtime;
  final String icon;

  WeatherModel({
    required this.city,
    required this.country,
    required this.temp_c,
    required this.temp_f,
    required this.condition,
    required this.humidity,
    required this.wind_kph,
    required this.localtime,
    required this.icon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['location']['name'],
      country: json['location']['country'],
      temp_c: json['current']['temp_c'],
      temp_f: json['current']['temp_f'],
      condition: json['current']['condition']['text'],
      humidity: json['current']['humidity'].toDouble(),
      wind_kph: json['current']['wind_kph'].toDouble(),
      localtime: json['location']['localtime'],
      icon: json['current']['condition']['icon'],
    );
  }
}
