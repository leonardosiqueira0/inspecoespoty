import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inspecoespoty/data/models/inspection_type_model.dart';
import 'package:inspecoespoty/data/services/api_service.dart';
import 'package:inspecoespoty/utils/config.dart';

class InspectionTypeService {
  String route = '/InspectionType';
  Future<List<InspectionTypeModel>> fetchInspectionTypesService() async {
    try {
      final response = await ApiService.dio.get(
        '$route/${configUserModel?.departmentID}',
      );
      return (response.data as List)
          .map((item) => InspectionTypeModel.fromJson(item))
          .toList();
    } on DioException catch (e) {
      debugPrint('Erro ao carregar tipos de inspeção: $e');
      return [];
    }
    catch (e) {
      throw Exception('Erro ao carregar tipos de inspeção: $e');
    }
  }

  Future<InspectionTypeModel> getInspectionType({required String id}) async {
    try {
      final response = await ApiService.dio.get(
        route,
        queryParameters: {'id': id},
      );
      return InspectionTypeModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao carregar tipo de inspeção: $e');
    }
  }

  Future<InspectionTypeModel> createOrAlterInspectionType({required InspectionTypeModel inspectionType}) async {
    try {
      final response = await ApiService.dio.post(
        route,
        data: inspectionType.toJsonCreateOrAlter(),
      );
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw '${response.data}';
      }
      return InspectionTypeModel.fromJson(response.data);
    } catch (e) {
      throw 'Erro ao criar tipo de inspeção: $e';
    }
  }
}