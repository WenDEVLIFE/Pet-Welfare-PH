class ProvinceModel {
  final String provinceName;
  final String provinceCode;

  ProvinceModel({
    required this.provinceName,
    required this.provinceCode
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProvinceModel &&
              runtimeType == other.runtimeType &&
              provinceCode == other.provinceCode;

  @override
  int get hashCode => provinceCode.hashCode;
}