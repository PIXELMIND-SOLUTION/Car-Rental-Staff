




import 'dart:convert';
import 'package:car_rental_staff_app/models/single_booking_model.dart';
import 'package:http/http.dart' as http;

class SingleBookingService {
  static const String baseUrl = 'http://194.164.148.244:4062/api';

  Future<BookingResponse?> getSingleBooking(String bookingId) async {

    print('llllllllllllllllllllllllllllll$bookingId');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/staff/singlebooking/$bookingId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo${response.statusCode}');


      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
                    print('oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo${data}');

        return BookingResponse.fromJson(data);
      } else {
        throw Exception('Failed to load booking: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching booking: $e');
      return null;
    }
  }

  Future<List<Booking>?> getAllBookings() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/staff/activebookings'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> bookingsJson = data['bookings'] ?? [];
                print("llllllllllllllllllllllllllllllllllllllllllllll${data['bookings']}");

        return bookingsJson.map((json) => Booking.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load bookings: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching bookings: $e');
      return null;
    }
  }

  // New method for fetching bookings with status and optional date
  Future<List<Booking>?> getBookingsWithStatusAndDate(String status, {String? date}) async {
    print('ssssssssssssssssssssssssssssssss$status');
        print('ssssssssssssssssssssssssssssssss$date');

    try {
      // Construct query parameters - only add date if provided
      Map<String, String> queryParams = {'status': status};
      if (date != null) {
        queryParams['date'] = date;
      }

      final uri = Uri.parse('$baseUrl/staff/activebookings').replace(
        queryParameters: queryParams,
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> bookingsJson = data['bookings'] ?? [];
                        print("llllllllllllllllllllllllllllllllllllllllllllll${data['bookings']}");

        return bookingsJson.map((json) => Booking.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load bookings: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching bookings with status and date: $e');
      return null;
    }
  }

  Future<bool> updateBookingStatus(String bookingId, String status) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/staff/booking/$bookingId/status'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'status': status}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating booking status: $e');
      return false;
    }
  }
}