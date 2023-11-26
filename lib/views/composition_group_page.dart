import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta_insights_tft_frontend/models/composition_group.dart';
import 'package:meta_insights_tft_frontend/services/api_request_service.dart';
import 'package:meta_insights_tft_frontend/widgets/widget_lib.dart';

const listViewChildrenPadding = EdgeInsets.all(4);

final championFilterProvider = StateProvider((ref) => "");
final traitFilterProvider = StateProvider((ref) => "");
final itemFilterProvider = StateProvider((ref) => "");
final regionProvider = StateProvider((ref) => "europe");
final leagueProvider = StateProvider((ref) => "challenger");
final patchProvider = StateProvider((ref) => "13.23");
final maxPlacementProvider = StateProvider((ref) => 4);
final maxAvgPlacementProvider = StateProvider((ref) => 4);
final minCounterProvider = StateProvider((ref) => 5);
final combinationSizeProvider = StateProvider((ref) => 0);
final groupByProvider = StateProvider((ref) => "trait");
final ignoreSingleUnitTraitsProvider = StateProvider((ref) => false);
final minDateTimeProvider =
    StateProvider((ref) => DateTime.now().subtract(const Duration(days: 14)));

final compositionGroupProvider =
    FutureProvider<List<CompositionGroup>?>((ref) async {
  return ref.read(apiServiceProvider).getCompositionGroups(
      ref.watch(groupByProvider),
      ref.watch(patchProvider),
      ref.watch(combinationSizeProvider),
      ref.watch(ignoreSingleUnitTraitsProvider),
      ref.watch(maxPlacementProvider),
      ref.watch(maxAvgPlacementProvider),
      ref.watch(minCounterProvider),
      ref.watch(regionProvider),
      ref.watch(leagueProvider),
      ref.watch(championFilterProvider),
      ref.watch(traitFilterProvider),
      ref.watch(itemFilterProvider),
      ref.watch(minDateTimeProvider));
});

final iconProvider = FutureProvider<Map<String, String>?>((ref) async {
  return ref.read(apiServiceProvider).getIconMap(ref.watch(groupByProvider));
});
final championNameProvider = FutureProvider<List<String>?>((ref) async {
  return ref.read(apiServiceProvider).getDisplayNames('champion');
});
final traitNameProvider = FutureProvider<List<String>?>((ref) async {
  return ref.read(apiServiceProvider).getDisplayNames('trait');
});
final itemNameProvider = FutureProvider<List<String>?>((ref) async {
  return ref.read(apiServiceProvider).getDisplayNames('item');
});

class CompositionGroupPage extends ConsumerWidget {
  const CompositionGroupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final icons = ref.watch(iconProvider);
    final compositionGroups = ref.watch(compositionGroupProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Played ${ref.watch(groupByProvider)}s in ${ref.watch(regionProvider)} ${ref.watch(leagueProvider)} on patch ${ref.watch(patchProvider)}"),
      ),
      body: icons.when(
        data: (icons) => compositionGroups.when(
          data: (compositionGroupList) => CompositionView(
            compositionGroups: compositionGroupList!,
            icons: icons!,
            groupBy: ref.watch(groupByProvider),
          ),
          loading: () => const CircularProgressIndicator(),
          error: (error, stackTrace) => Text(error.toString()),
        ),
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) => Text(error.toString()),
      ),
      drawer: buildFilterDrawer(context, ref),
    );
  }

  Drawer buildFilterDrawer(BuildContext context, WidgetRef ref) {
    const SizedBox space = SizedBox(height: 10);
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(
          height: 64,
          child: DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text("Filters"),
          ),
        ),
        Padding(
          padding: listViewChildrenPadding,
          child: Column(
            children: [
              buildPatchInput(ref),
              Row(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        child: Text("Europe",
                            style: TextStyle(
                                fontSize: 12,
                                decoration:
                                    ref.watch(regionProvider) == "europe"
                                        ? TextDecoration.underline
                                        : TextDecoration.none)),
                        onPressed: () =>
                            ref.read(regionProvider.notifier).state = 'europe',
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        child: Text(
                          "Korea",
                          style: TextStyle(
                              fontSize: 12,
                              decoration: ref.watch(regionProvider) == "korea"
                                  ? TextDecoration.underline
                                  : TextDecoration.none),
                        ),
                        onPressed: () =>
                            ref.read(regionProvider.notifier).state = 'korea',
                      ),
                    ],
                  ),
                  buildSelectDatetimeButton(context, ref),
                ],
              ),
              Row(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        child: Text("Challenger",
                            style: TextStyle(
                                fontSize: 12,
                                decoration:
                                    ref.watch(leagueProvider) == "challenger"
                                        ? TextDecoration.underline
                                        : TextDecoration.none)),
                        onPressed: () => ref
                            .read(leagueProvider.notifier)
                            .state = 'challenger',
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        child: Text("Grandmaster",
                            style: TextStyle(
                                fontSize: 12,
                                decoration:
                                    ref.watch(leagueProvider) == "grandmaster"
                                        ? TextDecoration.underline
                                        : TextDecoration.none)),
                        onPressed: () => ref
                            .read(leagueProvider.notifier)
                            .state = 'grandmaster',
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        child: Text("Master",
                            style: TextStyle(
                                fontSize: 12,
                                decoration:
                                    ref.watch(leagueProvider) == "master"
                                        ? TextDecoration.underline
                                        : TextDecoration.none)),
                        onPressed: () =>
                            ref.read(leagueProvider.notifier).state = 'master',
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        child: Text("Traits",
                            style: TextStyle(
                                fontSize: 12,
                                decoration:
                                    ref.watch(groupByProvider) == "trait"
                                        ? TextDecoration.underline
                                        : TextDecoration.none)),
                        onPressed: () =>
                            ref.read(groupByProvider.notifier).state = "trait",
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        child: Text("Champions",
                            style: TextStyle(
                                fontSize: 12,
                                decoration:
                                    ref.watch(groupByProvider) == "champion"
                                        ? TextDecoration.underline
                                        : TextDecoration.none)),
                        onPressed: () => ref
                            .read(groupByProvider.notifier)
                            .state = "champion",
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        child: Text("Items",
                            style: TextStyle(
                                fontSize: 12,
                                decoration: ref.watch(groupByProvider) == "item"
                                    ? TextDecoration.underline
                                    : TextDecoration.none)),
                        onPressed: () =>
                            ref.read(groupByProvider.notifier).state = "trait",
                      ),
                    ],
                  ),
                ],
              ),
              buildSliders(ref),
              buildIgnoreSingleUnitTraitsCheckBox(ref),
              space,
              // TODO: Add filter for champion star level and backend to filter traits by champion
              buildChampionFilter(ref),
              space,
              // TODO: Add filter for trait style and backend to filter champions by trait
              buildTraitFilter(ref),
              space,
              // TODO: Correct usage of item api endpoint
              buildItemFilter(ref),
            ],
          ),
        ),
      ],
    ));
  }

  Container buildIgnoreSingleUnitTraitsCheckBox(WidgetRef ref) => Container(
        width: double.infinity, // takes all available width
        height: 50.0, // adjust this value as needed
        alignment: Alignment.centerLeft, // aligns the child to the left
        child: Row(
          children: [
            Switch(
              value: ref.watch(ignoreSingleUnitTraitsProvider),
              onChanged: (newValue) {
                ref.read(ignoreSingleUnitTraitsProvider.notifier).state =
                    newValue;
              },
            ),
            const Text("Ignore single unit traits",
                style: TextStyle(fontSize: 16)),
          ],
        ),
      );

  TextButton buildSelectDatetimeButton(BuildContext context, WidgetRef ref) {
    DateTime minDatetime = ref.watch(minDateTimeProvider);
    return TextButton.icon(
      icon: const Icon(Icons.calendar_today),
      label: Text(
          "Matches since ${minDatetime.day}-${minDatetime.month}-${minDatetime.year}",
          style: const TextStyle(fontSize: 10)),
      onPressed: () => showDateTimePicker(context: context, ref: ref),
    );
  }

  void showDateTimePicker(
      {required BuildContext context, required WidgetRef ref}) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: ref.watch(minDateTimeProvider),
      firstDate: ref
          .watch(minDateTimeProvider)
          .subtract(const Duration(days: 365 * 100)),
      lastDate:
          ref.watch(minDateTimeProvider).add(const Duration(days: 365 * 200)),
    );

    if (selectedDate == null) return null;

    if (!context.mounted) return null;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );

    ref.read(minDateTimeProvider.notifier).state = selectedTime == null
        ? selectedDate
        : DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
  }

  Container buildChampionFilter(WidgetRef ref) {
    final championNamesAsyncValue = ref.watch(championNameProvider);

    return Container(
        child: championNamesAsyncValue.when(
      data: (List<String>? championNames) => championNames == null
          ? Container() // Return an empty Container (or any other widget) when championNames is null
          : DropdownButtonFormField<String>(
              value: ref.watch(championFilterProvider),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Filter by Champion",
              ),
              items: championNames.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                ref.read(championFilterProvider.notifier).state = newValue!;
              },
            ),
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text(error.toString()),
    ));
  }

  Container buildItemFilter(WidgetRef ref) {
    final itemNamesAsyncValue = ref.watch(itemNameProvider);

    return Container(
        child: itemNamesAsyncValue.when(
      data: (List<String>? itemNames) => itemNames == null
          ? Container() // Return an empty Container (or any other widget) when championNames is null
          : DropdownButtonFormField<String>(
              value: ref.watch(itemFilterProvider),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Filter by Item",
              ),
              items: itemNames.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                ref.read(itemFilterProvider.notifier).state = newValue!;
              },
            ),
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text(error.toString()),
    ));
  }

  Container buildTraitFilter(WidgetRef ref) {
    final traitNamesAsyncValue = ref.watch(traitNameProvider);

    return Container(
        child: traitNamesAsyncValue.when(
      data: (List<String>? traitNames) => traitNames == null
          ? Container()
          : DropdownButtonFormField<String>(
              value: ref.watch(traitFilterProvider),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Filter by Trait",
              ),
              items: traitNames.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                ref.read(traitFilterProvider.notifier).state = newValue!;
              },
            ),
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text(error.toString()),
    ));
  }

  TextFormField buildPatchInput(WidgetRef ref) => TextFormField(
        onFieldSubmitted: (value) =>
            ref.read(patchProvider.notifier).state = value,
        initialValue: ref.watch(patchProvider),
        decoration: const InputDecoration(
          labelText: "Patch",
          border: OutlineInputBorder(),
        ),
      );

  Padding buildSliders(WidgetRef ref) {
    const double minPlacement = 1;
    const double maxPlacement = 8;
    int placementDivisions = maxPlacement.toInt() - 1;
    double maxCombinationSize = ref.watch(groupByProvider) == "trait" ? 7 : 2;
    return Padding(
        padding: listViewChildrenPadding,
        child: Column(
          children: [
            Text("Max placement: ${ref.watch(maxPlacementProvider)}"),
            Slider(
              value: ref.watch(maxPlacementProvider).toDouble(),
              min: minPlacement,
              max: maxPlacement,
              divisions: placementDivisions,
              onChanged: (double value) {
                ref.read(maxPlacementProvider.notifier).state = value.toInt();
              },
            ),
            Text(
                "Max average placement: ${ref.watch(maxAvgPlacementProvider)}"),
            Slider(
              value: ref.watch(maxAvgPlacementProvider).toDouble(),
              min: minPlacement,
              max: maxPlacement,
              divisions: placementDivisions,
              onChanged: (double value) {
                ref.read(maxAvgPlacementProvider.notifier).state =
                    value.toInt();
              },
            ),
            Text("Min occurences: ${ref.watch(minCounterProvider)}"),
            Slider(
              value: ref.watch(minCounterProvider).toDouble(),
              min: 1,
              max: 100,
              divisions: 20,
              onChanged: (double value) {
                ref.read(minCounterProvider.notifier).state = value.toInt();
              },
            ),
            Text(ref.watch(combinationSizeProvider) > 0
                ? "Combination size: ${ref.watch(combinationSizeProvider)}"
                : "Combination size"),
            Slider(
              value: ref.watch(combinationSizeProvider).toDouble(),
              min: 0,
              max: maxCombinationSize,
              divisions: maxCombinationSize.toInt(),
              onChanged: (double value) {
                ref.read(combinationSizeProvider.notifier).state =
                    value.toInt();
              },
            ),
          ],
        ));
  }
}
