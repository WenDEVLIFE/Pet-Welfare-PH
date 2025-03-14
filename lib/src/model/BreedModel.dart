class Breed {
  final String id;
  final String name;
  final String temperament;
  final String imageUrl;

  Breed({
    required this.id,
    required this.name,
    required this.temperament,
    required this.imageUrl,
  });

  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      temperament: json['temperament'] ?? '',
      imageUrl: json['image'] != null ? json['image']['url'] ?? '' : '',
    );
  }
}
