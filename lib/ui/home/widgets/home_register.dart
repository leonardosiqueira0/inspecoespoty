import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inspecoespoty/data/models/inspection_checkitem_model.dart';
import 'package:inspecoespoty/data/models/inspection_item_model.dart';
import 'package:inspecoespoty/data/models/inspection_model.dart';
import 'package:inspecoespoty/data/models/inspection_subtype_model.dart';
import 'package:inspecoespoty/data/models/inspection_type_model.dart';
import 'package:inspecoespoty/data/models/location_model.dart';
import 'package:inspecoespoty/data/models/person_model.dart';
import 'package:inspecoespoty/data/services/inspection_type_service.dart';
import 'package:inspecoespoty/data/services/location_service.dart';
import 'package:inspecoespoty/data/services/person_service.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_alert.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_button.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_loading.dart';
import 'package:inspecoespoty/ui/home/controller/home_controller.dart';
import 'package:inspecoespoty/ui/home/widgets/checklist_screen.dart';
import 'package:inspecoespoty/utils/config.dart';
import 'package:uuid/uuid.dart';

class HomeRegister extends StatefulWidget {
  HomeRegister({super.key, this.inspectionModel});

  InspectionModel? inspectionModel;

  @override
  State<HomeRegister> createState() => _HomeRegisterState();
  String id = '';
  final controller = Get.find<HomeController>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController inspectorController = TextEditingController();
  LocationModel? selectedLocation;
  PersonModel? selectedManager;
  PersonModel? selectedSupervisor;
  DateTime? selectedDate;
  InspectionTypeModel? selectedType;
  InspectionSubtypeModel? selectedSubtype;
  RxList<InspectionItemModel> items = <InspectionItemModel>[].obs;
  TextEditingController locationController = TextEditingController();
  TextEditingController managerController = TextEditingController();
  TextEditingController supervisorController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController subtypeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  RxList managers = [].obs;
  RxList supervisors = [].obs;
  RxList locations = [].obs;
  RxList inspectionTypes = [].obs;
  RxList inspectionSubtypes = [].obs;
  RxList itemsList = [].obs;
  RxBool loading = false.obs;
}

class _HomeRegisterState extends State<HomeRegister> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      if (widget.inspectionModel != null) {
        widget.loading.value = true;
        widget.inspectorController.text = widget.inspectionModel!.inspector;
        widget.selectedLocation = widget.inspectionModel!.location;
        widget.locationController.text = widget.inspectionModel!.location.name;
        widget.selectedManager = widget.inspectionModel!.manager;
        widget.managerController.text = widget.inspectionModel!.manager.name;
        widget.selectedSupervisor = widget.inspectionModel!.supervisor;
        widget.supervisorController.text =
            widget.inspectionModel!.supervisor?.name ?? '';
        widget.selectedDate = widget.inspectionModel!.date;
        widget.dateController.text = formatDate(widget.inspectionModel!.date);
        widget.selectedType = widget.inspectionModel!.inspectionType;
        widget.typeController.text =
            widget.inspectionModel!.inspectionType.name;
        widget.selectedSubtype = widget.inspectionModel!.inspectionSubtype;
        widget.subtypeController.text =
            widget.inspectionModel!.inspectionSubtype.name;
        widget.statusController.text = widget.inspectionModel!.status;

        InspectionTypeModel type = await InspectionTypeService()
            .getInspectionType(id: widget.inspectionModel!.inspectionType.id!);
        widget.inspectionSubtypes.assignAll(type.subtypes);
        widget.itemsList.assignAll(
          type.subtypes
              .firstWhere(
                (e) => e.id == widget.inspectionModel!.inspectionSubtype.id,
              )
              .inspectionItens!,
        );
        widget.items.assignAll(
          widget.inspectionModel!.inspectionItens.map(
            (item) => widget.itemsList.firstWhere(
              (i) => i.id == item.id,
              orElse: () => item,
            ),
          ),
        );
      }
      widget.id = widget.inspectionModel?.id ?? Uuid().v4();

      List<PersonModel> persons = await PersonService().fetchPerson();
      widget.managers.assignAll(
        persons.where((element) => element.position == 'Gerente'),
      );
      widget.supervisors.assignAll(
        persons.where((element) => element.position == 'Encarregado'),
      );
      widget.locations.assignAll(await LocationService().fetchLocation());
      widget.inspectionTypes.assignAll(
        await InspectionTypeService().fetchInspectionTypesService(),
      );
      widget.loading.value = false;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.inspectionModel != null
              ? 'Visualizar inspeção'
              : 'Cadastrar inspeção',
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height:
            MediaQuery.of(context).size.height -
            kToolbarHeight -
            MediaQuery.of(context).padding.top -
            MediaQuery.of(context).padding.bottom,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: widget.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.inspectionModel != null) SizedBox(height: 16),
                      if (widget.inspectionModel != null)
                        TextFormField(
                          controller: widget.statusController,
                          decoration: InputDecoration(labelText: 'Status'),
                          keyboardType: TextInputType.name,
                          readOnly: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z\s]'),
                            ),
                          ],
                        ),
                
                      SizedBox(height: 16),
                      DropdownMenu(
                        width: MediaQuery.of(context).size.width,
                        initialSelection: widget.inspectorController.text,
                        controller: widget.inspectorController,
                        enabled: widget.inspectionModel == null,
                        dropdownMenuEntries: [
                          DropdownMenuEntry<String>(
                            value: 'Fernando Regino',
                            label: 'Fernando Regino',
                          ),
                          DropdownMenuEntry<String>(
                            value: 'Jesse Freitas',
                            label: 'Jesse Freitas',
                          ),
                        ],
                        label: Text('Inspetor'),
                        onSelected: (value) {
                          if (value != null) {
                            widget.inspectorController.text = value;
                          }
                        },
                      ),
                
                      SizedBox(height: 16),
                
                      Obx(
                        () => DropdownMenu(
                          width: MediaQuery.of(context).size.width,
                          initialSelection: widget.selectedLocation,
                          controller: widget.locationController,
                          enabled: widget.inspectionModel == null,
                          dropdownMenuEntries: widget.locations
                              .map(
                                (location) => DropdownMenuEntry<LocationModel>(
                                  value: location,
                                  label: location.name,
                                ),
                              )
                              .toList(),
                          label: Text('Localização'),
                          onSelected: (value) {
                            if (value != null) {
                              widget.selectedLocation = value;
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                
                      Obx(
                        () => DropdownMenu(
                          width: MediaQuery.of(context).size.width,
                          initialSelection: widget.selectedManager,
                          controller: widget.managerController,
                          enabled: widget.inspectionModel == null,
                          dropdownMenuEntries: widget.managers
                              .map(
                                (manager) => DropdownMenuEntry<PersonModel>(
                                  value: manager,
                                  label: manager.name,
                                ),
                              )
                              .toList(),
                          label: Text('Gerente'),
                          onSelected: (value) {
                            if (value != null) {
                              widget.selectedManager = value;
                            }
                          },
                        ),
                      ),
                
                      SizedBox(height: 16),
                      Obx(
                        () => DropdownMenu(
                          width: MediaQuery.of(context).size.width,
                          initialSelection: widget.selectedSupervisor,
                          controller: widget.supervisorController,
                          enabled: widget.inspectionModel == null,
                
                          dropdownMenuEntries: widget.supervisors
                              .map(
                                (supervisor) => DropdownMenuEntry<PersonModel>(
                                  value: supervisor,
                                  label: supervisor.name,
                                ),
                              )
                              .toList(),
                          label: Text('Encarregado'),
                          onSelected: (value) {
                            if (value != null) {
                              widget.selectedSupervisor = value;
                            }
                          },
                        ),
                      ),
                
                      SizedBox(height: 16),
                      Obx(
                        () => DropdownMenu(
                          width: MediaQuery.of(context).size.width,
                          initialSelection: widget.selectedType,
                          controller: widget.typeController,
                          enabled: widget.inspectionModel == null,
                
                          dropdownMenuEntries: widget.inspectionTypes
                              .map(
                                (types) =>
                                    DropdownMenuEntry<InspectionTypeModel>(
                                      value: types,
                                      label: types.name,
                                    ),
                              )
                              .toList(),
                          label: Text('Tipo de inspeção'),
                          onSelected: (value) async {
                            if (value != null) {
                              widget.selectedType = null;
                              widget.subtypeController.clear();
                              widget.items.clear();
                              widget.itemsList.clear();
                
                              InspectionTypeModel type =
                                  await InspectionTypeService()
                                      .getInspectionType(id: value.id!);
                              widget.selectedType = value;
                              widget.inspectionSubtypes.assignAll(
                                type.subtypes,
                              );
                            }
                          },
                        ),
                      ),
                
                      SizedBox(height: 16),
                      Obx(
                        () => DropdownMenu(
                          width: MediaQuery.of(context).size.width,
                          initialSelection: widget.selectedSubtype,
                          controller: widget.subtypeController,
                          enabled: widget.inspectionModel == null,
                          dropdownMenuEntries: widget.inspectionSubtypes
                              .map(
                                (subtype) =>
                                    DropdownMenuEntry<InspectionSubtypeModel>(
                                      value: subtype,
                                      label: subtype.name,
                                    ),
                              )
                              .toList(),
                          label: Text('Subtipo de inspeção'),
                          onSelected: (value) {
                            if (value != null) {
                              widget.items.clear();
                              widget.selectedSubtype = value;
                              widget.itemsList.assignAll(
                                value.inspectionItens!,
                              );
                            }
                          },
                        ),
                      ),
                
                      SizedBox(height: 16),
                      Obx(() {
                        return ListTile(
                          title: Text('Itens Adicionados'),
                          subtitle: Text('${widget.items.length} Adicionados'),
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Icon(Icons.inventory, color: Colors.black87),
                          ),
                          trailing: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black87,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                            onPressed: () async {
                              if (widget.selectedSubtype == null) {
                                CustomAlert().error(
                                  content: 'Selecione um subtipo de inspeção',
                                );
                                return;
                              }
                              if (widget.itemsList.isEmpty) {
                                CustomAlert().error(
                                  content:
                                      'Nenhum item cadastrado neste subtipo',
                                );
                                return;
                              }
                              RxList<InspectionItemModel> addItems =
                                  <InspectionItemModel>[].obs;
                              addItems.assignAll(widget.items);
                              await Get.dialog(
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: MediaQuery.sizeOf(context).width,
                                    height: MediaQuery.sizeOf(context).height / 2,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Colors.white,
                                    ),
                                    child: Scaffold(
                                      backgroundColor: Colors.transparent,
                                      appBar: AppBar(
                                        automaticallyImplyLeading: false,
                                        backgroundColor: Colors.transparent,
                                        title: Text(
                                          widget.inspectionModel != null
                                              ? 'Visualizar Itens'
                                              : 'Selecionar itens',
                                          style: TextStyle(
                                            color: Colors.black87,
                                          ),
                                        ),
                                        actions: [
                                          IconButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            icon: Icon(
                                              Icons.close,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                      body: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Obx(() {
                                                return Container(
                                                  padding: EdgeInsets.all(8.0),
                                                  width: MediaQuery.sizeOf(
                                                    context,
                                                  ).width,
                                                  height: MediaQuery.sizeOf(
                                                    context,
                                                  ).height,
                                                  child: ListView.builder(
                                                    itemBuilder: (context, index) {
                                                      InspectionItemModel item =
                                                          widget
                                                              .itemsList[index];
                                                      return Obx(
                                                        () => InkWell(
                                                          onTap: () {
                                                            if (widget.inspectionModel == null) {
                                                            setState(() {
                                                              if (addItems
                                                                  .contains(
                                                                    item,
                                                                  )) {
                                                                addItems.remove(
                                                                  item,
                                                                );
                                                              } else {
                                                                addItems.add(
                                                                  item,
                                                                );
                                                              }
                                                            });}
                                                          },
                                                          child: ListTile(
                                                            title: Text(
                                                              item.name,
                                                            ),
                                                            trailing: Icon(
                                                              addItems.contains(
                                                                    item,
                                                                  )
                                                                  ? Icons
                                                                        .check_box
                                                                  : Icons
                                                                        .check_box_outline_blank,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    itemCount:
                                                        widget.itemsList.length,
                                                  ),
                                                );
                                              }),
                                            ),
                                          ),
                                          if (widget.inspectionModel != null)
                                            Text(
                                              'Você não pode alterar os itens de uma inspeção já cadastrada',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 12,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          if (widget.inspectionModel == null)
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: CustomButton(
                                                content: 'Salvar',
                                                onTap: () {
                                                  widget.items.assignAll(
                                                    addItems,
                                                  );
                                                  Get.back();
                                                },
                                              ),
                                            ),
                                          SizedBox(height: 8),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                              ),
                              child: Text(
                                widget.inspectionModel != null
                                    ? 'Visualizar'
                                    : 'Adicionar',
                                style: TextStyle(color: Colors.black87),
                              ),
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
              
            if (widget.inspectionModel == null)
              CustomButton(
                content: 'Salvar',
                onTap: () async {
                  if (widget.inspectorController.text.isEmpty ||
                      widget.selectedLocation == null ||
                      widget.selectedManager == null ||
                      widget.selectedType == null ||
                      widget.selectedSubtype == null ||
                      widget.items.isEmpty) {
                    CustomAlert().error(content: 'Preencha todos os campos');
                    return;
                  }
              
                  Get.to(() => CustomLoading());
                  InspectionModel inspectionModel = InspectionModel(
                    id: widget.id,
                    inspector: widget.inspectorController.text,
                    location: widget.selectedLocation!,
                    manager: widget.selectedManager!,
                    supervisor: widget.selectedSupervisor,
                    date: widget.selectedDate ?? DateTime.now(),
                    inspectionType: widget.selectedType!,
                    inspectionSubtype: widget.selectedSubtype!,
                    inspectionItens: widget.items,
                    status: widget.inspectionModel == null
                        ? 'Pendente'
                        : widget.inspectionModel!.status,
                  );
                  if (widget.inspectionModel == null) {
                    bool? response = await widget.controller.createInspection(
                      model: inspectionModel,
                    );
                    if (response != null) {
                      Get.back();
                      await Future.delayed(
                        Duration(milliseconds: 100),
                        () {},
                      );
                      Get.back();
                      CustomAlert().successSnack(
                        'Inspeção cadastrada com sucesso',
                      );
                      widget.controller.fetchInspection();
                    } else {
                      Get.back();
                      CustomAlert().errorSnack('Erro ao cadastrar inspeção');
                    }
                  }
                },
              ),
            if (widget.inspectionModel != null)
              CustomButton(
                content: 'Ações',
                onTap: () async {
                  Get.dialog(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width * 0.7,
                          height: MediaQuery.sizeOf(context).height * 0.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white,
                          ),
                          child: Scaffold(
                            backgroundColor: Colors.transparent,
                            appBar: AppBar(
                              automaticallyImplyLeading: false,
                              backgroundColor: Colors.transparent,
                              title: Text(
                                'Ações',
                                style: TextStyle(color: Colors.black87),
                              ),
                              actions: [
                                IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            body: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric( horizontal: 6.0, vertical: 6.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: ListTile(
                                      title: Text('Checklist'),
                                      leading: Icon(Icons.checklist),
                                      onTap: () async {
                                        Get.back();
                                        Get.to(
                                          () => ChecklistScreen(
                                            inspection: widget.inspectionModel!,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric( horizontal: 6.0, vertical: 6.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade100,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: ListTile(
                                      title: Text('Cancelar inspeção'),
                                      leading: Icon(Icons.cancel),
                                      onTap: () {
                                        if (widget.inspectionModel!.status !=
                                            'Pendente') {
                                          CustomAlert().error(
                                            content:
                                                'Esta inspeção já foi finalizada',
                                            title: 'Atenção',
                                          );
                                          return;
                                        }
                                        CustomAlert().confirm(
                                          content:
                                              'Tem certeza que deseja cancelar esta inspeção?',
                                          onConfirm: () async {
                                            final result = await widget.controller
                                                .cancelInspection(
                                                  model: widget.inspectionModel!,
                                                );
                                            if (result) {
                                              Get.back();
                                              await Future.delayed(
                                                Duration(milliseconds: 100),
                                              );
                                              Get.back();
                                              await Future.delayed(
                                                Duration(milliseconds: 100),
                                              );
                                              Get.back();
                                              CustomAlert().successSnack(
                                                'Inspeção cancelada',
                                              );
                                              widget.controller.fetchInspection();
                                            } else {
                                              Get.back();
                                              CustomAlert().errorSnack(
                                                'Erro ao cancelar inspeção',
                                              );
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric( horizontal: 6.0, vertical: 6.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: ListTile(
                                      title: Text('Finalizar inspeção'),
                                      leading: Icon(Icons.receipt_long),
                                      onTap: () {
                                        if (widget.inspectionModel!.status !=
                                            'Pendente') {
                                          CustomAlert().error(
                                            content:
                                                'Esta inspeção já foi finalizada',
                                            title: 'Atenção',
                                          );
                                          return;
                                        }
                                        CustomAlert().confirm(
                                          content:
                                              'Tem certeza que deseja finalizar esta inspeção?',
                                          onConfirm: () async {
                                            final result = await widget.controller
                                                .finalizeInspection(
                                                  model: widget.inspectionModel!,
                                                );
                                            if (result) {
                                              Get.back();
                                              await Future.delayed(
                                                Duration(milliseconds: 100),
                                              );
                                              Get.back();
                                              await Future.delayed(
                                                Duration(milliseconds: 100),
                                              );
                                                  
                                              Get.back();
                                              CustomAlert().successSnack(
                                                'Inspeção cancelada',
                                              );
                                              widget.controller.fetchInspection();
                                            } else {
                                              Get.back();
                                              CustomAlert().errorSnack(
                                                'Erro ao cancelar inspeção',
                                              );
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                               Padding(
                                  padding: const EdgeInsets.symmetric( horizontal: 6.0, vertical: 6.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade100,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: ListTile(
                                      title: Text('Enviar relatório'),
                                      leading: Icon(Icons.send),
                                      onTap: () {
                                        CustomAlert().confirm(
                                          content:
                                              'Tem certeza que deseja enviar o relatório?',
                                          onConfirm: () async {
                                            if (true) {
                                              Get.back();
                                              await Future.delayed(
                                                Duration(milliseconds: 100),
                                              );
                                              Get.back();
                                              await Future.delayed(
                                                Duration(milliseconds: 100),
                                              );
                                              CustomAlert().successSnack(
                                                'Relatório enviado',
                                              );
                                            } else {
                                              Get.back();
                                              CustomAlert().errorSnack(
                                                'Erro ao enviar o relatório inspeção',
                                              );
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
