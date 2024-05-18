import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seniorproject/providers.dart';

import '../../models/energy_data.dart';
import 'error.dart';

class DeviceYesterdayComparison extends ConsumerWidget {
  final AsyncValue<Device> data;

  const DeviceYesterdayComparison({
    super.key,
    required this.data,
  });

  final Color insightsGridContainerColor = const Color(0xff172E3C);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return data.when(
      loading: () => ErrorInnerContainer(),
      error: (err, stack) => Text('Error: $err'),
      data: (energyData) {
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
                'Yesterday Comparison',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (energyData.percentageDifference == -100)
                const Text(
                  'Not enough data to compare',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                )
              else
                energyData.percentageDifference > 0
                    ? Text(
                        '+ ${energyData.percentageDifference.toStringAsFixed(2)}%',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                        ),
                      )
                    : Text(
                        '${energyData.percentageDifference.toStringAsFixed(2)}%',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                        ),
                      ),
              energyData.percentageDifference > 0
                  ? const Text(
                      'More than yesterday',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Less than yesterday',
                      style: TextStyle(
                        fontSize: 12,
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
