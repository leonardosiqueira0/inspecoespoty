import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inspecoespoty/data/models/inspection_item_model.dart';
import 'package:inspecoespoty/data/models/location_model.dart';
import 'package:inspecoespoty/data/models/person_model.dart';
import 'package:inspecoespoty/data/services/location_service.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_button.dart';
import 'package:inspecoespoty/ui/inspection/controller/inspection_controller.dart';
import 'package:inspecoespoty/ui/person/controller/person_controller.dart';
import 'package:inspecoespoty/utils/formatters.dart';
import 'package:uuid/uuid.dart';

class InspectionItemRegister extends StatefulWidget {
  InspectionItemRegister({super.key, this.inspectionItemModel, required this.inspectionSubtypeID});
  InspectionItemModel? inspectionItemModel;
  String inspectionSubtypeID;
  String idController = '';

  @override
  State<InspectionItemRegister> createState() => _InspectionItemRegisterState();
}

class _InspectionItemRegisterState extends State<InspectionItemRegister> {
  final controller = Get.find<InspectionController>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  RxList locations = [].obs;

  @override
  void initState() {
    if (widget.inspectionItemModel != null) {
      nameController.text = widget.inspectionItemModel!.name;
    }
    widget.idController = widget.inspectionItemModel?.id ?? Uuid().v4();
    setState(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.inspectionItemModel != null ? 'Editar Item' :  'Cadastrar Item')),
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
                    children: [
                      SizedBox(height: 16),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: 'Nome'),
                        keyboardType: TextInputType.name,
                      ),
                                          ],
                  ),
                ),
              ),
              CustomButton(
                content: 'Salvar',
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    if (widget.inspectionItemModel == null) {
                      InspectionItemModel model = InspectionItemModel(
                        id: widget.idController,
                        name: nameController.text,
                        inspectionSubtypeID: widget.inspectionSubtypeID
                      );
                      Get.back(result: model);
                      return;
                    } else {
                      InspectionItemModel model = InspectionItemModel(
                        id: widget.idController,
                        name: nameController.text,
                        inspectionSubtypeID: widget.inspectionSubtypeID
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
