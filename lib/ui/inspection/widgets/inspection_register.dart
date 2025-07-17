import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inspecoespoty/data/models/inspection_subtype_model.dart';
import 'package:inspecoespoty/data/models/inspection_type_model.dart';
import 'package:inspecoespoty/data/models/location_model.dart';
import 'package:inspecoespoty/data/models/person_model.dart';
import 'package:inspecoespoty/data/services/inspection_type_service.dart';
import 'package:inspecoespoty/data/services/location_service.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_button.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_card.dart';
import 'package:inspecoespoty/ui/inspection/controller/inspection_controller.dart';
import 'package:inspecoespoty/utils/config.dart';
import 'package:inspecoespoty/utils/formatters.dart';

class InspectionRegister extends StatefulWidget {
  InspectionRegister({super.key, this.inspectionTypeModel});
  InspectionTypeModel? inspectionTypeModel;
  @override
  State<InspectionRegister> createState() => _InspectionRegisterState();
  RxList<InspectionSubtypeModel> inspectionSubtypes =
      <InspectionSubtypeModel>[].obs;
  RxList<InspectionSubtypeModel> inspectionSubtypesCreated =
      <InspectionSubtypeModel>[].obs;
  RxBool loading = false.obs;

}

class _InspectionRegisterState extends State<InspectionRegister> {
  final controller = Get.find<InspectionController>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  LocationModel? selectedLocation;
  RxList locations = [].obs;

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () async {
        widget.loading.value = true;
        if (widget.inspectionTypeModel != null) {
          nameController.text = widget.inspectionTypeModel!.name;
          await Future.delayed(Duration.zero, () async {
            List<InspectionSubtypeModel>? subtypes = await controller
                .getInspectionSubTypes(id: widget.inspectionTypeModel!.id!);
            if (subtypes != null) {
              widget.inspectionSubtypes.assignAll(subtypes);
            }
          });
        }
        widget.loading.value = false;
      },
    );


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
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]'),
                          ),
                        ],
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
                          onPressed: () {},
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

                          if (widget.inspectionSubtypes.isEmpty) {
                            return Expanded(
                              child: Container(
                                child: Center(child: Text('Nenhum subtipo cadastrado')),
                              ),
                            );
                          }
                          return Column(
                            children: widget.inspectionSubtypes.map((subtype) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                              Text(
                                                'Subtipo de Inspeção',
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: [
                                                  Icon(Icons.paste_rounded, size: 16),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    '${subtype.quantity} Itens cadastrados',
                                                    style: TextStyle(fontSize: 14),
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
                            }).toList(),
                          );}

                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              CustomButton(
                content: 'Salvar',
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    if (widget.inspectionTypeModel == null) {
                      InspectionTypeModel model = InspectionTypeModel(
                        name: nameController.text,
                        departmentId: configUserModel!.departmentID,
                      );
                      await controller.createInspectionType(inspectionType: model, inspectionSubtypes: widget.inspectionSubtypesCreated);
                    } else {
                      InspectionTypeModel model = InspectionTypeModel(
                        id: widget.inspectionTypeModel!.id,
                        name: nameController.text,
                        departmentId: configUserModel!.departmentID,
                      );
                      print(model.toJson());
                      await controller.updateInspectionType(inspectionType: model, inspectionSubtypes: widget.inspectionSubtypesCreated);
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
