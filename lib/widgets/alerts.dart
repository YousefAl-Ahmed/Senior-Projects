import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seniorproject/providers.dart';
import 'package:seniorproject/services/time_converter.dart';
import 'package:seniorproject/widgets/insights/error.dart';

class Alerts extends ConsumerWidget {
  const Alerts({
    super.key,
  });

  final gridContainerColor = const Color(0xffC7E3EC);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final energyDataAsyncValue = ref.watch(energyDataProvider);

    return energyDataAsyncValue.when(
      loading: () => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: gridContainerColor,
            borderRadius: BorderRadius.circular(12),
          ),
          width: width * 0.25,
          height: height * 0.80,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (err, stack) => Text('Error: $err'),
      data: (energyData) {
        List outliers = energyData.outliers;
        print(outliers);

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: gridContainerColor,
              borderRadius: BorderRadius.circular(12),
            ),
            width: width * 0.25,
            height: height * 0.80,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Alerts",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: outliers.length,
                    itemBuilder: (context, index) {
                      double upper_limit = outliers[index]['upper_limit'];
                      double percentageAboveUpperLimit =
                          energyData.outliers[index]['value'] /
                              upper_limit *
                              100;
                      print(percentageAboveUpperLimit);

                      String message = upper_limit < 1
                          ? "Is ON in unsual time"
                          : "Is consuming ${percentageAboveUpperLimit.toStringAsFixed(1)}% more than usual";
                      String turnOffMessage = "Do you want to turn it off?";

                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            height: 110,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "${energyData.outliers[index]['device']} $message. $turnOffMessage",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.black,
                                            size: 20,
                                          )),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 16,
                            bottom: 22,
                            child: Text(
                                timeConvertor(
                                  energyData.outliers[index]['hour'].toString(),
                                ),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                )),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
