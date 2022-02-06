import 'dart:convert';

List<Language> languageFromJson(String str) =>
    List<Language>.from(json.decode(str).map((x) => Language.fromJson(x)));

String languageToJson(List<Language> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Language {
  int? id;
  String? language;
  String? yearReleased;
  String? createdBy;
  String? image;
  int? isDone;

  Language({
    this.id,
    this.language,
    this.yearReleased,
    this.createdBy,
    this.image,
    this.isDone
  });

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        id: json["id"],
        language: json["language"],
        yearReleased: json["year_released"],
        createdBy: json["created_by"],
        image: json["image"],
        isDone: json["is_done"]
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "language": language,
        "year_released": yearReleased,
        "created_by": createdBy,
        "image": image,
        "is_done": isDone
      };
}