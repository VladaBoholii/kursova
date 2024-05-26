class Showtime {
  final String time;
  final String price;
  final List<int> seatsTaken;

  Showtime({
    required this.time,
    required this.price,
    required this.seatsTaken,
  });

  factory Showtime.fromJson(String time, Map<String, dynamic> json) {
    return Showtime(
      time: time,
      seatsTaken: List<int>.from(json['seats_taken'] ?? []),
      price: json['price'] ?? '',
    );
  }
}
