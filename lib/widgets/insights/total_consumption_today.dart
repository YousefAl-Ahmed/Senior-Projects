import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seniorproject/providers.dart';

import 'error.dart';

class TotalConsumptionToday extends ConsumerWidget {
  const TotalConsumptionToday({
    super.key,
  });
  final insightsGridContainerColor = const Color(0xff172E3C);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final energyDataAsyncValue = ref.watch(energyDataProvider);
    return energyDataAsyncValue.when(
      loading: () => ErrorInnerContainer(),
      error: (err, stack) => Text('Error: $err'),
      data: (energyData) {
        // show 2 decimal points

        final costInSaudiRiyal =
            ((energyData.totalConsumptionToday * 0.18) / 1000);
        String costInSaudiRiyalFormatted = costInSaudiRiyal.toStringAsFixed(2);

        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: insightsGridContainerColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'Total Consumption Today',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '${energyData.totalConsumptionToday.toStringAsFixed(2)} W',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              Text(
                '$costInSaudiRiyalFormatted SAR',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
