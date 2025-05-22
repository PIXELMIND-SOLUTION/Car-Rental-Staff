import 'dart:convert';

import 'package:car_rental_staff_app/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthService{
  final String baseUrl = 'https://carrentalbackent.onrender.com/api';

  Future<UserModel?> login(String mobile) async {
    try{
          print("Mobile Number: $mobile");
    final response = await http.post(
      Uri.parse('https://carrentalbackent.onrender.com/api/staff/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'mobile':mobile}),
    );
    print('${response.statusCode}');

    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      print("datttttttttttttttt$data");
      return UserModel.fromJson(data['user']);
    }else{
      throw Exception("Login Failed");
    }
  }catch(e){
    print('Errrrrrrrrrrrr$e');
  }
    return null;
    }
}