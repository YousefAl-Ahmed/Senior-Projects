import 'package:flutter/material.dart';

class InsightsGridviewInner extends StatelessWidget {
  const InsightsGridviewInner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const insightsGridContainerColor = Color(0xff172E3C);
    return GridView.count(
      crossAxisCount: 2,
      primary: false,
      padding: const EdgeInsets.all(16),
      crossAxisSpacing: 40,
      mainAxisSpacing: 25,
      childAspectRatio: (185 / 125), // Width 450 / Height 350
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          color: insightsGridContainerColor,
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: insightsGridContainerColor,
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: insightsGridContainerColor,
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: insightsGridContainerColor,
        ),
      ],
    );
  }
}
