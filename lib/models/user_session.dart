class UserSession {
  String email;
  String idInstalador;

  UserSession(String email, String idInstalador) {
    this.email = email;
    this.idInstalador = idInstalador;
  }

  UserSession.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        idInstalador = json['idInstalador'];

  Map<String, dynamic> toJson() => {
        'email': email,
        'idInstalador': idInstalador,
      };
}
