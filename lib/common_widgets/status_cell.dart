import 'package:flutter/material.dart';
import '../theme.dart';
class StatusCell extends StatelessWidget {
  const StatusCell({
    super.key,
    required this.height,
    required this.width,
    required this.child,
    required this.title,
    required this.value,
  });

  final double height;
  final double width;
  final Widget child;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: height / 2.7,
          decoration: BoxDecoration(
            color: TColor.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(1, 1.5),
                blurRadius: 0.2,
                blurStyle: BlurStyle.outer,
              )
            ],
          ),
        ),
        Positioned(
          top: 7,
          right: 8,
          left: 8,
          height: height / 4,
          child: Container(
            decoration: BoxDecoration(
              color: TColor.primary,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: child,
            ),
          ),
        ),
        Positioned(
          top: height / 3.4,
          left: width / 18,
          right: width / 3,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                      color: TColor.black, fontWeight: FontWeight.w700),
                ),
              ),
              Text(value,
                  style:const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}
