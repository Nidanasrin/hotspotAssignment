// To parse this JSON data, do
//
//     final hotspot = hotspotFromJson(jsonString);

import 'dart:convert';

Hotspot hotspotFromJson(String str) => Hotspot.fromJson(json.decode(str));

String hotspotToJson(Hotspot data) => json.encode(data.toJson());

class Hotspot {
  String? message;
  Data? data;

  Hotspot({
    this.message,
    this.data,
  });

  factory Hotspot.fromJson(Map<String, dynamic> json) => Hotspot(
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  List<Experience>? experiences;

  Data({
    this.experiences,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    experiences: json["experiences"] == null ? [] : List<Experience>.from(json["experiences"]!.map((x) => Experience.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "experiences": experiences == null ? [] : List<dynamic>.from(experiences!.map((x) => x.toJson())),
  };
}

class Experience {
  int? id;
  String? name;
  String? tagline;
  String? description;
  String? imageUrl;
  String? iconUrl;
  int? order;

  Experience({
    this.id,
    this.name,
    this.tagline,
    this.description,
    this.imageUrl,
    this.iconUrl,
    this.order,
  });

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
    id: json["id"],
    name: json["name"],
    tagline: json["tagline"],
    description: json["description"],
    imageUrl: json["image_url"],
    iconUrl: json["icon_url"],
    order: json["order"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "tagline": tagline,
    "description": description,
    "image_url": imageUrl,
    "icon_url": iconUrl,
    "order": order,
  };
}
