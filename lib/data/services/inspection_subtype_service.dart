import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inspecoespoty/data/models/inspection_subtype_model.dart';
import 'package:inspecoespoty/data/models/inspection_type_model.dart';
import 'package:inspecoespoty/data/models/person_model.dart';
import 'package:inspecoespoty/data/services/api_service.dart';
import 'package:inspecoespoty/utils/config.dart';

class InspectionSubtypeService {
  String route = '/InspectionSubtype';
  Future<List<InspectionSubtypeModel>> getInspectionSubtypes({required String id}) async {
    try {
      final response = await ApiService.dio.get(
        '/InspectionSubtype/$id',
      );
      return (response.data as List)
          .map((item) => InspectionSubtypeModel.fromJson(item))
          .toList();
    } on DioException catch (e) {
      debugPrint('Erro ao carregar subtipos de inspeção: $e');
      return [];
    }
    
    catch (e) {
      throw Exception('Erro ao carregar subtipos de inspeção: $e');
    }
  }

  Future<InspectionSubtypeModel?> getInspectionSubtype({required String id}) async {
    try {
      final response = await ApiService.dio.get(
        '/InspectionSubtype',
        queryParameters: {'id': id},
      );
      return InspectionSubtypeModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('Erro ao carregar subtipos de inspeção: $e');
      debugPrint(e.response.toString());
      return null;
    }

    catch (e) {
      throw Exception('Erro ao carregar subtipos de inspeção: $e');
    }
  }

  Future<InspectionSubtypeModel> createInspectionSubtype({required InspectionSubtypeModel inspectionSubtype}) async {
    try {
      final response = await ApiService.dio.post(
        route,
        data: inspectionSubtype.toJsonCreate(),
      );
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw '${response.data}';
      }

      return InspectionSubtypeModel.fromJson(response.data);
    } catch (e) {
      throw 'Erro ao criar subtipo de inspeção: $e';
    }
  }

  Future<InspectionSubtypeModel> updateInspectionSubtype({required InspectionSubtypeModel inspectionSubtype}) async {
    try {
      final response = await ApiService.dio.put(
        route,
        data: inspectionSubtype.toJson(),
      );
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw '${response.data}';
      }

      return InspectionSubtypeModel.fromJson(response.data);
    } catch (e) {
      throw 'Erro ao criar subtipo de inspeção: $e';
    }
  }
  
}