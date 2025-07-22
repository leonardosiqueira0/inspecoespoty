import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:inspecoespoty/data/models/inspection_item_model.dart';
import 'package:inspecoespoty/data/models/inspection_subtype_model.dart';
import 'package:inspecoespoty/data/models/inspection_type_model.dart';
import 'package:inspecoespoty/data/models/person_model.dart';
import 'package:inspecoespoty/data/services/inspection_type_service.dart';
import 'package:inspecoespoty/data/services/person_service.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_alert.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_loading.dart';

class InspectionController extends GetxController {
  RxList<InspectionTypeModel> inspectionTypes = <InspectionTypeModel>[].obs;
  RxList<InspectionTypeModel> inspectionTypesFiltered = <InspectionTypeModel>[].obs;
  TextEditingController searchController = TextEditingController();
  RxBool isLoading = false.obs;
  @override
  void onInit() {
    fetchInspectionTypes();
    super.onInit();
    // Initialize any data or state here
  }

  void fetchInspectionTypes() async {
    isLoading.value = true;
    try {
      List<InspectionTypeModel> fetchedInspectionTypes = await InspectionTypeService().fetchInspectionTypesService();
      inspectionTypes.assignAll(fetchedInspectionTypes);
      inspectionTypesFiltered.assignAll(fetchedInspectionTypes);
      if (searchController.text.isNotEmpty) {
        filterInspections(searchController.text);
      }
    } catch (e) {
      debugPrint('Error fetching inspectionTypes: $e');
      CustomAlert().errorSnack('Erro ao buscar Tipos de Inspeção');
    } finally {
      isLoading.value = false;

    }
  }

  Future<InspectionTypeModel?> getInspectionType({required String id}) async {
    try {
      return await InspectionTypeService().getInspectionType(id: id);
    } catch (e) {
      CustomAlert().errorSnack('$e');
    }
    return null;
  }

  void filterInspections(String query) async  {
    if (query.isEmpty) {
      inspectionTypesFiltered.assignAll(inspectionTypes);
    } else {
      List<InspectionTypeModel> filtered = inspectionTypes.where((inspectionType) {
        return inspectionType.name.toLowerCase().contains(query.toLowerCase()) ;
      }).toList();
      inspectionTypesFiltered.assignAll(filtered);
    }
  }


  Future<void> createInspectionType({required InspectionTypeModel inspectionType, required List<InspectionSubtypeModel> inspectionSubtypesCreated, required List<InspectionSubtypeModel> inspectionSubtypesUpdated}) async {
    Get.to(() => CustomLoading());
    await _delay(milliseconds: 200);
    try {
      final result = await InspectionTypeService().createOrAlterInspectionType(inspectionType: inspectionType);
      Get.back();
      await _delay(milliseconds: 100);
      Get.back();
      await _delay();
      CustomAlert().successSnack('Tipo de Inspeção cadastrado');
      fetchInspectionTypes();
    } catch (e) {
      Get.back();
      CustomAlert().error(content: 'Falha ao cadastrar tipo de inspeção');

    }
  }
  _delay ({int? milliseconds}) {
    return Future.delayed(Duration(milliseconds: milliseconds ?? 200));
  }
}

