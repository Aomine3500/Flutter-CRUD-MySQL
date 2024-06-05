// lib/models/client.dart
class Client {
  String? codeClient;
  String? nomClient;
  String? adresse;
  String? codepostal;
  String? ville;
  String? telephone;
  String? email;
  String? matricule;

  Client({
    required this.codeClient,
    required this.nomClient,
    required this.adresse,
    required this.codepostal,
    required this.ville,
    required this.telephone,
    required this.email,
    required this.matricule,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      codeClient: json['code_client'],
      nomClient: json['nom_client'],
      adresse: json['adresse'],
      codepostal: json['codepostal'],
      ville: json['ville'],
      telephone: json['téléphone'],
      email: json['email'],
      matricule: json['matricule'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code_client': codeClient,
      'nom_client': nomClient,
      'adresse': adresse,
      'codepostal': codepostal,
      'ville': ville,
      'téléphone': telephone,
      'email': email,
      'matricule': matricule,
    };
  }
}
