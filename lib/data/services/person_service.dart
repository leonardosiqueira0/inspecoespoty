import 'package:dio/dio.dart';
import 'package:inspecoespoty/data/models/person_model.dart';
import 'package:inspecoespoty/data/services/api_service.dart';

class PersonService {
  // This class will handle operations related to person 
  // For example, fetching, updating, or deleting person records

  // Placeholder for a method to fetch person 
  Future<List<PersonModel>> fetchPerson() async {
    try {
      final response = await ApiService.dio.get(
        '/person',
      );
      return (response.data as List)
          .map((item) => PersonModel.fromJson(item))
          .toList();
    } on DioException {
      return [];
    }
    
    catch (e) {
      throw Exception('Erro ao carregar pessoas: $e');
    }
  }

  Future<PersonModel> getPerson({required String id}) async {
    try {
      final response = await ApiService.dio.get(
        '/person/$id',
      );
      return PersonModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao carregar pessoa: $e');
    }
  }

  Future<void> createPerson({required PersonModel person}) async {
    try {
      final response = await ApiService.dio.post(
        '/person',
        data: person.toJsonCreate(),
      );
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw '${response.data}';
      }
    } catch (e) {
      throw 'Erro ao criar pessoa: $e';
    }
  }

  Future<void> updatePerson({required PersonModel person}) async {
    try {
      final response = await ApiService.dio.put(
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