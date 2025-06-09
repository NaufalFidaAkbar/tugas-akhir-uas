class User {
  String? sId;
  String? email; // pakai email bukan username
  bool? isAdmin;
  String? token; // Kalau ingin simpan token di user

  User({
    this.sId,
    this.email,
    this.isAdmin,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      sId: json['_id'] ?? '',
      email: json['email'] ?? '',
      isAdmin: json['isAdmin'] ?? false,
      token: json['token'] ?? '', // Kalau token di dalam user, sesuaikan
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId ?? '',
      'email': email ?? '',
      'isAdmin': isAdmin ?? false,
      'token': token ?? '',
    };
  }
}
