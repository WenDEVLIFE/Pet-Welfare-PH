class BarangayModel{
  final String barangayName;
  final String municipalityCode;

  BarangayModel({
    required this.barangayName,
    required this.municipalityCode
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BarangayModel &&
              runtimeType == other.runtimeType &&
              municipalityCode == other.municipalityCode;

  @override
  int get hashCode => municipalityCode.hashCode;
}