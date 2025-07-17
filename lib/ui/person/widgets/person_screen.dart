import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspecoespoty/data/models/person_model.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_card.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_loading.dart';
import 'package:inspecoespoty/ui/person/controller/person_controller.dart';
import 'package:inspecoespoty/ui/person/widgets/person_register.dart';
import 'package:video_player/video_player.dart';

class PersonScreen extends StatefulWidget {
  const PersonScreen({super.key});

  @override
  State<PersonScreen> createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  @override
  Widget build(BuildContext context) {
    Get.put(PersonController());
    final controller = Get.find<PersonController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Pessoas')),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),

        child: Obx(
          () => Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: SearchBar(
                  hintText: 'Pesquisar',
                  controller: controller.searchController,
                  onChanged: (value) {
                    controller.filterPersons(value);
                  },
                  leading: const Icon(Icons.search),
                ),
              ),

              if (controller.persons.isEmpty)
                Expanded(
                  child: Center(child: Text('Nenhum registro encontrado')),
                ),

              if (controller.persons.isNotEmpty)
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      controller.fetchPersons();
                    },
                    child: ListView.builder(
                      itemCount: controller.personsFiltered.length,
                      itemBuilder: (context, index) {
                        final person = controller.personsFiltered[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: CustomCard(
                            child: ListTile(
                              title: Text(person.name),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Cargo: ${person.position}'),
                                  Text(
                                    'Localização: ${person.location?.name ?? 'Não especificado'}',
                                  ),
                                ],
                              ),
                              leading: CircleAvatar(child: Icon(Icons.person)),
                            ),
                            onTap: () async {
                              Get.to(() => CustomLoading()); // Abre o loading sem await
                              PersonModel? personToOpen = await controller.getPerson(id: person.id ?? '');
                              if (personToOpen != null) {
                                await Future.delayed(Duration(milliseconds: 600));
                                Get.back(); // Fecha o loading
                                Get.to(() => PersonRegister(personModel: personToOpen));
                              } else {
                                Get.back(); // Fecha o loading mesmo se não encontrar
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Get.to(() => PersonRegister());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

