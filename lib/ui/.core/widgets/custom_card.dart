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
    return InkWell(
      onTap: widget.onTap ?? () {},
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(4),
        color: widget.color ?? primaryColor,
        child: Padding(
          padding: const EdgeInsets.only(left: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
