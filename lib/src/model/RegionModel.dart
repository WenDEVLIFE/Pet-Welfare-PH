class RegionModel {
  final String region;
  final String regionCode;

  RegionModel({
    required this.region,
    required this.regionCode
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is RegionModel &&
              runtimeType == other.runtimeType &&
              regionCode == other.regionCode;

  @override
  int get hashCode => regionCode.hashCode;



}