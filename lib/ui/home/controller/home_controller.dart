import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:inspecoespoty/data/models/inspection_checkitem_model.dart';
import 'package:inspecoespoty/data/models/inspection_item_model.dart';
import 'package:inspecoespoty/data/models/inspection_model.dart';
import 'package:inspecoespoty/data/models/inspection_subtype_model.dart';
import 'package:inspecoespoty/data/models/inspection_type_model.dart';
import 'package:inspecoespoty/data/models/person_model.dart';
import 'package:inspecoespoty/data/services/inspection_service.dart';
import 'package:inspecoespoty/data/services/inspection_type_service.dart';
import 'package:inspecoespoty/data/services/person_service.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_alert.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_loading.dart';

class HomeController extends GetxController {
  RxList<InspectionSimpleModel> inspection = <InspectionSimpleModel>[].obs;
  RxList<InspectionSimpleModel> filteredInspections = <InspectionSimpleModel>[].obs;

  TextEditingController searchController = TextEditingController();
  RxBool isLoading = false.obs;

  DateTime? startDate;
  DateTime? endDate;
  InspectionTypeModel? inspectionType;
  String? location;
  String? inspector;

  @override
  void onInit() {
    fetchInspection();
    super.onInit();
    // Initialize any data or state here
  }

  void applyFilters() {
    filteredInspections.value = inspection.where((ins) {
      bool matches = true;
      if (startDate != null) {
        matches &= !ins.date.isBefore(startDate!);
      }
      if (endDate != null) {
        matches &= !ins.date.isAfter(endDate!);
      }
      if (inspectionType != null) {
        matches &= (ins.inspectionType.id == inspectionType!.id);
      }
      if (location != null && location!.isNotEmpty) {
        matches &= (ins.location.name == location);
      }
      if (inspector != null && inspector!.isNotEmpty) {
        matches &= (ins.inspector == inspector);
      }
      return matches;
    }).toList();
  }

  void fetchInspection() async {
    isLoading.value = true;
    try {
      List<InspectionSimpleModel> fetchedInspectionTypes = await InspectionService().getInspections();
      fetchedInspectionTypes.sort((a, b) => b.date.compareTo(a.date));
      inspection.assignAll(fetchedInspectionTypes);
      filteredInspections.assignAll(fetchedInspectionTypes);
    } catch (e) {
      debugPrint('Error fetching inspections: $e');
      CustomAlert().errorSnack('Erro ao buscar as Inspeções');
    } finally {
      isLoading.value = false;
    }
  }
  Future<InspectionModel?> getInspection({required String id}) async {
    try {
      InspectionModel? inspectionModel = await InspectionService().getInspection(id: id);
      if (inspectionModel == null) {
        throw Exception('Inspeção não encontrada');
      }
      return inspectionModel;
    } catch (e) {
      debugPrint('Error fetching inspections: $e');
      return null;
    }
  }

  Future<bool> createInspection({required InspectionModel model}) async {
    try {
      bool? inspectionModel = await InspectionService().createInspection(model: model);
      return inspectionModel;
    } catch (e) {
      debugPrint('Error fetching inspections: $e');
      return false;
    }
  }

  Future<bool> cancelInspection({required InspectionModel model}) async {
    try {
      bool? result = await InspectionService().cancelInspection(model: model);
      return result;
    } catch (e) {
      debugPrint('Error fetching inspections: $e');
      return false;
    }
  }

  Future<bool> finalizeInspection({required InspectionModel model}) async {
    try {
      bool? result = await InspectionService().finalizeInspection(model: model);
      return result;
    } catch (e) {
      debugPrint('Error fetching inspections: $e');
      return false;
    }
  }

  Future<bool> checkItem({required InspectionCheckitemModel model}) async {
    try {
      bool? result = await InspectionService().checkItem(model: model);
      return result;
    } catch (e) {
      debugPrint('Error fetching inspections: $e');
      return false;
    }
  }

  Future<List<InspectionCheckitemModel>> getCheckitens({required String id}) async {
    try {
      List<InspectionCheckitemModel> result = await InspectionService().getCheckitems(id: id);
      return result;
    } catch (e) {
      debugPrint('Error fetching inspections: $e');
      return [];
    }
  }

  _delay ({int? milliseconds}) {
    return Future.delayed(Duration(milliseconds: milliseconds ?? 200));
  }
}

