import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspecoespoty/data/models/inspection_checkitem_model.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_alert.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_button.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_card.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_picker.dart';
import 'package:inspecoespoty/ui/home/controller/home_controller.dart';
import 'package:inspecoespoty/utils/config.dart';

class ChecklistScreen extends StatefulWidget {
  ChecklistScreen({super.key, required this.checklist});
  List<InspectionCheckitemModel> checklist = [];

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  final controller = Get.find<HomeController>();
  @override
  void initState() {
    super.initState();
  }

  _buildSubtitle(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16),
        SizedBox(width: 4),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: (text.contains('Conforme')
                ? Colors.green.shade100
                : text.contains('Não conforme')
                ? Colors.red.shade100
                : Colors.yellow.shade100),
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checklist')),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),

        child: Column(
          children: [
            if (widget.checklist.isEmpty)
              Expanded(child: Center(child: Text('Nenhum item encontrado'))),

            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.checklist.length,
                      itemBuilder: (context, index) {
                        var checklistItem = widget.checklist[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: CustomCard(
                            color: !checklistItem.isChecked
                                ? Colors.yellow
                                : checklistItem.isChecked
                                ? Colors.green
                                : Colors.red,
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                checklistItem.inspectionItemModel?.name ?? '',
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSubtitle(
                                    Icons.check_circle,
                                    checklistItem.isAccordance
                                        ? 'Conforme'
                                        : (!checklistItem.isChecked
                                              ? 'Ainda não verificado'
                                              : 'Não conforme'),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () async {
                              InspectionCheckitemModel model =
                                  InspectionCheckitemModel.fromJson(
                                    widget.checklist[index].toJson(),
                                  );
                              List<File> newImages = [];
                              List<String> imagesUrl = [...model.images];
                              TextEditingController descriptionController = TextEditingController(text: model.description);
                              RxBool isAccordance = model.isAccordance.obs;
                              RxBool isLoading = false.obs;

                              showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                ),
                                backgroundColor: Colors.black12,
                                elevation: 4,
                                isScrollControlled: true,
                                builder: (context) {
                                  return DraggableScrollableSheet(
                                    initialChildSize: 0.7,
                                    minChildSize: 0.5,
                                    maxChildSize: 0.95,
                                    expand: false,
                                    builder: (context, scrollController) {
                                      return StatefulBuilder(
                                        builder: (context, setModalState) {
                                          return Container(
                                            padding: EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(16),
                                              ),
                                              border: Border.all(
                                                color: primaryColor,
                                              ),
                                            ),
                                            child: ListView(
                                              controller: scrollController,
                                              children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 40,
                                                  height: 4,
                                                  decoration: BoxDecoration(
                                                    color: primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          2.0,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 24),
                                            Text(
                                              ' Item a ser inspecionado',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            SizedBox(height: 4),
                                            TextFormField(
                                              initialValue: model
                                                  .inspectionItemModel
                                                  ?.name,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                focusedBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                              .grey
                                                              .shade300,
                                                          width: 1.5,
                                                        ),
                                                      ),
                                              ),
                                              readOnly: true,
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'Conformidade',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            SizedBox(height: 4),
                                            Obx(
                                              () => TextFormField(
                                                initialValue:
                                                    'Item está em conformidade?',
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                              .grey
                                                              .shade300,
                                                          width: 1.5,
                                                        ),
                                                      ),
                                                  suffixIcon: Icon(
                                                    isAccordance.value
                                                        ? Icons.check_circle
                                                        : Icons.cancel,
                                                    color: isAccordance.value
                                                        ? Colors.green
                                                        : Colors.red,
                                                  ),
                                                ),
                                                readOnly: true,
                                                onTap: () {
                                                  if (!model.isChecked) {
                                                    setState(() {
                                                      isAccordance.value =
                                                          !isAccordance.value;
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                            SizedBox(height: 16),

                                            Text(
                                              'Descrição',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            SizedBox(height: 4),
                                            TextFormField(
                                              controller: descriptionController,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                focusedBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                              .grey
                                                              .shade300,
                                                          width: 1.5,
                                                        ),
                                                      ),
                                              ),
                                              maxLines: 5,
                                              readOnly: model.isChecked,
                                            ),
                                            SizedBox(height: 16),
                                            SizedBox(
                                              width: MediaQuery.sizeOf(context).width,
                                              height: (!model.isChecked ? 48 : null),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    'Imagens',
                                                    style: TextStyle(fontSize: 12),
                                                  ),
                                                  if (!model.isChecked)
                                                    IconButton(
                                                      icon: Icon(Icons.add_a_photo),
                                                      onPressed: () async {
                                                        File? result = await CustomPicker(context);
                                                        if (result != null) {
                                                          setModalState(() {
                                                            newImages.add(result);
                                                          });
                                                        }
                                                      },
                                                    ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            GridView.builder(
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                crossAxisSpacing: 8,
                                                mainAxisSpacing: 8,
                                                childAspectRatio: 1,
                                              ),
                                              itemCount: (model.isChecked)
                                                  ? imagesUrl.length
                                                  : newImages.length,
                                              itemBuilder: (context, imgIndex) {
                                                if (model.isChecked) {
                                                  // Imagem da URL
                                                  return InkWell(
                                                    onTap: () {
                                                      Get.dialog(
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Container(
                                                                width: MediaQuery.sizeOf(context).width * 0.8,
                                                                child: Stack(
                                                                  children: [
                                                                    Image.network(
                                                                      imagesUrl[imgIndex],
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                    Positioned(
                                                                      top: 8,
                                                                      right: 8,
                                                                      child: IconButton.filled(
                                                                        icon: Icon(Icons.close, color: Colors.white),
                                                                        style: IconButton.styleFrom(
                                                                          backgroundColor: Colors.black54,
                                                                        ),
                                                                        onPressed: () {
                                                                          Get.back();
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      );
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(8),
                                                      child: Image.network(
                                                        imagesUrl[imgIndex],
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) => Container(
                                                          color: Colors.grey[300],
                                                          child: Icon(
                                                            Icons.broken_image,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  final file = newImages[imgIndex];
                                                  return InkWell(
                                                    onTap: () {
                                                      Get.dialog(
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Container(
                                                                width: MediaQuery.sizeOf(context).width * 0.8,
                                                                child: Stack(
                                                                  children: [
                                                                    Image.file(
                                                                      file,
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                    Positioned(
                                                                      top: 8,
                                                                      right: 8,
                                                                      child: IconButton.filled(
                                                                        icon: Icon(Icons.close, color: Colors.white),
                                                                        style: IconButton.styleFrom(
                                                                          backgroundColor: Colors.black54,
                                                                        ),
                                                                        onPressed: () {
                                                                          Get.back();
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      );
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(8),
                                                      child: Image.file(
                                                        file,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) => Container(
                                                          color: Colors.grey[300],
                                                          child: Icon(
                                                            Icons.broken_image,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                            SizedBox(height: 16),
                                            if (model.isChecked)
                                              Text(
                                                'Item já verificado, não é possível editar.',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            Obx(() {
                                              if (isLoading.value) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                              if (!model.isChecked &&
                                                  !isLoading.value) {
                                                return CustomButton(
                                                  content: 'Salvar',
                                                  onTap: () async {
                                                    isLoading.value = true;

                                                    model.description =
                                                        descriptionController
                                                            .text;
                                                    model.isAccordance =
                                                        isAccordance.value;
                                                    
                                                    // Converte as imagens locais (newImages) para base64 e adiciona à lista de imagens
                                                    List<String>
                                                    newImagesBase64 = [];
                                                    for (var file in newImages) {
                                                      final bytes = await file.readAsBytes();
                                                      newImagesBase64.add(base64Encode(bytes));
                                                    }
                                                    model.images = [
                                                      ...newImagesBase64,
                                                    ];

                                                    await controller
                                                        .checkItem(model: model)
                                                        .then((result) async {
                                                          if (result) {
                                                            setState(() {
                                                                widget.checklist[index] =
                                                                  model;
                                                            });
                                                            final newlist = await controller.getCheckitens(id: model.inspectionID);
                                                            
                                                            Get.back();
                                                            // CustomAlert()
                                                            //     .successSnack(
                                                            //       'Item verificado com sucesso!',
                                                            //     );
                                                            setState(() {
                                                              widget.checklist = newlist;
                                                            });
                                                          } else {
                                                            CustomAlert()
                                                                .errorSnack(
                                                                  'Erro ao verificar o item.',
                                                                );
                                                            isLoading.value =
                                                                false;
                                                          }
                                                          isLoading.value =
                                                              false;
                                                        });
                                                  },
                                                );
                                              }
                                              return Container();
                                            }),

                                            SizedBox(height: 16),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        
                      },
                    ),
                  );
  }))],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
