// // import 'package:car_rental_staff_app/services/api/booking_service.dart';
// // import 'package:flutter/material.dart';
// // import '../models/booking_model.dart';

// // class BookingProvider with ChangeNotifier {
// //   final BookingService _bookingService = BookingService();

// //   List<Booking> _bookings = [];
// //   bool _isLoading = false;

// //   List<Booking> get bookings => _bookings;
// //   bool get isLoading => _isLoading;

// //   Future<void> fetchTodayBookings() async {
// //     _isLoading = true;
// //     notifyListeners();

// //     try {
// //       _bookings = await _bookingService.fetchTodayBookings();
// //       print("Loaded ${_bookings.length} today's bookings");
// //     } catch (e) {
// //       print("Error loading bookings: $e");
// //     }

// //     _isLoading = false;
// //     notifyListeners();
// //   }
// // }





// import 'package:car_rental_staff_app/services/api/booking_service.dart';
// import 'package:flutter/material.dart';
// import '../models/booking_model.dart';

// class BookingProvider with ChangeNotifier {
//   final BookingService _bookingService = BookingService();

//   List<Booking> _todayBookings = [];
//   bool _isLoading = false;
//   String? _errorMessage;

//   List<Booking> get todayBookings => _todayBookings;
//   bool get isLoading => _isLoading;
//   bool get hasError => _errorMessage != null;
//   String? get errorMessage => _errorMessage;

//   // Statistics getters
//   int get completedBookings => 
//       _todayBookings.where((b) => b.paymentStatus.toLowerCase() == 'completed' || 
//                                   b.paymentStatus.toLowerCase() == 'paid').length;
  
//   int get pendingBookings => 
//       _todayBookings.where((b) => b.paymentStatus.toLowerCase() == 'pending').length;

//   double get totalRevenue => 
//       _todayBookings.where((b) => b.paymentStatus.toLowerCase() == 'completed' || 
//                                   b.paymentStatus.toLowerCase() == 'paid')
//                    .fold(0.0, (sum, booking) => sum + booking.totalPrice);

//   Future<void> fetchTodayBookings() async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();

//     try {
//       _todayBookings = await _bookingService.fetchTodayBookings();
//       debugPrint("Successfully loaded ${_todayBookings.length} today's bookings");
//     } catch (e) {
//       _errorMessage = e.toString();
//       debugPrint("Error loading bookings: $e");
//       _todayBookings = []; // Clear existing data on error
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // void clearError() {
//   //   _errorMessage = null;
//   //   notifyListeners();
//   // }

//   // // Method to get bookings by status
//   // List<Booking> getBookingsByStatus(String status) {
//   //   return _todayBookings.where((booking) => 
//   //       booking.paymentStatus.toLowerCase() == status.toLowerCase()).toList();
//   // }

//   // // Method to search bookings
//   // List<Booking> searchBookings(String query) {
//   //   if (query.isEmpty) return _todayBookings;
    
//   //   final lowerQuery = query.toLowerCase();
//   //   return _todayBookings.where((booking) =>
//   //       booking.car.carName.toLowerCase().contains(lowerQuery) ||
//   //       booking.car.model.toLowerCase().contains(lowerQuery) ||
//   //       booking.user.name.toLowerCase().contains(lowerQuery) ||
//   //       booking.user.email.toLowerCase().contains(lowerQuery)).toList();
//   // }
// }









import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:car_rental_staff_app/services/api/booking_service.dart';
import '../models/booking_model.dart';
import 'package:http/http.dart' as http;


class BookingProvider with ChangeNotifier {
  final BookingService _bookingService = BookingService();

  List<Booking> _todayBookings = [];
    List<dynamic> _bookingStatistics = [];

  bool _isLoading = false;
    bool _isStatisticsLoading = false;
  String? _statisticsErrorMessage;

  String? _errorMessage;

  List<Booking> get todayBookings => _todayBookings;
    List<dynamic> get bookingStatistics => _bookingStatistics;
      bool get isStatisticsLoading => _isStatisticsLoading;
  String? get statisticsErrorMessage => _statisticsErrorMessage;


  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get completedBookings => _todayBookings
      .where((b) => b.paymentStatus.toLowerCase() == 'completed' || b.paymentStatus.toLowerCase() == 'paid')
      .length;

  int get pendingBookings => _todayBookings
      .where((b) => b.paymentStatus.toLowerCase() == 'pending')
      .length;

  double get totalRevenue => _todayBookings
      .where((b) => b.paymentStatus.toLowerCase() == 'completed' || b.paymentStatus.toLowerCase() == 'paid')
      .fold(0.0, (sum, b) => sum + b.totalPrice);

  Future<void> fetchTodayBookings() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _todayBookings = await _bookingService.fetchTodayBookings();
    } catch (e) {
      _errorMessage = e.toString();
      _todayBookings = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


   Future<void> fetchBookingStatistics() async {
    _isStatisticsLoading = true;
    _statisticsErrorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://carrentalbackent.onrender.com/api/staff/staticsbookings'),
        headers: {
          'Content-Type': 'application/json',
          // Add authorization headers if needed
          // 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _bookingStatistics = data['statistics'] ?? [];
        print('stsssssssssssssssssssssssssssssssssssssssssssssssss$_bookingStatistics');
        _statisticsErrorMessage = null;
      } else {
        _statisticsErrorMessage = 'Failed to load booking statistics';
        _bookingStatistics = [];
      }
    } catch (e) {
      _statisticsErrorMessage = 'Network error: ${e.toString()}';
      _bookingStatistics = [];
    } finally {
      _isStatisticsLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshAllData() async {
    await Future.wait([
      fetchTodayBookings(),
      fetchBookingStatistics(),
    ]);
  }

  // Clear error messages
  void clearErrors() {
    _errorMessage = null;
    _statisticsErrorMessage = null;
    notifyListeners();
  }
}
