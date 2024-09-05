class Admin {
  final int AdminId;
  final String AdminName;
  final String PasswordHash;

  Admin({
    required this.AdminId,
    required this.AdminName,
    required this.PasswordHash,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      AdminId: json['adminId'],
      AdminName: json['adminName'],
      PasswordHash: json['passwordHash'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'adminId': AdminId,
      'adminName': AdminName,
      'passwordHash': PasswordHash,
    };
  }
}
