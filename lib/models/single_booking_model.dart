// single_booking_model.dart

// ================== HELPERS ==================

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  try {
    return DateTime.parse(value.toString());
  } catch (_) {
    return null;
  }
}

int _parseInt(dynamic value, {int defaultValue = 0}) {
  if (value == null) return defaultValue;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? defaultValue;
  return defaultValue;
}

// ================== USER ==================

class User {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final UserDocuments? documents;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    this.documents,
  });

  factory User.fromJson(dynamic json) {
    if (json is! Map) {
      return User(id: '', name: '', email: '', mobile: '');
    }

    return User(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      documents: json['documents'] is Map
          ? UserDocuments.fromJson(json['documents'])
          : null,
    );
  }
}

class UserDocuments {
  final Document? aadharCard;
  final Document? drivingLicense;

  UserDocuments({this.aadharCard, this.drivingLicense});

  factory UserDocuments.fromJson(Map<String, dynamic> json) {
    return UserDocuments(
      aadharCard: json['aadharCard'] is Map
          ? Document.fromJson(json['aadharCard'])
          : null,
      drivingLicense: json['drivingLicense'] is Map
          ? Document.fromJson(json['drivingLicense'])
          : null,
    );
  }
}

class Document {
  final String? url;
  final DateTime? uploadedAt;
  final String status;

  Document({
    this.url,
    this.uploadedAt,
    required this.status,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      url: json['url']?.toString(),
      uploadedAt: _parseDate(json['uploadedAt']),
      status: json['status']?.toString() ?? 'pending',
    );
  }
}

// ================== MEDIA ==================

class DepositProof {
  final String? id;
  final String? url;
  final String? label;

  DepositProof({this.id, this.url, this.label});

  factory DepositProof.fromJson(dynamic json) {
    if (json is! Map) return DepositProof();
    return DepositProof(
      id: json['_id']?.toString(),
      url: json['url']?.toString(),
      label: json['label']?.toString(),
    );
  }
}

class CarImageBeforePickup {
  final String? id;
  final String? url;
  final DateTime? uploadedAt;

  CarImageBeforePickup({this.id, this.url, this.uploadedAt});

  factory CarImageBeforePickup.fromJson(dynamic json) {
    if (json is! Map) return CarImageBeforePickup();
    return CarImageBeforePickup(
      id: json['_id']?.toString(),
      url: json['url']?.toString(),
      uploadedAt: _parseDate(json['uploadedAt']),
    );
  }
}

class CarReturnImage {
  final String? id;
  final String? url;
  final DateTime? uploadedAt;

  CarReturnImage({this.id, this.url, this.uploadedAt});

  factory CarReturnImage.fromJson(dynamic json) {
    if (json is! Map) return CarReturnImage();
    return CarReturnImage(
      id: json['_id']?.toString(),
      url: json['url']?.toString(),
      uploadedAt: _parseDate(json['uploadedAt']),
    );
  }
}

// ================== CAR ==================

class Car {
  final String id;
  final String carName;
  final String model;
  final int pricePerHour;
  final String location;
  final String type;
  final int seats;
  final List<String> carImage;
  final String vehicleNumber;
  final int delayPerHour;
  final int delayPerDay;

  Car({
    required this.id,
    required this.carName,
    required this.model,
    required this.pricePerHour,
    required this.location,
    required this.type,
    required this.seats,
    required this.carImage,
    required this.vehicleNumber,
    required this.delayPerHour,
    required this.delayPerDay,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['_id']?.toString() ?? '',
      carName: json['carName']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      pricePerHour: _parseInt(json['pricePerHour']),
      location: json['location']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      seats: _parseInt(json['seats']),
      carImage:
          (json['carImage'] as List? ?? []).map((e) => e.toString()).toList(),
      vehicleNumber: json['vehicleNumber']?.toString() ?? '',
      delayPerHour: _parseInt(json['delayPerHour']),
      delayPerDay: _parseInt(json['delayPerDay']),
    );
  }
}

// ================== CAR REPLACEMENT ==================

class CarReplacementHistory {
  final bool extraPaymentRequired;
  final int paymentAdjustment;
  final int staffPaymentDue;
  final String staffPaymentStatus;
  final DateTime? replacedAt;

  CarReplacementHistory({
    required this.extraPaymentRequired,
    required this.paymentAdjustment,
    required this.staffPaymentDue,
    required this.staffPaymentStatus,
    this.replacedAt,
  });

  factory CarReplacementHistory.fromJson(dynamic json) {
    if (json is! Map) return null as CarReplacementHistory;

    return CarReplacementHistory(
      extraPaymentRequired: json['extraPaymentRequired'] ?? false,
      paymentAdjustment: _parseInt(json['paymentAdjustment']),
      staffPaymentDue: _parseInt(json['staffPaymentDue']),
      staffPaymentStatus: json['staffPaymentStatus']?.toString() ?? 'pending',
      replacedAt: _parseDate(json['replacedAt']),
    );
  }
}

// ================== EXTENSION ==================

class BookingExtension {
  final int? hours;
  final int amount;
  final String transactionId;
  final String id;
  final DateTime extendedAt;
  final String? extendDeliveryDate;
  final String? extendDeliveryTime;

  BookingExtension({
    this.hours,
    required this.amount,
    required this.transactionId,
    required this.id,
    required this.extendedAt,
    this.extendDeliveryDate,
    this.extendDeliveryTime,
  });

  factory BookingExtension.fromJson(dynamic json) {
    if (json is! Map) {
      return BookingExtension(
        amount: 0,
        transactionId: '',
        id: '',
        extendedAt: DateTime.now(),
      );
    }

    return BookingExtension(
      hours: _parseInt(json['hours'], defaultValue: 0),
      amount: _parseInt(json['amount']),
      transactionId: json['transactionId']?.toString() ?? '',
      id: json['_id']?.toString() ?? '',
      extendedAt: _parseDate(json['extendedAt']) ?? DateTime.now(),
      extendDeliveryDate: json['extendDeliveryDate']?.toString(),
      extendDeliveryTime: json['extendDeliveryTime']?.toString(),
    );
  }
}

// ================== BOOKING ==================

class Booking {
  final String id;
  final User? userId;
  final String carId;
  final String rentalStartDate;
  final String rentalEndDate;
  final String from;
  final String to;
  final int totalPrice;
  final DateTime? deliveryDate;
  final String deliveryTime;
  final String status;
  final String paymentStatus;
  final int? otp;
  final int? returnOTP;
  final String? deposit;
  final String pickupLocation;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Car? car;
  final List<DepositProof> depositeProof;
  final List<CarImageBeforePickup> carImagesBeforePickup;
  final List<CarReturnImage> carReturnImages;
  final List<dynamic> returnDetails;
  final String? depositPDF;
  final String? finalBookingPDF;
  final List<BookingExtension> extensions;
  final CarReplacementHistory? carReplacementHistory;

  Booking({
    required this.id,
    this.userId,
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
    this.otp,
    this.returnOTP,
    this.deposit,
    required this.pickupLocation,
    required this.createdAt,
    required this.updatedAt,
    this.car,
    this.depositeProof = const [],
    this.carImagesBeforePickup = const [],
    this.carReturnImages = const [],
    this.returnDetails = const [],
    this.depositPDF,
    this.finalBookingPDF,
    this.extensions = const [],
    this.carReplacementHistory,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id']?.toString() ?? '',
      userId: json['userId'] is Map ? User.fromJson(json['userId']) : null,
      carId: json['carId']?.toString() ?? '',
      rentalStartDate: json['rentalStartDate']?.toString() ?? '',
      rentalEndDate: json['rentalEndDate']?.toString() ?? '',
      from: json['from']?.toString() ?? '',
      to: json['to']?.toString() ?? '',
      totalPrice: _parseInt(json['totalPrice']),
      deliveryDate: _parseDate(json['deliveryDate']),
      deliveryTime: json['deliveryTime']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      paymentStatus: json['paymentStatus']?.toString() ?? '',
      otp: json['otp'] is int ? json['otp'] : null,
      returnOTP: json['returnOTP'] is int ? json['returnOTP'] : null,
      deposit: json['deposit'] == "null" ? null : json['deposit']?.toString(),
      pickupLocation: json['pickupLocation']?.toString() ?? '',
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      car: json['car'] is Map ? Car.fromJson(json['car']) : null,
      depositeProof: (json['depositeProof'] as List? ?? [])
          .map((e) => DepositProof.fromJson(e))
          .toList(),
      carImagesBeforePickup: (json['carImagesBeforePickup'] as List? ?? [])
          .map((e) => CarImageBeforePickup.fromJson(e))
          .toList(),
      carReturnImages: (json['carReturnImages'] as List? ?? [])
          .map((e) => CarReturnImage.fromJson(e))
          .toList(),
      returnDetails: json['returnDetails'] as List? ?? [],
      depositPDF: json['depositPDF']?.toString(),
      finalBookingPDF: json['finalBookingPDF']?.toString(),
      extensions: (json['extensions'] as List? ?? [])
          .map((e) => BookingExtension.fromJson(e))
          .toList(),
      carReplacementHistory: json['carReplacementHistory'] is Map
          ? CarReplacementHistory.fromJson(json['carReplacementHistory'])
          : null,
    );
  }
}

// ================== RESPONSE ==================

class BookingResponse {
  final String message;
  final Booking booking;

  BookingResponse({
    required this.message,
    required this.booking,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      message: json['message']?.toString() ?? '',
      booking: Booking.fromJson(json['booking'] ?? {}),
    );
  }
}
