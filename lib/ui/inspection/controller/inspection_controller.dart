import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:inspecoespoty/data/models/inspection_subtype_model.dart';
import 'package:inspecoespoty/data/models/inspection_type_model.dart';
import 'package:inspecoespoty/data/models/person_model.dart';
import 'package:inspecoespoty/data/services/inspection_subtype_service.dart';
import 'package:inspecoespoty/data/services/inspection_type_service.dart';
import 'package:inspecoespoty/data/services/person_service.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_alert.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_loading.dart';

class InspectionController extends GetxController {
  RxList<InspectionTypeModel> inspectionTypes = <InspectionTypeModel>[].obs;
  RxList<InspectionTypeModel> inspectionTypesFiltered = <InspectionTypeModel>[].obs;
  TextEditingController searchController = TextEditingController();
  @override
  void onInit() {
    fetchInspectionTypes();
    super.onInit();
    // Initialize any data or state here
  }

  void fetchInspectionTypes() async {
    try {
      List<InspectionTypeModel> fetchedInspectionTypes = await InspectionTypeService().fetchInspectionTypesService();
      inspectionTypes.assignAll(fetchedInspectionTypes);
      inspectionTypesFiltered.assignAll(fetchedInspectionTypes);
      if (searchController.text.isNotEmpty) {
        filterInspections(searchController.text);
      }
    } catch (e) {
      debugPrint('Error fetching inspectionTypes: $e');
      Get.snackbar('Erro', 'Erro ao buscar Tipos de Inspeção',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red.shade400,
      );
    }
  }

  Future<InspectionTypeModel?> getInspectionType({required String id}) async {
    try {
      return await InspectionTypeService().getInspectionType(id: id);
    } catch (e) {
      Get.snackbar('Erro', '$e');
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

  Future<List<InspectionSubtypeModel>?> getInspectionSubTypes({required String id}) async {
    try {
      return await InspectionSubtypeService().getInspectionSubtypes(id: id);
    } catch (e) {
      Get.snackbar('Erro', '$e');
    }
    return null;
  }

  Future<void> createInspectionType({required InspectionTypeModel inspectionType, required List<InspectionSubtypeModel> inspectionSubtypesCreated, required List<InspectionSubtypeModel> inspectionSubtypesUpdated}) async {
    Get.to(() => CustomLoading());
    await _delay(milliseconds: 400);
    try {
      final result = await InspectionTypeService().createInspectionType(inspectionType: inspectionType);
      print(result.id);
      for (var subtypeCreated in inspectionSubtypesCreated) {
        InspectionSubtypeModel newModel = subtypeCreated;
        newModel.inspectionTypeId = result.id!;
        await InspectionSubtypeService().createInspectionSubtype(inspectionSubtype: newModel);
      }
      for (var subtypeUpdated in inspectionSubtypesUpdated) {
        InspectionSubtypeModel newModel = subtypeUpdated;
        newModel.inspectionTypeId = result.id!;
        await InspectionSubtypeService().updateInspectionSubtype(inspectionSubtype: newModel);
      }
      Get.back();
      Get.back();
      await _delay();
      CustomAlert().successSnack('Tipo de Inspeção cadastrado');
      fetchInspectionTypes();
    } catch (e) {
      Get.back();
      CustomAlert().error(content: 'Falha ao cadastrar tipo de inspeção');

    }
  }

  Future<void> updateInspectionType({required InspectionTypeModel inspectionType,required List<InspectionSubtypeModel> inspectionSubtypesCreated, required List<InspectionSubtypeModel> inspectionSubtypesUpdated}) async {
    Get.to(() => CustomLoading());
    await _delay(milliseconds: 400);

    try {
      final result = await InspectionTypeService().updateInspectionType(inspectionType: inspectionType);
      for (var subtypeCreated in inspectionSubtypesCreated) {
        InspectionSubtypeModel newModel = subtypeCreated;
        newModel.inspectionTypeId = result.id!;
        await InspectionSubtypeService().createInspectionSubtype(inspectionSubtype: newModel);
      }
      for (var subtypeUpdated in inspectionSubtypesUpdated) {
        await InspectionSubtypeService().updateInspectionSubtype(inspectionSubtype: subtypeUpdated);
      }
      Get.back();
      Get.back();
      await _delay();
      CustomAlert().successSnack('Tipo de Inspeção atualizado');
      fetchInspectionTypes();
    } catch (e) {
      Get.back();
      CustomAlert().error(content: 'Falha ao atualizar tipo de inspeção');


    }
  }
  _delay ({int? milliseconds}) {
    return Future.delayed(Duration(milliseconds: milliseconds ?? 200));
  }
}

