
class UserModel {
  final String id;
  final String mobile;
  final String name;
  final List<String> myBookings;
  final String? profileImage;

  UserModel({
    required this.id,
    required this.mobile,
    required this.name,
    required this.myBookings,
    this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      mobile: json['mobile'],
      name: json['name'],
      myBookings: List<String>.from(json['myBookings']),
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      '_id': id,
      'mobile': mobile,
      'name': name,
      'myBookings': myBookings,
    };

    if (profileImage != null && profileImage!.isNotEmpty) {
      data['profileImage'] = profileImage!;
    }

    return data;
  }

  // ✅ Add this copyWith method
  UserModel copyWith({
    String? id,
    String? mobile,
    String? name,
    List<String>? myBookings,
    String? profileImage,
  }) {
    return UserModel(
      id: id ?? this.id,
      mobile: mobile ?? this.mobile,
      name: name ?? this.name,
      myBookings: myBookings ?? this.myBookings,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
