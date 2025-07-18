import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_card.dart';
import 'package:inspecoespoty/ui/person/controller/person_controller.dart';
import 'package:inspecoespoty/utils/config.dart';

class CustomCard extends StatefulWidget {
  final Widget child;
  final Color? color;
  final VoidCallback? onTap;

  const CustomCard({Key? key, required this.child, this.color, this.onTap})
    : super(key: key);

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: widget.onTap ?? () {},
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
                  color: widget.color ?? Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(
                    2.0,
                  ),
                ),
              ),
              widget.child

            ],
          ),
        ),
      ),
    );
  }
}