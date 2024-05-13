import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seniorproject/providers.dart';
import 'package:seniorproject/widgets/insights/error.dart';

class TotalConsupmtionThisMonth extends ConsumerWidget {
  const TotalConsupmtionThisMonth({
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
            ((energyData.totalConsumptionThisMonth * 0.18));
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
                'Total Consumption This Month',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '${energyData.totalConsumptionThisMonth.toStringAsFixed(2)} KWh',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              Text(
                'Cost: $costInSaudiRiyalFormatted SAR',
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
