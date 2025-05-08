import 'dart:convert';
import 'dart:io';
import 'package:car_rental_staff_app/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';



class UserService {
  final String baseUrl = 'https://carrentalbackent.onrender.com/api';

  Future<List<UserModel>> fetchUser(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/users/get-user/$id'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to Load user');
    }
  }

Future<Map<String, dynamic>> updateProfileImage(File imageFile, String userId) async {
  final apiUrl = '$baseUrl/users/edit-profile/$userId';

  final dio = Dio();

  String mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
  String fileExtension = mimeType.split('/').last;

  FormData formData = FormData.fromMap({
    "profileImage": await MultipartFile.fromFile(
      imageFile.path,
      filename: "profile_${DateTime.now().millisecondsSinceEpoch}.$fileExtension",
      contentType: MediaType(mimeType.split('/')[0], mimeType.split('/')[1]),
    )
  });

  final response = await dio.put(
    apiUrl,
    data: formData,
    options: Options(headers: {
      "accept": "*/*",
      "Content-Type": "multipart/form-data",
    }),
  );

  if (response.statusCode == 200) {
    return response.data;
  } else {
    throw Exception('Failed to update profile image: ${response.data}');
  }
}

}
