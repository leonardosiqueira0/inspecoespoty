import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inspecoespoty/data/models/location_model.dart';
import 'package:inspecoespoty/data/models/person_model.dart';
import 'package:inspecoespoty/data/services/location_service.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_button.dart';
import 'package:inspecoespoty/ui/person/controller/person_controller.dart';
import 'package:inspecoespoty/utils/formatters.dart';

class PersonRegister extends StatefulWidget {
  PersonRegister({super.key, this.personModel});
  PersonModel? personModel;
  @override
  State<PersonRegister> createState() => _PersonRegisterState();
}

class _PersonRegisterState extends State<PersonRegister> {
  final controller = Get.find<PersonController>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  LocationModel? selectedLocation;
  RxList locations = [].obs;

  @override
  void initState() {
    LocationService().fetchLocation().then((value) {
      locations.assignAll(value);
    });
    if (widget.personModel != null) {
      nameController.text = widget.personModel!.name;
      positionController.text = widget.personModel!.position;
      mailController.text = widget.personModel!.mail;
      selectedLocation = widget.personModel?.location;
      locationController.text = selectedLocation?.name ?? '';
    } 
      setState(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.personModel != null ? 'Editar Pessoa' :  'Cadastrar Pessoa')),
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
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]'),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: mailController,
                        decoration: InputDecoration(labelText: 'E-mail'),
                        keyboardType: TextInputType.emailAddress,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9@._-]'),
                          ),
                          Formatters.toLower(),
                        ],
                      ),
                      SizedBox(height: 16),
                      DropdownMenu(
                        width: MediaQuery.of(context).size.width,
                        controller: positionController,
                        dropdownMenuEntries: [
                          DropdownMenuEntry<String>(
                            value: 'Encarregado',
                            label: 'Encarregado',
                          ),
                          DropdownMenuEntry<String>(
                            value: 'Gerente',
                            label: 'Gerente',
                          ),
                        ],
                        label: Text('Cargo'),
                      ),
                      SizedBox(height: 16),
                      Obx(
                        () => DropdownMenu(
                          width: MediaQuery.of(context).size.width,
                          initialSelection: selectedLocation,
                          controller: locationController,
                          dropdownMenuEntries: locations
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
                              selectedLocation = value;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CustomButton(
                content: 'Salvar',
                onTap: () async {
                  if (formKey.currentState!.validate() &&
                      selectedLocation != null) {
                    PersonModel person = PersonModel(
                      id: widget.personModel?.id,
                      name: nameController.text,
                      position: positionController.text,
                      mail: mailController.text,
                      locationID: selectedLocation?.id ?? '',
                    );
                    if (widget.personModel != null) {
                      await controller.updatePerson(person);
                    } else {
                      await controller.createPerson(person);
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
