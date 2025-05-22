import 'dart:convert';
import 'package:car_rental_staff_app/models/booking_model.dart';
import 'package:http/http.dart' as http;

class BookingService {
  final String baseUrl = "https://carrentalbackent.onrender.com/api";

  Future<List<Booking>> fetchTodayBookings() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/staff/todaybookings"),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final bookingsJson = data['bookings'] as List;
        return bookingsJson.map((json) => Booking.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load bookings: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching bookings: $e');
    }
  }
}
