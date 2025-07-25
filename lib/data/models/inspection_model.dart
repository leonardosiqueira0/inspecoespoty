import 'package:inspecoespoty/data/models/inspection_checkitem_model.dart';
import 'package:inspecoespoty/data/models/inspection_item_model.dart';
import 'package:inspecoespoty/data/models/inspection_subtype_model.dart';
import 'package:inspecoespoty/data/models/inspection_type_model.dart';
import 'package:inspecoespoty/data/models/location_model.dart';
import 'package:inspecoespoty/data/models/person_model.dart';

class InspectionModel {
  String id;
  String inspector;
  LocationModel location;
  PersonModel manager;
  PersonModel? supervisor;
  DateTime date;
  InspectionTypeModel inspectionType;
  InspectionSubtypeModel inspectionSubtype;
  List<InspectionItemModel> inspectionItens;
  String status;
  List<InspectionCheckitemModel>? checkItems;

  InspectionModel({
    required this.id,
    required this.inspector,
    required this.location,
    required this.manager,
    this.supervisor,
    required this.date,
    required this.inspectionType,
    required this.inspectionSubtype,
    required this.inspectionItens,
    required this.status,
    this.checkItems,
  });

  factory InspectionModel.fromJson(Map<String, dynamic> json) {
    return InspectionModel(
      id: json['id'],
      inspector: json['inspector'],
      location: LocationModel.fromJson(json['location']),
      manager: PersonModel.fromJson(json['manager']),
      supervisor: json['supervisor'] != null
          ? PersonModel.fromJson(json['supervisor'])
          : null,
      date: DateTime.parse(json['date']),
      inspectionType: InspectionTypeModel.fromJson(json['inspectionType']),
      inspectionSubtype:
          InspectionSubtypeModel.fromJson(json['inspectionSubtype']),
      inspectionItens: (json['inspectionItems'] as List<dynamic>?)
              ?.map((item) {
                return InspectionItemModel.fromJson(item['inspectionItemModel']);

      })
              .toList() ??
          [],
      status: json['status'],
      checkItems: (json['inspectionItems'] as List<dynamic>?)
          ?.map((item) => InspectionCheckitemModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'inspector': inspector,
        'location': location.toJson(),
        'manager': manager.toJson(),
        'supervisor': supervisor?.toJson(),
        'date': date.toIso8601String(),
        'inspectionType': inspectionType.toJson(),
        'inspectionSubtype': inspectionSubtype.toJson(),
        'inspectionItems': inspectionItens.map((item) => item.toJson()).toList(),
        'status': status,
      };

  Map<String, dynamic> toJsonCreate() => {
    'id': id,
    'inspector': inspector,
    'locationID': location.id,
    'managerID': manager.id,
    if(supervisor != null) 'supervisorID': supervisor!.id,
    'date': date.toIso8601String(),
    'inspectionTypeID': inspectionType.id,
    'inspectionSubtypeID': inspectionSubtype.id,
    'inspectionItems': inspectionItens.map((item) => item.toJson()).toList(),
    'status': status,
  };

}

class InspectionSimpleModel {
  String id;
  String inspector;
  LocationModel location;
  DateTime date;
  InspectionTypeModel inspectionType;
  InspectionSubtypeModel inspectionSubtype;
  String status;

  InspectionSimpleModel({
    required this.id,
    required this.inspector,
    required this.location,
    required this.date,
    required this.inspectionType,
    required this.inspectionSubtype,
    required this.status,
  });

  factory InspectionSimpleModel.fromJson(Map<String, dynamic> json) {
    return InspectionSimpleModel(
      id: json['id'],
      inspector: json['inspector'],
      location: LocationModel.fromJson(json['location']),
      date: DateTime.parse(json['date']),
      inspectionType: InspectionTypeModel.fromJson(json['inspectionType']),
      inspectionSubtype:
      InspectionSubtypeModel.fromJson(json['inspectionSubtype']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'inspector': inspector,
    'location': location.toJson(),
    'date': date.toIso8601String(),
    'inspectionType': inspectionType.toJson(),
    'inspectionSubtype': inspectionSubtype.toJson(),
    'status': status,
  };
}
