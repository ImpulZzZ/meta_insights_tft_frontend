import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta_insights_tft_frontend/models/composition_group.dart';
import 'package:meta_insights_tft_frontend/services/api_request_service.dart';
import 'package:meta_insights_tft_frontend/widgets/widget_lib.dart';

const listViewChildrenPadding = EdgeInsets.all(6);

final regionProvider = StateProvider((ref) => "europe");
final leagueProvider = StateProvider((ref) => "challenger");
final patchProvider = StateProvider((ref) => "13.23");
final maxPlacementProvider = StateProvider((ref) => 4);
final maxAvgPlacementProvider = StateProvider((ref) => 4);
final minCounterProvider = StateProvider((ref) => 4);
final combinationSizeProvider = StateProvider((ref) => "");
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
      ref.watch(minDateTimeProvider));
});

final iconProvider = FutureProvider<Map<String, String>?>((ref) async {
  return ref.read(apiServiceProvider).getIconMap(ref.watch(groupByProvider));
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
      endDrawer: buildFilterDrawer(context, ref),
    );
  }

  Drawer buildFilterDrawer(BuildContext context, WidgetRef ref) => Drawer(
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
          ExpansionTile(
            title: const Text("General"),
            children: [
              buildPatchInput(ref),
              buildRegionInput(ref),
              buildLeagueInput(ref),
              buildSelectDatetimeButton(context, ref),
            ],
          ),
          ExpansionTile(
            title: const Text("Performance"),
            initiallyExpanded: true,
            children: [
              buildMaxPlacementInput(ref),
              buildMaxAvgPlacementInput(ref),
              buildMinCounterInput(ref),
            ],
          ),
          ExpansionTile(
            title: const Text("Combinations"),
            children: [
              buildGroupByInput(ref),
              buildCombinationSizeInput(ref),
              buildIgnoreSingleUnitTraitsCheckBox(ref),
            ],
          ),
        ],
      ));

  Padding buildIgnoreSingleUnitTraitsCheckBox(WidgetRef ref) => Padding(
        padding: listViewChildrenPadding,
        child: Container(
          width: double.infinity, // takes all available width
          height: 50.0, // adjust this value as needed
          alignment: Alignment.centerLeft, // aligns the child to the left
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: CheckboxListTile(
            title: const Text("Ignore single unit traits"),
            value: ref.watch(ignoreSingleUnitTraitsProvider),
            onChanged: (newValue) {
              ref.read(ignoreSingleUnitTraitsProvider.notifier).state =
                  newValue!;
            },
            controlAffinity: ListTileControlAffinity.trailing,
          ),
        ),
      );

  Padding buildSelectDatetimeButton(BuildContext context, WidgetRef ref) {
    DateTime minDatetime = ref.watch(minDateTimeProvider);
    return Padding(
      padding: listViewChildrenPadding,
      child: Container(
        width: double.infinity, // takes all available width
        height: 50.0, // adjust this value as needed
        alignment: Alignment.centerLeft, // aligns the child to the left
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: TextButton.icon(
          icon: const Icon(Icons.calendar_today),
          label: Text(
              "Matches since: ${minDatetime.year}-${minDatetime.month}-${minDatetime.day}"),
          onPressed: () => showDateTimePicker(context: context, ref: ref),
        ),
      ),
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

  Padding buildGroupByInput(WidgetRef ref) => Padding(
      padding: listViewChildrenPadding,
      child: DropdownButtonFormField<String>(
          value: ref.watch(groupByProvider),
          decoration: const InputDecoration(
              border: OutlineInputBorder(), labelText: "League"),
          items: <String>['trait', 'champion'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            ref.read(groupByProvider.notifier).state = newValue!;
          }));

  Padding buildPatchInput(WidgetRef ref) => Padding(
        padding: listViewChildrenPadding,
        child: TextFormField(
          onFieldSubmitted: (value) =>
              ref.read(patchProvider.notifier).state = value,
          initialValue: ref.watch(patchProvider),
          decoration: const InputDecoration(
            labelText: "Patch",
            border: OutlineInputBorder(),
          ),
        ),
      );

  Padding buildRegionInput(WidgetRef ref) => Padding(
      padding: listViewChildrenPadding,
      child: DropdownButtonFormField<String>(
          value: ref.watch(regionProvider),
          decoration: const InputDecoration(
              border: OutlineInputBorder(), labelText: "Region"),
          items: <String>['europe', 'korea'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            ref.read(regionProvider.notifier).state = newValue!;
          }));

  Padding buildLeagueInput(WidgetRef ref) => Padding(
      padding: listViewChildrenPadding,
      child: DropdownButtonFormField<String>(
          value: ref.watch(leagueProvider),
          decoration: const InputDecoration(
              border: OutlineInputBorder(), labelText: "League"),
          items: <String>['challenger', 'grandmaster', 'master']
              .map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            ref.read(leagueProvider.notifier).state = newValue!;
          }));

  Padding buildMaxPlacementInput(WidgetRef ref) => Padding(
        padding: listViewChildrenPadding,
        child: TextFormField(
          initialValue: ref.watch(maxPlacementProvider).toString(),
          onFieldSubmitted: (value) =>
              ref.read(maxPlacementProvider.notifier).state = int.parse(value),
          decoration: const InputDecoration(
            labelText: "Max placement",
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            FilteringTextInputFormatter.allow(RegExp('[1-8]'))
          ],
        ),
      );

  Padding buildMaxAvgPlacementInput(WidgetRef ref) => Padding(
        padding: listViewChildrenPadding,
        child: TextFormField(
          initialValue: ref.watch(maxAvgPlacementProvider).toString(),
          onFieldSubmitted: (value) => ref
              .read(maxAvgPlacementProvider.notifier)
              .state = int.parse(value),
          decoration: const InputDecoration(
            labelText: "Max Avg placement",
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            FilteringTextInputFormatter.allow(RegExp('[1-8]'))
          ],
        ),
      );

  Padding buildMinCounterInput(WidgetRef ref) => Padding(
        padding: listViewChildrenPadding,
        child: TextFormField(
          initialValue: ref.watch(minCounterProvider).toString(),
          onFieldSubmitted: (value) =>
              ref.read(minCounterProvider.notifier).state = int.parse(value),
          decoration: const InputDecoration(
            labelText: "Min occurences",
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            FilteringTextInputFormatter.allow(RegExp('[0-9]'))
          ],
        ),
      );

  Padding buildCombinationSizeInput(WidgetRef ref) => Padding(
        padding: listViewChildrenPadding,
        child: TextFormField(
          initialValue: ref.watch(combinationSizeProvider).toString(),
          onFieldSubmitted: (value) =>
              ref.read(combinationSizeProvider.notifier).state = value,
          decoration: const InputDecoration(
            labelText: "Combination size",
            helperText: "Traits: [1-7]  Champions [1-2]",
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            FilteringTextInputFormatter.allow(RegExp('[1-7]'))
          ],
        ),
      );
}
