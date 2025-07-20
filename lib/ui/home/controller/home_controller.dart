import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
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
  TextEditingController searchController = TextEditingController();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    fetchInspection();
    super.onInit();
    // Initialize any data or state here
  }

  void fetchInspection() async {
    isLoading.value = true;
    try {
      List<InspectionSimpleModel> fetchedInspectionTypes = await InspectionService().getInspections();
      inspection.assignAll(fetchedInspectionTypes);
    } catch (e) {
      debugPrint('Error fetching inspections: $e');
      Get.snackbar('Erro', 'Erro ao buscar as Inspeções',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red.shade400,
      );
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

  _delay ({int? milliseconds}) {
    return Future.delayed(Duration(milliseconds: milliseconds ?? 200));
  }
}

