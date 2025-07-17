import 'package:flutter/material.dart';
import 'package:inspecoespoty/utils/config.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.content,
    required this.onTap,
    this.color,
  });

  final String content;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      child: Center(
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          height: 50,
          decoration: BoxDecoration(
            color: color ?? primaryColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              content,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textScaler: TextScaler.linear(1.2),
            ),
          ),
        ),
      ),
    );
  }
}
