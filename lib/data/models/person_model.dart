import 'package:inspecoespoty/data/models/location_model.dart';

class PersonModel {
  String? id;
  String name;
  String position;
  String mail;
  String locationID;
  LocationModel? location;

  PersonModel({this.id, required this.name, required this.position, required this.mail, required this.locationID, this.location});

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      mail: json['mail'],
      locationID: json['locationID'],
      location: json['location'] != null ? LocationModel.fromJson(json['location']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['position'] = position;
    data['mail'] = mail;
    data['locationID'] = locationID;
    return data;
  }

  Map<String, dynamic> toJsonCreate() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['position'] = position;
    data['mail'] = mail;
    data['locationID'] = locationID;
    return data;
  }
}
