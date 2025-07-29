import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';

class NewServiceButton extends StatelessWidget {
  final VoidCallback onPressed;

  const NewServiceButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: CustomButton(
        text: "New Jobs",
        onPressed: onPressed,
      ),
    );
  }
}