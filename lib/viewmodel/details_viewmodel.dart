// To parse this JSON data, do
//
//     final details = detailsFromJson(jsonString);

import 'dart:convert';

List<Details> detailsFromJson(String str) => List<Details>.from(json.decode(str).map((x) => Details.fromJson(x)));

String detailsToJson(List<Details> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Details {
    Details({
        this.name,
        this.age,
    });

    String name;
    int age;

    factory Details.fromJson(Map<String, dynamic> json) => Details(
        name: json["name"] == null ? null : json["name"],
        age: json["age"] == null ? null : json["age"],
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "age": age == null ? null : age,
    };
}

var detail = List<Details>();
