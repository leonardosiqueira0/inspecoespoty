import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:inspecoespoty/data/models/person_model.dart';
import 'package:inspecoespoty/data/services/person_service.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_alert.dart';

class PersonController extends GetxController {
  RxList<PersonModel> persons = <PersonModel>[].obs;
  RxList<PersonModel> personsFiltered = <PersonModel>[].obs;
  TextEditingController searchController = TextEditingController();
  @override
  void onInit() {
    fetchPersons();
    super.onInit();
    // Initialize any data or state here
  }

  void fetchPersons() async {
    try {
      List<PersonModel> fetchedPersons = await PersonService().fetchPerson();
      persons.assignAll(fetchedPersons);
      personsFiltered.assignAll(fetchedPersons);
      if (searchController.text.isNotEmpty) {
        filterPersons(searchController.text);
      }
    } catch (e) {
      debugPrint('Error fetching persons: $e');
      Get.snackbar('Erro', 'Erro ao buscar pessoas',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red.shade400,
      );
    }
  }

  Future<PersonModel?> getPerson({required String id}) async {
    try {
      return await PersonService().getPerson(id: id);
    } catch (e) {
      Get.snackbar('Erro', '$e');
    }
    return null;
  }

  void filterPersons(String query) async  {
    if (query.isEmpty) {
      personsFiltered.assignAll(persons);
    } else {
      List<PersonModel> filtered = persons.where((person) {
        return person.name.toLowerCase().contains(query.toLowerCase()) 
            || person.position.toLowerCase().contains(query.toLowerCase())
            ||( (person.location != null) ? person.location!.name.toLowerCase().contains(query.toLowerCase()) : false);
      }).toList();
      personsFiltered.assignAll(filtered);
    }
  }

  Future<void> createPerson(PersonModel person) async {
    try {
      await PersonService().createPerson(person: person);
      fetchPersons();
      Get.back();
      Get.snackbar('Sucesso', 'Pessoa cadastrada com sucesso', 
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.green.shade400,
      );
    } catch (e) {
      CustomAlert().error(title: 'Erro', content: '$e');
    }
  }

  Future<void> updatePerson(PersonModel person) async {
    try {
      await PersonService().updatePerson(person: person);
      fetchPersons();
      Get.back();
      Get.snackbar('Sucesso', 'Pessoa atualizada com sucesso', 
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.green.shade400,
      );
    } catch (e) {
      CustomAlert().error(title: 'Erro', content: '$e');
    }
  }

  
}