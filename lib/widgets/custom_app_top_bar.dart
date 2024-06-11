import 'package:flutter/material.dart';

class CustomAppTopBar extends StatelessWidget {
  const CustomAppTopBar({super.key, required this.title, required this.icon});
  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 30,
                  fontFamily: 'CookieCrisp',
                  color: Colors.black,
                ),
                child: Text(title),
              ),
            ),
          ),
          const SizedBox(width: 10), // Spacer to align with the icon's width
        ],
      ),
    );
  }
}
