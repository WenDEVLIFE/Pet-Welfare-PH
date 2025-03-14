class CityModel{
  String cityName;
  String cityCode;

  CityModel({
    required this.cityName,
    required this.cityCode
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CityModel &&
              runtimeType == other.runtimeType &&
              cityCode == other.cityCode;

  @override
  int get hashCode => cityCode.hashCode;
}