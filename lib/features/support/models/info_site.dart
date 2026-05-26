class InfoSite {
  final String? whatsapp;
  final String? email;
  final String? telephone;
  final String? confidentialite;

  InfoSite({
    this.whatsapp,
    this.email,
    this.telephone,
    this.confidentialite,
  });

  factory InfoSite.fromJson(Map<String, dynamic> json) {
    return InfoSite(
      whatsapp: json['whatsapp'],
      email: json['email'],
      telephone: json['telephone'],
      confidentialite: json['confidentialite'],
    );
  }
}
