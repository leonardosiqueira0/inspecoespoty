import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inspecoespoty/data/models/inspection_item_model.dart';
import 'package:inspecoespoty/data/models/inspection_subtype_model.dart';
import 'package:inspecoespoty/data/models/inspection_type_model.dart';
import 'package:inspecoespoty/data/models/location_model.dart';
import 'package:inspecoespoty/data/models/person_model.dart';
import 'package:inspecoespoty/data/services/inspection_type_service.dart';
import 'package:inspecoespoty/data/services/location_service.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_button.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_card.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_loading.dart';
import 'package:inspecoespoty/ui/inspection/controller/inspection_controller.dart';
import 'package:inspecoespoty/ui/inspection/widgets/inspection_subtype_register.dart';
import 'package:inspecoespoty/utils/config.dart';
import 'package:inspecoespoty/utils/formatters.dart';
import 'package:uuid/uuid.dart';

class InspectionRegister extends StatefulWidget {
  InspectionRegister({super.key, this.inspectionTypeModel});

  InspectionTypeModel? inspectionTypeModel;

  @override
  State<InspectionRegister> createState() => _InspectionRegisterState();
  RxList<InspectionSubtypeModel> inspectionSubtypes =
      <InspectionSubtypeModel>[].obs;
  RxList<InspectionSubtypeModel> inspectionSubtypesCreated =
      <InspectionSubtypeModel>[].obs;
  RxList<InspectionSubtypeModel> inspectionSubtypesUpdated =
      <InspectionSubtypeModel>[].obs;
  String id = '';

  RxList<InspectionSubtypeModel> get list {
    final combinedList = <InspectionSubtypeModel>[];
    combinedList.addAll(inspectionSubtypes);
    combinedList.addAll(inspectionSubtypesCreated);
    combinedList.addAll(inspectionSubtypesUpdated);
    return combinedList.obs;
  }
}

class _InspectionRegisterState extends State<InspectionRegister> {
  final controller = Get.find<InspectionController>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  LocationModel? selectedLocation;
  RxList locations = [].obs;
  RxBool loading = false.obs;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      if (widget.inspectionTypeModel != null) {
        loading.value = true;
        nameController.text = widget.inspectionTypeModel!.name;
        widget.inspectionSubtypes.assignAll(widget.inspectionTypeModel!.subtypes);
        loading.value = false;
      }
      widget.id = widget.inspectionTypeModel?.id ?? Uuid().v4();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.inspectionTypeModel != null
              ? 'Editar tipo de inspeção'
              : 'Cadastrar tipo de inspeção',
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
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
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: 'Nome'),
                        keyboardType: TextInputType.name,
                      ),
                      SizedBox(height: 16),
                      ListTile(
                        title: Text('Subtipos cadastrados'),
                        subtitle: Text('Gerenciar subtipos'),
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Icon(
                            Icons.document_scanner,
                            color: Colors.black87,
                          ),
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
                            InspectionSubtypeModel? model = await Get.to(
                              () => InspectionSubtypeRegister(inspectionTypeId: widget.id,),
                            );
                            setState(() {
                              if (model != null) {
                                InspectionSubtypeModel newModel = model;
                                model.quantity = (model.inspectionItens ?? []).length;
                                widget.inspectionSubtypesCreated.add(newModel);
                              }
                            });

                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            child: Text(
                              'Adicionar',
                              style: TextStyle(color: Colors.black87),
                            ),
                          ),
                        ),
                      ),
                      Obx(() {
                        if (loading.value == true) {
                          return Expanded(
                            child: Container(
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          );
                        }

                        if (widget.list.isEmpty) {
                          return Expanded(
                            child: Container(
                              child: Center(
                                child: Text('Nenhum subtipo cadastrado'),
                              ),
                            ),
                          );
                        }


                        return Expanded(
                          child: Container(
                            child: Obx(() => ListView.builder(
                              itemBuilder: (context, index) {
                                InspectionSubtypeModel subtype = widget.list[index];
                                String tipo = '';
                                if (widget.inspectionSubtypesUpdated.contains(subtype) || widget.inspectionSubtypesCreated.contains(subtype)) {
                                  tipo = 'Updated';
                                } else if (widget.inspectionSubtypes.contains(subtype)) {
                                  tipo = 'Created';
                                }
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                  ),
                                  child: InkWell(
                                    onTap: () async {
                                      InspectionSubtypeModel? newModel = await Get.to(
                                        () => InspectionSubtypeRegister(
                                          inspectionSubtypeModel: subtype,
                                            inspectionTypeId: widget.id
                                        ),
                                      );
                                      ;
                                      if (newModel != null) {
                                        // Remove o subtipo da lista de atualizados se ele existir lá
                                        // para evitar duplicidade ao atualizar um recém-atualizado
                                        if (widget.inspectionSubtypesUpdated.contains(subtype)) {
                                          widget.inspectionSubtypesUpdated.remove(subtype);
                                        }

                                        widget.inspectionSubtypesUpdated.add(newModel);
                                        // Remove o subtipo da lista original se ele existir lá
                                        if (widget.inspectionSubtypes.contains(subtype)) {
                                          widget.inspectionSubtypes.remove(subtype);
                                        }
                                        // Remove o subtipo da lista de criados se ele existir lá
                                        // para evitar duplicidade ao atualizar um recém-criado
                                        if (widget.inspectionSubtypesCreated.contains(subtype)) {
                                          widget.inspectionSubtypesCreated.remove(subtype);
                                        }
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                        borderRadius: BorderRadius.circular(4.0),
                                        color: (tipo == 'Updated')
                                            ? Colors.yellow.shade100
                                            : null,
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 8),
                                          Container(
                                            width: 40,
                                            height: 4,
                                            decoration: BoxDecoration(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primaryContainer,
                                              borderRadius: BorderRadius.circular(
                                                2.0,
                                              ),
                                            ),
                                          ),
                                          ListTile(
                                            title: Text(subtype.name),
                                            subtitle: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('Subtipo de Inspeção'),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Icon(
                                                      Icons.paste_rounded,
                                                      size: 16,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      '${subtype.quantity} Itens cadastrados',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: widget.list.length,
                            )),
                          ),
                        );
                      }),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              Container(
                height: 50,
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade100,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(width: 1.5, color: Colors.black87)
                      ),
                    ),
                    VerticalDivider(width: 4, color: Colors.transparent,),
                    Text('Subtipo criado ou atualizado')
                  ],
                ),
              ),
              CustomButton(
                content: 'Salvar',
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    InspectionTypeModel model = InspectionTypeModel(
                      id: widget.id,
                      name: nameController.text,
                      departmentId: configUserModel!.departmentID,
                      subtypes: widget.list,
                    );
                    await controller.createInspectionType(
                          inspectionType: model,
                          inspectionSubtypesCreated: widget.inspectionSubtypesCreated,
                          inspectionSubtypesUpdated: widget.inspectionSubtypesUpdated,
                        );
                  }
                },
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
