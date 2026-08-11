class Slot {
  final String date;
  final String time;
  final bool isBooked;

  Slot({required this.date, required this.time, required this.isBooked});

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      isBooked: json['isBooked'] ?? false,
    );
  }
}

class ServiceProvider {
  final String id;
  final String name;
  final String category;
  final String description;
  final String location;
  final double pricePerSession;
  final double avgRating;
  final int reviewCount;
  final String imageUrl;
  final List<Slot> availableSlots;

  ServiceProvider({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.location,
    required this.pricePerSession,
    required this.avgRating,
    required this.reviewCount,
    required this.imageUrl,
    required this.availableSlots,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    return ServiceProvider(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      pricePerSession: (json['pricePerSession'] ?? 0).toDouble(),
      avgRating: (json['avgRating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      availableSlots: (json['availableSlots'] as List<dynamic>? ?? [])
          .map((s) => Slot.fromJson(s))
          .toList(),
    );
  }
}
