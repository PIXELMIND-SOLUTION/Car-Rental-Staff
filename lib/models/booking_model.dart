

import "package:car_rental_staff_app/models/car_model.dart";

class Booking {
  final String id;
  final String userId;
  final Car car;
  final DateTime rentalStartDate;
  final DateTime rentalEndDate;
  final int totalPrice;
  final String status;
  final String paymentStatus;
  final BookingLocation pickupLocation;
  final BookingLocation dropLocation;
  final int otp;

  Booking({
    required this.id,
    required this.userId,
    required this.car,
    required this.rentalStartDate,
    required this.rentalEndDate,
    required this.totalPrice,
    required this.status,
    required this.paymentStatus,
    required this.pickupLocation,
    required this.dropLocation,
    required this.otp,
  });

  bool get isCompleted => status.toLowerCase() == 'completed';
  bool get isCancelled => status.toLowerCase() == 'cancelled';
  bool get isPending => status.toLowerCase() == 'pending';

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'],
      // Handle userId when it's a map (full user object) or string (just the ID)
      userId: json['userId'] is Map ? json['userId']['_id'] : json['userId'],
      car: Car.fromJson(json['carId']),
      rentalStartDate: DateTime.parse(json['rentalStartDate']),
      rentalEndDate: DateTime.parse(json['rentalEndDate']),
      totalPrice: json['totalPrice'],
      status: json['status'],
      paymentStatus: json['paymentStatus'],
      pickupLocation: BookingLocation.fromJson(json['pickupLocation']),
      dropLocation: BookingLocation.fromJson(json['dropLocation']),
      otp: json['otp'],
    );
  }
}

class BookingLocation {
  final String address;
  final List<double> coordinates;

  BookingLocation({
    required this.address,
    required this.coordinates,
  });

  factory BookingLocation.fromJson(Map<String, dynamic> json) {
    return BookingLocation(
      address: json['address'],
      coordinates: List<double>.from(json['coordinates'].map((x) => x.toDouble())),
    );
  }
}
