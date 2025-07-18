import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inspecoespoty/data/models/inspection_item_model.dart';
import 'package:inspecoespoty/data/models/inspection_subtype_model.dart';
import 'package:inspecoespoty/data/models/inspection_type_model.dart';
import 'package:inspecoespoty/data/models/location_model.dart';
import 'package:inspecoespoty/data/models/person_model.dart';
import 'package:inspecoespoty/data/services/location_service.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_button.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_card.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_loading.dart';
import 'package:inspecoespoty/ui/inspection/controller/inspection_controller.dart';
import 'package:inspecoespoty/ui/inspection/widgets/inspection_item_register.dart';
import 'package:inspecoespoty/utils/config.dart';
import 'package:inspecoespoty/utils/formatters.dart';
import 'package:uuid/uuid.dart';

class InspectionSubtypeRegister extends StatefulWidget {
  InspectionSubtypeRegister({super.key, this.inspectionSubtypeModel});

  InspectionSubtypeModel? inspectionSubtypeModel;

  @override
  State<InspectionSubtypeRegister> createState() =>
      _InspectionSubtypeRegisterState();
  RxList<InspectionItemModel> inspectionItems = <InspectionItemModel>[].obs;
  RxList<InspectionItemModel> inspectionItemsCreated =
      <InspectionItemModel>[].obs;
  RxList<InspectionItemModel> inspectionItemsUpdated =
      <InspectionItemModel>[].obs;

  RxList<InspectionItemModel> get list {
    final combinedList = <InspectionItemModel>[];
    combinedList.addAll(inspectionItems);
    combinedList.addAll(inspectionItemsCreated);
    combinedList.addAll(inspectionItemsUpdated);
    return combinedList.obs;
  }
  RxBool loading = false.obs;
}

class _InspectionSubtypeRegisterState extends State<InspectionSubtypeRegister> {
  final controller = Get.find<InspectionController>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  RxList locations = [].obs;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      widget.loading.value = true;
      if (widget.inspectionSubtypeModel != null) {
        nameController.text = widget.inspectionSubtypeModel!.name;
        await Future.delayed(Duration.zero, () async {
          widget.inspectionItems.assignAll(
            widget.inspectionSubtypeModel!.inspectionItens ?? [],
          );
        });
      }
      widget.loading.value = false;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.inspectionSubtypeModel != null
              ? 'Editar Subtipo de inspeção'
              : 'Cadastrar Subtipo de inspeção',
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
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]'),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      ListTile(
                        title: Text('Itens cadastrados'),
                        subtitle: Text('Gerenciar itens'),
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
                            InspectionItemModel? model = await Get.to(
                                  () => InspectionItemRegister(),
                            );
                            setState(() {
                              if (model != null) {
                                widget.inspectionItemsCreated.add(model);
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
                        if (widget.loading.value) {
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
                                child: Text('Nenhum item cadastrado'),
                              ),
                            ),
                          );
                        }

                        return Expanded(
                          child: Container(
                            child: Obx(() => ListView.builder(
                              itemBuilder: (context, index) {
                                InspectionItemModel itemModel = widget.list[index];
                                String tipo = '';
                                if (widget.inspectionItemsUpdated.contains(itemModel) || widget.inspectionItemsCreated.contains(itemModel)) {
                                  tipo = 'Updated';
                                } else if (widget.inspectionItems.contains(itemModel)) {
                                  tipo = 'Created';
                                }
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                  ),
                                  child: InkWell(
                                    onTap: () async {

                                      InspectionItemModel? newModel = await Get.to(
                                            () => InspectionItemRegister(
                                          inspectionItemModel: itemModel,
                                        ),
                                      );
                                      ;
                                      if (newModel != null) {
                                        // Remove o item da lista de atualizados se ele existir lá
                                        // para evitar duplicidade ao atualizar um recém-atualizado
                                        if (widget.inspectionItemsUpdated.contains(itemModel)) {
                                          widget.inspectionItemsUpdated.remove(itemModel);
                                        }

                                        widget.inspectionItemsUpdated.add(newModel);
                                        // Remove o item da lista original se ele existir lá
                                        if (widget.inspectionItems.contains(itemModel)) {
                                          widget.inspectionItems.remove(itemModel);
                                        }
                                        // Remove o item da lista de criados se ele existir lá
                                        // para evitar duplicidade ao atualizar um recém-criado
                                        if (widget.inspectionItemsCreated.contains(itemModel)) {
                                          widget.inspectionItemsCreated.remove(itemModel);
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
                                            title: Text(itemModel.name),
                                            subtitle: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('Subtipo de Inspeção'),

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
              CustomButton(
                content: 'Salvar',
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    if (widget.inspectionSubtypeModel == null) {
                      InspectionSubtypeModel model = InspectionSubtypeModel(
                        id: Uuid().v4(),
                        name: nameController.text,
                        inspectionTypeId: '',
                      );
                      Get.back(result: model);
                      return;
                    } else {
                      InspectionSubtypeModel model = InspectionSubtypeModel(
                        id: widget.inspectionSubtypeModel!.id,
                        name: nameController.text,
                        inspectionTypeId: '',
                      );
                      Get.back(result: model);
                      return;
                    }
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
