import 'inspection_item_model.dart';

class InspectionCheckitemModel {
  String id;
  String inspectionID;
  String inspectionItemId;
  InspectionItemModel? inspectionItemModel;
  String description;
  bool isAccordance;
  bool isChecked;
  List<String> images;

  InspectionCheckitemModel(
      {required this.id,
        required this.inspectionID,
        required this.inspectionItemId,
        required this.inspectionItemModel,
        required this.description,
        required this.isAccordance,
        required this.isChecked,
        required this.images});

  factory InspectionCheckitemModel.fromJson(Map<String, dynamic> json) {
    return InspectionCheckitemModel(
    id: json['id'],
    inspectionID: json['inspectionID'],
    inspectionItemId: json['inspectionItemId'],
    inspectionItemModel: (json['inspectionItemModel'] != null
        ? InspectionItemModel.fromJson(json['inspectionItemModel'])
        : null),
    description: json['description'],
    isAccordance: json['isAccordance'],
    isChecked: json['isChecked'],
    images: json['images'].cast<String>());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['inspectionID'] = inspectionID;
    data['inspectionItemId'] = inspectionItemId;
    if (inspectionItemModel != null) {
      data['inspectionItemModel'] = inspectionItemModel!.toJson();
    }
    data['description'] = description;
    data['isAccordance'] = isAccordance;
    data['isChecked'] = isChecked;
    data['images'] = images;
    return data;
  }
}