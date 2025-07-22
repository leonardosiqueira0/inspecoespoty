import 'package:flutter/material.dart';
import 'package:inspecoespoty/data/models/inspection_checkitem_model.dart';

class ChecklistScreen extends StatefulWidget {
  ChecklistScreen({super.key, required this.checklist});
  List<InspectionCheckitemModel> checklist = [];


  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

}

class _ChecklistScreenState extends State<ChecklistScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checklist',
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
                  key: widget.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
