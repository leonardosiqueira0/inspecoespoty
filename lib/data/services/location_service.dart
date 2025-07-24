import 'package:inspecoespoty/data/models/location_model.dart';
import 'package:inspecoespoty/data/services/api_service.dart';

class LocationService {
  // This class will handle operations related to person 
  // For example, fetching, updating, or deleting person records

  // Placeholder for a method to fetch person 
  Future<List<LocationModel>> fetchLocation() async {
    try {
      final response = await ApiService.dio.get(
        '/Location',
      );
      return (response.data as List)
          .map((item) => LocationModel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Erro ao carregar as Localizações: $e');
    }
  }

  Future<void> getLocation() async {
    // Implementation will go here
  }
}