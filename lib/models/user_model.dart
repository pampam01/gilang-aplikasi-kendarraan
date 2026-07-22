class UserModel {
  final String idUser;
  final String nama;
  final String username;
  final String email;
  final String nomorTelepon;
  final String role;
  final String statusAktif;

  UserModel({
    required this.idUser,
    required this.nama,
    required this.username,
    required this.email,
    required this.nomorTelepon,
    required this.role,
    required this.statusAktif,
  });

  UserModel copyWith({
    String? idUser,
    String? nama,
    String? username,
    String? email,
    String? nomorTelepon,
    String? role,
    String? statusAktif,
  }) {
    return UserModel(
      idUser: idUser ?? this.idUser,
      nama: nama ?? this.nama,
      username: username ?? this.username,
      email: email ?? this.email,
      nomorTelepon: nomorTelepon ?? this.nomorTelepon,
      role: role ?? this.role,
      statusAktif: statusAktif ?? this.statusAktif,
    );
  }
}
