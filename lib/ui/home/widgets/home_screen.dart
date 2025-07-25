import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspecoespoty/data/models/inspection_model.dart';
import 'package:inspecoespoty/data/models/inspection_type_model.dart';
import 'package:inspecoespoty/data/models/location_model.dart';
import 'package:inspecoespoty/data/models/person_model.dart';
import 'package:inspecoespoty/data/services/location_service.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_button.dart';
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
  RxBool click = false.obs;
  _buildSubtitle(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16),
        SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 14)),
      ],
    );
  }

  _buildFilter() async {
    final controller = Get.find<HomeController>();
    DateTime? selectedStartDate;
    DateTime? selectedEndDate;
    InspectionTypeModel? selectedType;
    String? selectedLocation;
    String? selectedInspector;
    Get.put(InspectionController());
    List<LocationModel> locations = await LocationService().fetchLocation();

    selectedStartDate = controller.startDate;
    selectedEndDate = controller.endDate;
    selectedType = controller.inspectionType;
    selectedLocation = controller.location;
    selectedInspector = controller.inspector;


    Get.dialog(
      Center(
        child: Material(
          borderRadius: BorderRadius.circular(4),
          child: Container(
            width: MediaQuery.sizeOf(context).width * 0.8,
            padding: const EdgeInsets.all(24.0),
            child: StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Filtros',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: 
                              () {
                                setState(() {
                                  selectedStartDate = null;
                                  selectedEndDate = null;
                                  selectedType = null;
                                  selectedLocation = null;
                                  selectedInspector = null;
                                });
                              },
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Data de início
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Data inicial',
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              controller: TextEditingController(
                                text: selectedStartDate != null
                                    ? formatDate(selectedStartDate!)
                                    : '',
                              ),
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      selectedStartDate ?? DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  setState(() => selectedStartDate = picked);
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Data final',
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              controller: TextEditingController(
                                text: selectedEndDate != null
                                    ? formatDate(selectedEndDate!)
                                    : '',
                              ),
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      selectedEndDate ?? DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  setState(() => selectedEndDate = picked);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Tipo de inspeção
                      DropdownButtonFormField<InspectionTypeModel>(
                        value: selectedType,
                        decoration: InputDecoration(
                          labelText: 'Tipo de inspeção',
                        ),
                        items: Get.find<InspectionController>().inspectionTypes
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(type.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => selectedType = value),
                      ),
                      SizedBox(height: 16),
                      // Localização
                      DropdownButtonFormField<String>(
                        value: selectedLocation,
                        decoration: InputDecoration(labelText: 'Localização'),
                        items: locations
                            .map(
                              (loc) => DropdownMenuItem(
                                value: loc.name,
                                child: Text(loc.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => selectedLocation = value),
                      ),
                      SizedBox(height: 16),
                      // Inspetor
                      DropdownButtonFormField<String>(
                        value: selectedInspector,
                        decoration: InputDecoration(labelText: 'Inspetor'),
                        items: ['Fernando Regino', 'Jesse Freitas']
                            .map(
                              (insp) => DropdownMenuItem(
                                value: insp,
                                child: Text(insp),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => selectedInspector = value),
                      ),
                      SizedBox(height: 24),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        height: 50,
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                content: 'Cancelar',
                                onTap: () {
                                  Get.back();
                                },
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: CustomButton(
                                content: 'Aplicar Filtros',
                                onTap: () {
                                  controller.startDate = selectedStartDate;
                                  controller.endDate = selectedEndDate;
                                  controller.inspectionType = selectedType;
                                  controller.location = selectedLocation;
                                  controller.inspector = selectedInspector;
                                  controller.applyFilters();
                                  Get.back();
                                },
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    final controller = Get.find<HomeController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspeções'),
        actions: [
          IconButton(
            onPressed: _buildFilter,
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
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
              if (controller.filteredInspections.isEmpty) {
                Expanded(
                  child: Center(child: Text('Nenhum registro encontrado')),
                );
              }
              return Expanded(
                child: Column(
                  children: [
                    if (controller.filteredInspections.isEmpty)
                      Expanded(
                        child: Center(
                          child: Text('Nenhum registro encontrado'),
                        ),
                      ),

                    if (controller.filteredInspections.isNotEmpty)
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            controller.fetchInspection();
                          },
                          child: Obx(
                            () => ListView.builder(
                              itemCount: controller.filteredInspections.length,
                              itemBuilder: (context, index) {
                                final inspection =
                                    controller.filteredInspections[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                  ),
                                  child: CustomCard(
                                    color: (inspection.status == 'Pendente')
                                        ? Colors.yellow
                                        : (inspection.status == 'Cancelado')
                                        ? Colors.red.shade200
                                        : Colors.blueGrey.shade200,
                                    title: inspection.status,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        inspection.inspectionType.name,
                                      ),
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
                                            formatDateMinimal(inspection.date),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () async {
                                      if (click.value == false) {
                                        click.value = true;

                                        Get.to(() => CustomLoading());
                                        await Future.delayed(
                                          Duration(milliseconds: 200),
                                        );
                                        InspectionModel? inspectionModel =
                                            await controller.getInspection(
                                              id: inspection.id,
                                            );

                                        if (inspectionModel != null) {
                                          Get.back();
                                          await Get.to(
                                            () => HomeRegister(
                                              inspectionModel: inspectionModel,
                                            ),
                                          );
                                        } else {
                                          Get.back();
                                        }
                                        click.value = false;
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
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
