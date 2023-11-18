import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta_insights_tft_frontend/models/composition_group.dart';
import 'package:meta_insights_tft_frontend/services/api_request_service.dart';
import 'package:meta_insights_tft_frontend/widgets/widget_lib.dart';

class CompositionGroupPage extends StatefulWidget {
  const CompositionGroupPage({super.key});

  @override
  State<CompositionGroupPage> createState() => _CompositionGroupPageState();
}

class _CompositionGroupPageState extends State<CompositionGroupPage> {
  List<CompositionGroup>? compositionGroups;
  Map<String, String>? icons;
  String groupBy = "trait";
  bool ignoreSingleUnitTraits = false;
  DateTime minDatetime = DateTime.now().subtract(const Duration(days: 14));
  var isLoaded = false;

  late final TextEditingController patchController;
  late final TextEditingController regionController;
  late final TextEditingController leagueController;
  late final TextEditingController maxPlacementController;
  late final TextEditingController maxAvgPlacementController;
  late final TextEditingController minCounterController;
  late final TextEditingController nTraitsController;

  @override
  void initState() {
    super.initState();

    patchController = TextEditingController(text: "13.22");
    regionController = TextEditingController(text: "europe");
    leagueController = TextEditingController(text: "challenger");
    maxPlacementController = TextEditingController(text: "4");
    maxAvgPlacementController = TextEditingController(text: "4");
    minCounterController = TextEditingController(text: "4");
    nTraitsController = TextEditingController(text: "");
    getData();
  }

  @override
  void dispose() {
    patchController.dispose();
    regionController.dispose();
    leagueController.dispose();
    maxPlacementController.dispose();
    maxAvgPlacementController.dispose();
    minCounterController.dispose();
    nTraitsController.dispose();
    super.dispose();
  }

  getData() async {
    isLoaded = false;
    compositionGroups = await ApiRequestService().getCompositionGroups(
        groupBy,
        patchController.text,
        nTraitsController.text.isEmpty
            ? null
            : int.parse(nTraitsController.text),
        ignoreSingleUnitTraits,
        int.parse(maxPlacementController.text),
        int.parse(maxAvgPlacementController.text),
        int.parse(minCounterController.text),
        regionController.text,
        leagueController.text,
        minDatetime);
    icons = await ApiRequestService().getIconMap(groupBy);
    if (compositionGroups != null && icons != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meta Insights"),
      ),
      body: Center(
        child: isLoaded
            ? Column(
                children: [
                  Flexible(
                    child: CompositionGroupTable(
                      compositionGroups: compositionGroups!,
                      icons: icons!,
                      groupBy: groupBy,
                    ),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
      endDrawer: buildFilterDrawer(),
    );
  }

  Drawer buildFilterDrawer() => Drawer(
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
          buildSizedTextField(patchController, "Patch"),
          buildSizedTextField(regionController, "Region"),
          buildSizedTextField(leagueController, "League"),
          buildSelectDatetimeButton(),
          buildSizedNumberField(
              nTraitsController, "Trait combination size", 1, 7),
          buildIgnoreSingleUnitTraitsCheckBox(),
          buildSizedNumberField(maxPlacementController, "Max placement", 1, 8),
          buildSizedNumberField(
              maxAvgPlacementController, "Max average placement", 1, 8),
          buildSizedNumberField(minCounterController, "Min occurences", 0, 999),
          buildApplyButton()
        ],
      ));

  SizedBox buildSelectDatetimeButton() => SizedBox(
        child: TextButton.icon(
          icon: const Icon(Icons.calendar_today),
          label: Text(
              "Matches since: ${minDatetime.year}-${minDatetime.month}-${minDatetime.day}"),
          onPressed: () => setState(() {
            showDateTimePicker(context: context);
          }),
        ),
      );

  SizedBox buildApplyButton() => SizedBox(
        child: ElevatedButton(
          child: const Text("Apply filters"),
          onPressed: () => setState(() {
            getData();
            Navigator.pop(context);
          }),
        ),
      );

  SizedBox buildSizedTextField(
          TextEditingController controller, String label) =>
      SizedBox(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
        ),
      );

  SizedBox buildIgnoreSingleUnitTraitsCheckBox() => SizedBox(
        child: CheckboxListTile(
          title: const Text("Ignore single unit traits"),
          value: ignoreSingleUnitTraits,
          onChanged: (newValue) {
            setState(() {
              ignoreSingleUnitTraits = newValue!;
            });
          },
          controlAffinity: ListTileControlAffinity.trailing,
        ),
      );

  SizedBox buildSizedNumberField(
          TextEditingController controller, String label, int min, int max) =>
      SizedBox(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            FilteringTextInputFormatter.allow(
                RegExp('[${min.toString()}-${max.toString()}]'))
          ],
        ),
      );

  void showDateTimePicker({
    required BuildContext context,
  }) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: minDatetime,
      firstDate: minDatetime.subtract(const Duration(days: 365 * 100)),
      lastDate: minDatetime.add(const Duration(days: 365 * 200)),
    );

    if (selectedDate == null) return null;

    if (!context.mounted) return null;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );

    setState(() {
      minDatetime = selectedTime == null
          ? selectedDate
          : DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              selectedTime.hour,
              selectedTime.minute,
            );
    });
  }
}
