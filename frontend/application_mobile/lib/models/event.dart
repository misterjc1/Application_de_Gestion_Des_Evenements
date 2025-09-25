class Event {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final double price;
  final int maxAttendees;
  final String organizer;
  final String? image;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.price,
    required this.maxAttendees,
    required this.organizer,
    this.image,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    // Gestion des types pour éviter l'erreur de casting
    double parsePrice(dynamic price) {
      if (price is double) return price;
      if (price is int) return price.toDouble();
      if (price is String) return double.tryParse(price) ?? 0.0;
      return 0.0;
    }

    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      if (value is double) return value.toInt();
      return 0;
    }

    return Event(
      id: parseInt(json['id']),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      date: DateTime.parse(json['date']?.toString() ?? DateTime.now().toIso8601String()),
      location: json['location']?.toString() ?? '',
      price: parsePrice(json['price']),
      maxAttendees: parseInt(json['maxAttendees']),
      organizer: json['organizer']?.toString() ?? '',
      image: json['image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'location': location,
      'price': price,
      'maxAttendees': maxAttendees,
      'image': image,
    };
  }
}