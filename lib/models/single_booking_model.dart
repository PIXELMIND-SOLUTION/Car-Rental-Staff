


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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      documents: json['documents'] != null 
          ? UserDocuments.fromJson(json['documents'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      "mobile": mobile,
      'documents': documents?.toJson(),
    };
  }
}

class UserDocuments {
  final Document? aadharCard;
  final Document? drivingLicense;

  UserDocuments({
    this.aadharCard,
    this.drivingLicense,
  });

  factory UserDocuments.fromJson(Map<String, dynamic> json) {
    return UserDocuments(
      aadharCard: json['aadharCard'] != null 
          ? Document.fromJson(json['aadharCard'])
          : null,
      drivingLicense: json['drivingLicense'] != null 
          ? Document.fromJson(json['drivingLicense'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'aadharCard': aadharCard?.toJson(),
      'drivingLicense': drivingLicense?.toJson(),
    };
  }
}



class Document {
  final String? url;          // Make nullable
  final DateTime? uploadedAt; // Make nullable
  final String status;

  Document({
    this.url,               // Remove required
    this.uploadedAt,        // Remove required
    required this.status,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      url: json['url'],  // Remove ?? '' since it's now nullable
      uploadedAt: json['uploadedAt'] != null 
          ? DateTime.parse(json['uploadedAt'])
          : null,  // Allow null
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'uploadedAt': uploadedAt?.toIso8601String(),  // Handle null
      'status': status,
    };
  }
}


// New class for deposit proof images
class DepositProof {
  final String? id;
  final String? url;
  final String? label;

  DepositProof({
    this.id,
    this.url,
    this.label,
  });

  factory DepositProof.fromJson(Map<String, dynamic> json) {
    return DepositProof(
      id: json['_id'],
      url: json['url'],
      label: json['label'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'url': url,
      'label': label,
    };
  }
}

// New class for car images before pickup
class CarImageBeforePickup {
  final String? id;
  final String? url;
  final DateTime? uploadedAt;

  CarImageBeforePickup({
    this.id,
    this.url,
    this.uploadedAt,
  });

  factory CarImageBeforePickup.fromJson(Map<String, dynamic> json) {
    return CarImageBeforePickup(
      id: json['_id'],
      url: json['url'],
      uploadedAt: json['uploadedAt'] != null 
          ? DateTime.parse(json['uploadedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'url': url,
      'uploadedAt': uploadedAt?.toIso8601String(),
    };
  }
}

// New class for car return images (for future use)
class CarReturnImage {
  final String? id;
  final String? url;
  final DateTime? uploadedAt;

  CarReturnImage({
    this.id,
    this.url,
    this.uploadedAt,
  });

  factory CarReturnImage.fromJson(Map<String, dynamic> json) {
    return CarReturnImage(
      id: json['_id'],
      url: json['url'],
      uploadedAt: json['uploadedAt'] != null 
          ? DateTime.parse(json['uploadedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'url': url,
      'uploadedAt': uploadedAt?.toIso8601String(),
    };
  }
}

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

  Car({
    required this.id,
    required this.carName,
    required this.model,
    required this.pricePerHour,
    required this.location,
    required this.type,
    required this.seats,
    required this.carImage,
    required this.vehicleNumber
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['_id'] ?? '',
      carName: json['carName'] ?? '',
      model: json['model'] ?? '',
      pricePerHour: json['pricePerHour'] ?? 0,
      location: json['location'] ?? '',
      type: json['type'] ?? '',
      seats: json['seats']?? 0,
      carImage: List<String>.from(json['carImage'] ?? []),
      vehicleNumber: json['vehicleNumber']?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'carName': carName,
      'model': model,
      'pricePerHour': pricePerHour,
      'location': location,
      'type': type,
      'seats':seats,
      'carImage': carImage,
      'vehicleNumber': vehicleNumber
    };
  }
}

class Booking {
  final String id;
  final User? userId;
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
  final String? deposit;
  final String pickupLocation;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Car? car;
  final List<DepositProof> depositeProof; // Added deposit proof list
  final List<CarImageBeforePickup> carImagesBeforePickup; // Added car images before pickup
  final List<CarReturnImage> carReturnImages; // Added car return images
  final List<dynamic> returnDetails; // Added return details
  final String? depositPDF;
  final String? finalBookingPDF;
  final List<BookingExtension> extensions;

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
    required this.otp,
    this.deposit,
    required this.pickupLocation,
    required this.createdAt,
    required this.updatedAt,
    this.car,
    this.depositeProof = const [], // Default to empty list
    this.carImagesBeforePickup = const [], // Default to empty list
    this.carReturnImages = const [], // Default to empty list
    this.returnDetails = const [], // Default to empty list
    this.depositPDF,
    this.finalBookingPDF,
    required this.extensions,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'] ?? '',
      userId: json['userId'] != null ? User.fromJson(json['userId']) : null,
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
      deposit: json['deposit'] == "null" ? null : json['deposit'],
      pickupLocation: json['pickupLocation'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      car: json['car'] != null ? Car.fromJson(json['car']) : null,
      // Parse deposit proof list
      depositeProof: json['depositeProof'] != null
          ? (json['depositeProof'] as List)
              .map((item) => DepositProof.fromJson(item))
              .toList()
          : [],
      // Parse car images before pickup list
      carImagesBeforePickup: json['carImagesBeforePickup'] != null
          ? (json['carImagesBeforePickup'] as List)
              .map((item) => CarImageBeforePickup.fromJson(item))
              .toList()
          : [],
      // Parse car return images list
      carReturnImages: json['carReturnImages'] != null
          ? (json['carReturnImages'] as List)
              .map((item) => CarReturnImage.fromJson(item))
              .toList()
          : [],
      // Parse return details
      returnDetails: json['returnDetails'] ?? [],

      depositPDF: json['depositPDF'] == "null" ? null : json['depositPDF'],
            finalBookingPDF: json['finalBookingPDF'] == "null" ? null : json['finalBookingPDF'],
            extensions: (json['extensions'] as List<dynamic>?)?.map((e) => BookingExtension.fromJson(e)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId?.toJson(),
      'carId': carId,
      'rentalStartDate': rentalStartDate,
      'rentalEndDate': rentalEndDate,
      'from': from,
      'to': to,
      'totalPrice': totalPrice,
      'deliveryDate': deliveryDate,
      'deliveryTime': deliveryTime,
      'status': status,
      'paymentStatus': paymentStatus,
      'otp': otp,
      'deposit': deposit,
      'pickupLocation': pickupLocation,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'car': car?.toJson(),
      'depositeProof': depositeProof.map((item) => item.toJson()).toList(),
      'carImagesBeforePickup': carImagesBeforePickup.map((item) => item.toJson()).toList(),
      'carReturnImages': carReturnImages.map((item) => item.toJson()).toList(),
      'returnDetails': returnDetails,
      'depositPDF':depositPDF,
      'finalBookingPDF':finalBookingPDF
    };
  }
}

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

  factory BookingExtension.fromJson(Map<String, dynamic> json) {
    return BookingExtension(
      hours: json['hours'],
      amount: json['amount'] ?? 0,
      transactionId: json['transactionId'] ?? '',
      id: json['_id'] ?? '',
      extendedAt: DateTime.parse(json['extendedAt'] ?? DateTime.now().toIso8601String()),
      extendDeliveryDate: json['extendDeliveryDate'],
      extendDeliveryTime: json['extendDeliveryTime'],
    );
  }
}

class BookingResponse {
  final String message;
  final Booking booking;

  BookingResponse({
    required this.message,
    required this.booking,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      message: json['message'] ?? '',
      booking: Booking.fromJson(json['booking']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'booking': booking.toJson(),
    };
  }
}