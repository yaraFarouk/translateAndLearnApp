import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:translate_and_learn_app/constants.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton(
      {super.key,
      required this.color,
      required this.icon,
      required this.onPressed});
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60.w,
      height: 60.h,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kAppBarColor, width: 2.w),
          borderRadius: BorderRadius.circular(40.r),
          color: color,
        ),
        child: Material(
          color: color,
          elevation: 4,
          shadowColor: kAppBarColor,
          shape: const CircleBorder(),
          child: IconButton(
            icon: Icon(
              icon,
              color: kAppBarColor,
              size: 25.sp,
            ),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
