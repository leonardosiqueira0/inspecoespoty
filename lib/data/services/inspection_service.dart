import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inspecoespoty/data/models/inspection_checkitem_model.dart';
import 'package:inspecoespoty/data/models/inspection_item_model.dart';
import 'package:inspecoespoty/data/models/inspection_model.dart';
import 'package:inspecoespoty/data/models/inspection_subtype_model.dart';
import 'package:inspecoespoty/data/models/inspection_type_model.dart';
import 'package:inspecoespoty/data/models/person_model.dart';
import 'package:inspecoespoty/data/services/api_service.dart';
import 'package:inspecoespoty/utils/config.dart';

class InspectionService {
  String route = '/Inspection';
  Future<List<InspectionSimpleModel>> getInspections({String? location, String? status, DateTimeRange? dateRange}) async {
    try {
      Map<String, dynamic> queryParameters = {};
      if (location != null) {
        queryParameters['location'] = location;
      }
      if (status != null) {
        queryParameters['status'] = status;
      }
      if (dateRange != null) {
        queryParameters['dateTo'] = dateRange.start;
        queryParameters['dateFrom'] = dateRange.end;
      }

      final response = await ApiService.dio.get(
        route,
        queryParameters: queryParameters,
      );
      return (response.data as List)
          .map((item) => InspectionSimpleModel.fromJson(item))
          .toList();
    } on DioException catch (e) {
      debugPrint('Erro ao carregar as inspeções: $e');
      return [];
    }
    
    catch (e) {
      throw Exception('Erro ao carregar inspeções: $e');
    }
  }

  Future<List<InspectionCheckitemModel>> getCheckitems({required String id}) async {
    try {

      final response = await ApiService.dio.get(
        '$route/checkitem/$id',
      );
      return (response.data as List)
          .map((item) => InspectionCheckitemModel.fromJson(item))
          .toList();
    } on DioException catch (e) {
      debugPrint('Erro ao carregar os itens: $e');
      return [];
    }
    
    catch (e) {
      throw Exception('Erro ao carregar os itens: $e');
    }
  }

  Future<InspectionModel?> getInspection({required String id}) async {
    try {
      final response = await ApiService.dio.get(
        '$route/$id',
      );
      return InspectionModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('Erro ao carregar inspeção: $e');
      return null;
    }
    catch (e) {
      throw Exception('Erro ao carregar inspeção: $e');
    }
  }

  Future<bool> createInspection({required InspectionModel model}) async {
    try {
      final response = await ApiService.dio.post(
        route,
        data: model.toJsonCreate()
      );
      return true;
    } on DioException catch (e) {
      debugPrint('Erro ao criar inspeção: $e');
      return false;
    }
    catch (e) {
      throw Exception('Erro ao criar inspeção: $e');
      return false;
    }
  }

  Future<bool> cancelInspection({required InspectionModel model}) async {
    try {
      final response = await ApiService.dio.put(
          '$route/cancel/${model.id}',
      );
      return true;
    } on DioException catch (e) {
      debugPrint('Erro ao cancelar inspeção: $e');
      return false;
    }
    catch (e) {
      debugPrint('Erro ao cancelar inspeção: $e');
      return false;
    }
  }

  Future<bool> finalizeInspection({required InspectionModel model}) async {
    try {
      final response = await ApiService.dio.put(
        '$route/finalize/${model.id}',
      );
      return true;
    } on DioException catch (e) {
      debugPrint('Erro ao finalizar inspeção: $e');
      return false;
    }
    catch (e) {
      debugPrint('Erro ao finalizar inspeção: $e');
      return false;
    }
  }
  
  Future<bool> checkItem({required InspectionCheckitemModel model}) async {
    try {
      await ApiService.dio.put(
        '$route/checkitem',
        data: model.toJson(),
      );
      return true;
    } on DioException catch (e) {
      debugPrint('Erro ao realizar a checagem do item: $e');
      return false;
    }
    catch (e) {
      debugPrint('Erro ao realizar a checagem do item: $e');
      return false;
    }
  }
}