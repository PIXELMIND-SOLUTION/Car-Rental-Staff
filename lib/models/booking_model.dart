// import "package:car_rental_staff_app/models/car_model.dart";

// class Booking {
//   final String id;
//   final String userId;
//   final Car car;
//   final DateTime rentalStartDate;
//   final DateTime rentalEndDate;
//   final int totalPrice;
//   final String status;
//   final String paymentStatus;
//   final BookingLocation pickupLocation;
//   final BookingLocation dropLocation;
//   final int otp;

//   Booking({
//     required this.id,
//     required this.userId,
//     required this.car,
//     required this.rentalStartDate,
//     required this.rentalEndDate,
//     required this.totalPrice,
//     required this.status,
//     required this.paymentStatus,
//     required this.pickupLocation,
//     required this.dropLocation,
//     required this.otp,
//   });

//   bool get isCompleted => status.toLowerCase() == 'completed';
//   bool get isCancelled => status.toLowerCase() == 'cancelled';
//   bool get isPending => status.toLowerCase() == 'pending';

//   factory Booking.fromJson(Map<String, dynamic> json) {
//     return Booking(
//       id: json['_id'],
//       // Handle userId when it's a map (full user object) or string (just the ID)
//       userId: json['userId'] is Map ? json['userId']['_id'] : json['userId'],
//       car: Car.fromJson(json['carId']),
//       rentalStartDate: DateTime.parse(json['rentalStartDate']),
//       rentalEndDate: DateTime.parse(json['rentalEndDate']),
//       totalPrice: json['totalPrice'],
//       status: json['status'],
//       paymentStatus: json['paymentStatus'],
//       pickupLocation: BookingLocation.fromJson(json['pickupLocation']),
//       dropLocation: BookingLocation.fromJson(json['dropLocation']),
//       otp: json['otp'],
//     );
//   }
// }

// class BookingLocation {
//   final String address;
//   final List<double> coordinates;

//   BookingLocation({
//     required this.address,
//     required this.coordinates,
//   });

//   factory BookingLocation.fromJson(Map<String, dynamic> json) {
//     return BookingLocation(
//       address: json['address'],
//       coordinates: List<double>.from(json['coordinates'].map((x) => x.toDouble())),
//     );
//   }
// }

// class BookingResponse {
//   final String message;
//   final List<Booking> bookings;

//   BookingResponse({required this.message, required this.bookings});

//   factory BookingResponse.fromJson(Map<String, dynamic> json) {
//     return BookingResponse(
//       message: json['message'],
//       bookings: List<Booking>.from(json['bookings'].map((x) => Booking.fromJson(x))),
//     );
//   }
// }

// class Booking {
//   final String id;
//   final User user;
//   final String carId;
//   final String rentalStartDate;
//   final String rentalEndDate;
//   final String from;
//   final String to;
//   final int totalPrice;
//   final String status;
//   final String paymentStatus;
//   final int otp;
//   final String pickupLocation;
//   final String createdAt;
//   final String updatedAt;
//   final Car car;

//   Booking({
//     required this.id,
//     required this.user,
//     required this.carId,
//     required this.rentalStartDate,
//     required this.rentalEndDate,
//     required this.from,
//     required this.to,
//     required this.totalPrice,
//     required this.status,
//     required this.paymentStatus,
//     required this.otp,
//     required this.pickupLocation,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.car,
//   });

//   factory Booking.fromJson(Map<String, dynamic> json) {
//     return Booking(
//       id: json['_id'],
//       user: User.fromJson(json['userId']),
//       carId: json['carId'],
//       rentalStartDate: json['rentalStartDate'],
//       rentalEndDate: json['rentalEndDate'],
//       from: json['from'],
//       to: json['to'],
//       totalPrice: json['totalPrice'],
//       status: json['status'],
//       paymentStatus: json['paymentStatus'],
//       otp: json['otp'],
//       pickupLocation: json['pickupLocation'],
//       createdAt: json['createdAt'],
//       updatedAt: json['updatedAt'],
//       car: Car.fromJson(json['car']),
//     );
//   }
// }

// class User {
//   final String id;
//   final String name;
//   final String email;

//   User({required this.id, required this.name, required this.email});

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['_id'],
//       name: json['name'],
//       email: json['email'],
//     );
//   }
// }

// class Car {
//   final String id;
//   final String carName;
//   final String model;
//   final int pricePerHour;
//   final String location;
//   final List<String> carImage;

//   Car({
//     required this.id,
//     required this.carName,
//     required this.model,
//     required this.pricePerHour,
//     required this.location,
//     required this.carImage,
//   });

//   factory Car.fromJson(Map<String, dynamic> json) {
//     return Car(
//       id: json['_id'],
//       carName: json['carName'],
//       model: json['model'],
//       pricePerHour: json['pricePerHour'],
//       location: json['location'],
//       carImage: List<String>.from(json['carImage']),
//     );
//   }
// }

import 'package:car_rental_staff_app/models/single_booking_model.dart';

class BookingResponse {
  final String message;
  final List<Booking> bookings;

  BookingResponse({required this.message, required this.bookings});

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      message: json['message'] ?? '',
      bookings: json['bookings'] != null
          ? List<Booking>.from(json['bookings']
              .where((x) => x != null)
              .map((x) => Booking.fromJson(x)))
          : [],
    );
  }
}

class Booking {
  final String id;
  final User? user; // Make nullable
  final String carId;
  final String rentalStartDate;
  final String rentalEndDate;
  final String from;
  final String to;
  final int totalPrice;
  final DateTime deliveryDate;
  final String deliveryTime;
  final String status;
  final String paymentStatus;
  final int otp;
  final String pickupLocation;
  final String createdAt;
  final String updatedAt;
  final Car? car; // Make nullable
  final List<BookingExtension> extensions;

  Booking({
    required this.id,
    this.user, // Remove required
    required this.carId,
    required this.rentalStartDate,
    required this.rentalEndDate,
    required this.from,
    required this.to,
    required this.totalPrice,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.status,
    required this.paymentStatus,
    required this.otp,
    required this.pickupLocation,
    required this.createdAt,
    required this.updatedAt,
    this.car, // Remove required
    required this.extensions,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'] ?? '',
      user: json['userId'] != null ? User.fromJson(json['userId']) : null,
      carId: json['carId'] ?? '',
      rentalStartDate: json['rentalStartDate'] ?? '',
      rentalEndDate: json['rentalEndDate'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      totalPrice: json['totalPrice'] ?? 0,
      deliveryDate: DateTime.parse(json['deliveryDate']),
      deliveryTime: json['deliveryTime'] ?? '',
      status: json['status'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      otp: json['otp'] ?? 0,
      pickupLocation: json['pickupLocation'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      car: json['car'] != null ? Car.fromJson(json['car']) : null,
      extensions: (json['extensions'] as List<dynamic>?)
              ?.map((e) => BookingExtension.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class Car {
  final String id;
  final String carName;
  final String model;
  final int pricePerHour;
  final String location;
  final List<String> carImage;

  Car({
    required this.id,
    required this.carName,
    required this.model,
    required this.pricePerHour,
    required this.location,
    required this.carImage,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['_id'] ?? '',
      carName: json['carName'] ?? '',
      model: json['model'] ?? '',
      pricePerHour: json['pricePerHour'] ?? 0,
      location: json['location'] ?? '',
      carImage:
          json['carImage'] != null ? List<String>.from(json['carImage']) : [],
    );
  }
}
