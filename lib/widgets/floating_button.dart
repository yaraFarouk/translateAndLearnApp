import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:translate_and_learn_app/constants.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({
    super.key,
    required this.color,
    required this.icon,
    required this.onPressed,
  });

  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: 60.w,
        height: 60.h,
        child: Container(
          width: 60.w,
          height: 60.h,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: kAppBarColor, // Border color (dark)
              width: 2.w,
            ),
          ),
          child: Center(
            child: Icon(
              icon,
              color: kAppBarColor,
              size: 25.sp,
            ),
          ),
        ),
      ),
    );
  }
}
