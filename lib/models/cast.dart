class Cast {
  String name;
  String originalName;
  String character;
  String? profilePath;
  int id;

  Cast(
      {required this.name,
      required this.originalName,
      required this.character,
      this.profilePath,
      required this.id});

  factory Cast.fromJson(Map<String, dynamic> castJson) {
    return Cast(
        name: castJson["name"],
        originalName: castJson["original_name"],
        character: castJson["character"],
        profilePath: castJson["profile_path"],
        id: castJson["id"].toInt());
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'character': character,
        'profile_path': profilePath,
        'original_name': originalName,
      };
}
