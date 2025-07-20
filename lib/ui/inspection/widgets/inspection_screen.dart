import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspecoespoty/data/models/inspection_type_model.dart';
import 'package:inspecoespoty/data/models/person_model.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_card.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_loading.dart';
import 'package:inspecoespoty/ui/inspection/controller/inspection_controller.dart';
import 'package:inspecoespoty/ui/inspection/widgets/inspection_register.dart';
import 'package:inspecoespoty/ui/person/controller/person_controller.dart';
import 'package:inspecoespoty/ui/person/widgets/person_register.dart';
import 'package:video_player/video_player.dart';

class InspectionScreen extends StatefulWidget {
  const InspectionScreen({super.key});

  @override
  State<InspectionScreen> createState() => _InspectionScreenState();
}

class _InspectionScreenState extends State<InspectionScreen> {
  @override
  Widget build(BuildContext context) {
    Get.put(InspectionController());
    final controller = Get.find<InspectionController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Tipos de Inspeção')),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),

        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: SearchBar(
                hintText: 'Pesquisar',
                controller: controller.searchController,
                onChanged: (value) {
                  controller.filterInspections(value);
                },
                leading: const Icon(Icons.search),
              ),
            ),
            Obx(
              () {
                if (controller.isLoading.value) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (controller.inspectionTypesFiltered.isEmpty) {
                  Expanded(
                    child: Center(child: Text('Nenhum registro encontrado')),
                  );
              }
               return Expanded(
                child: Column(
                  children: [
                    if (controller.inspectionTypesFiltered.isEmpty)
                      Expanded(
                        child: Center(child: Text('Nenhum registro encontrado')),
                      ),

                    if (controller.inspectionTypesFiltered.isNotEmpty)
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            controller.fetchInspectionTypes();
                          },
                          child: ListView.builder(
                            itemCount: controller.inspectionTypesFiltered.length,
                            itemBuilder: (context, index) {
                              final inspectionType =
                                  controller.inspectionTypesFiltered[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: CustomCard(
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(inspectionType.name),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Tipo de Inspeção',
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            Icon(Icons.paste_rounded, size: 16),
                                            SizedBox(width: 4),
                                            Text(
                                              '${inspectionType.quantity} Subtipos cadastrados',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                  ),
                                  onTap: () async {
                                    Get.to(() => CustomLoading());
                                    await Future.delayed(Duration(milliseconds: 200));
                                    InspectionTypeModel? inspectionTypeModel =
                                        await controller.getInspectionType(
                                          id: inspectionType.id!,
                                        );

                                    if (inspectionTypeModel != null) {
                                      Get.back();
                                      Get.to(
                                        () => InspectionRegister(
                                          inspectionTypeModel: inspectionTypeModel,
                                        ),
                                      );
                                    } else {
                                      Get.back();
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
              );},
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Get.to(() => InspectionRegister());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
