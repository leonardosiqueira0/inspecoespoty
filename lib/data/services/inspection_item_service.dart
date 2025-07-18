import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inspecoespoty/data/models/inspection_item_model.dart';
import 'package:inspecoespoty/data/models/inspection_subtype_model.dart';
import 'package:inspecoespoty/data/models/inspection_type_model.dart';
import 'package:inspecoespoty/data/models/person_model.dart';
import 'package:inspecoespoty/data/services/api_service.dart';
import 'package:inspecoespoty/utils/config.dart';

class InspectionItemService {
  String route = '/InspectionItem';
  Future<List<InspectionItemModel>> getInspectionsItens({required String id}) async {
    try {
      final response = await ApiService.dio.get(
        '$route/$id',
      );
      return (response.data as List)
          .map((item) => InspectionItemModel.fromJson(item))
          .toList();
    } on DioException catch (e) {
      debugPrint('Erro ao carregar itens: $e');
      return [];
    }
    
    catch (e) {
      throw Exception('Erro ao carregar itens: $e');
    }
  }

  Future<InspectionItemModel?> getInspectionsItem({required String id}) async {
    try {
      final response = await ApiService.dio.get(
        route,
        queryParameters: {'id': id},
      );
      return InspectionItemModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('Erro ao carregar itens: $e');
      debugPrint(e.response.toString());
      return null;
    }

    catch (e) {
      throw Exception('Erro ao carregar itens: $e');
    }
  }

  Future<InspectionItemModel> createInspectionItem({required InspectionItemModel inspectionItem}) async {
    try {
      final response = await ApiService.dio.post(
        route,
        data: inspectionItem.toJsonCreate(),
      );
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw '${response.data}';
      }

      return InspectionItemModel.fromJson(response.data);
    } catch (e) {
      throw 'Erro ao criar item: $e';
    }
  }

  Future<InspectionItemModel> updateInspectionItem({required InspectionItemModel inspectionItem}) async {
    try {
      final response = await ApiService.dio.put(
        route,
        data: inspectionItem.toJson(),
      );
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw '${response.data}';
      }

      return InspectionItemModel.fromJson(response.data);
    } catch (e) {
      throw 'Erro ao criar subtipo de inspeção: $e';
    }
  }
  
}