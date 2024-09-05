class User {
  final int UserId;
  final String UserName;
  final String PasswordHash;

  User({
    required this.UserId,
    required this.UserName,
    required this.PasswordHash,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      UserId: json['UserId'],
      UserName: json['UserName'],
      PasswordHash: json['PasswordHash'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'UserId': UserId,
      'UserName': UserName,
      'PasswordHash': PasswordHash,
    };
  }
}
