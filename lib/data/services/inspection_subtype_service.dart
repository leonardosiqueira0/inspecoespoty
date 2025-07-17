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

  Future<void> createInspectionType({required InspectionTypeModel inspectionType}) async {
    try {
      final response = await ApiService.dio.post(
        route,
        data: inspectionType.toJsonCreate(),
      );
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw '${response.data}';
      }
    } catch (e) {
      throw 'Erro ao criar tipo de inspeção: $e';
    }
  }

  Future<void> updatePerson({required PersonModel person}) async {
    try {
      final response = await ApiService.dio.post(
        '/person',
        data: person.toJson(),
      );
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw '${response.data}';
      }
    } catch (e) {
      throw 'Erro ao atualizar pessoa: $e';
    }
  }
  
}