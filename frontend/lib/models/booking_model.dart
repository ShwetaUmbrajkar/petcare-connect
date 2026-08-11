class Booking {
  final String id;
  final String providerName;
  final String petName;
  final String date;
  final String time;
  final String status;
  final double amount;
  final String paymentStatus;

  Booking({
    required this.id,
    required this.providerName,
    required this.petName,
    required this.date,
    required this.time,
    required this.status,
    required this.amount,
    required this.paymentStatus,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'] ?? '',
      providerName: json['provider'] != null ? json['provider']['name'] ?? '' : '',
      petName: json['petName'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      status: json['status'] ?? 'pending',
      amount: (json['amount'] ?? 0).toDouble(),
      paymentStatus: json['paymentStatus'] ?? 'unpaid',
    );
  }
}
