import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspecoespoty/data/models/inspection_model.dart';
import 'package:inspecoespoty/data/models/inspection_type_model.dart';
import 'package:inspecoespoty/data/models/person_model.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_card.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_drawer.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_loading.dart';
import 'package:inspecoespoty/ui/home/controller/home_controller.dart';
import 'package:inspecoespoty/ui/home/widgets/home_register.dart';
import 'package:inspecoespoty/ui/inspection/controller/inspection_controller.dart';
import 'package:inspecoespoty/ui/inspection/widgets/inspection_register.dart';
import 'package:inspecoespoty/ui/person/controller/person_controller.dart';
import 'package:inspecoespoty/ui/person/widgets/person_register.dart';
import 'package:inspecoespoty/utils/config.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _buildSubtitle(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16),
        SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 14)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    final controller = Get.find<HomeController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Inspeções')),
      drawer: CustomDrawer(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),

        child: Column(
          children: [
            Obx(() {
              if (controller.isLoading.value) {
                return const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (controller.inspection.isEmpty) {
                Expanded(
                  child: Center(child: Text('Nenhum registro encontrado')),
                );
              }
              return Expanded(
                child: Column(
                  children: [
                    if (controller.inspection.isEmpty)
                      Expanded(
                        child: Center(
                          child: Text('Nenhum registro encontrado'),
                        ),
                      ),

                    if (controller.inspection.isNotEmpty)
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            controller.fetchInspection();
                          },
                          child: ListView.builder(
                            itemCount: controller.inspection.length,
                            itemBuilder: (context, index) {
                              final inspection = controller.inspection[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                child: CustomCard(
                                  color: (inspection.status == 'Pendente')
                                      ? Colors.yellow
                                      : (inspection.status == 'Cancelado') ? Colors.red.shade200 : Colors.blueGrey.shade200,
                                  title: inspection.status,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(inspection.inspectionType.name),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildSubtitle(
                                          Icons.paste_rounded,
                                          inspection.inspectionSubtype.name,
                                        ),
                                        _buildSubtitle(
                                          Icons.location_on,
                                          inspection.location.name,
                                        ),
                                        _buildSubtitle(
                                          Icons.person,
                                          inspection.inspector,
                                        ),
                                        _buildSubtitle(
                                          Icons.date_range,
                                          formatDate(inspection.date)
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () async {
                                    Get.to(() => CustomLoading());
                                    await Future.delayed(Duration(milliseconds: 200));
                                    InspectionModel? inspectionModel =
                                    await controller.getInspection(
                                      id: inspection.id,
                                    );


                                    if (inspectionModel != null) {
                                      Get.back();
                                      Get.to(
                                            () => HomeRegister(
                                          inspectionModel: inspectionModel,
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
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Get.to(() => HomeRegister());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
