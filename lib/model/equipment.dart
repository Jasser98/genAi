class Equipment {
  String? id;
  String nom;
  String? salle;
  String? emplacement;
  String? description;
  bool? disponibility;
  double? latitude;
  double? longitude;

  Equipment({
    this.id,
    required this.nom,
    this.salle,
    this.emplacement,
    this.description,
    this.disponibility,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'nom': nom,
      'salle': salle,
      'emplacement': emplacement,
      'description': description,
      'disponibility': disponibility,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Equipment.fromJson(Map map) {
    return Equipment(
      id: map['id'] != null ? map['id'] as String : null,
      nom: map['nom'] ?? '',
      salle: map['salle'] != null ? map['salle'] as String : null,
      emplacement:
          map['emplacement'] != null ? map['emplacement'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      disponibility:
          map['disponibility'] != null ? map['disponibility'] as bool : null,
      latitude: map['latitude'] != null ? map['latitude'] as double : null,
      longitude: map['longitude'] != null ? map['longitude'] as double : null,
    );
  }
}
