import 'package:flutter/material.dart';

class ErrorInnerContainer extends StatelessWidget {
  const ErrorInnerContainer({
    super.key,
  });

  final insightsGridContainerColor = const Color(0xff172E3C);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: insightsGridContainerColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
          // child: CircularProgressIndicator(),
          ),
    );
  }
}
