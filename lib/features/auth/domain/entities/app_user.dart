class AppUser {
  final String uid;
  final String name;
  final String email;
  AppUser({required this.uid, required this.name, required this.email});

  // converting appuser to json
  Map<String, dynamic> toJson() {
    return {'uid': uid, 'name': name, 'email': email};
  }

  // converting json to appuser
  factory AppUser.fromMap(Map<String, dynamic> user) {
    return AppUser(uid: user['uid'], name: user['name'], email: user['email']);
  }
}
