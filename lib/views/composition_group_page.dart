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
  var isLoaded = false;

  late final TextEditingController patchController;
  late final TextEditingController regionController;
  late final TextEditingController leagueController;
  late final TextEditingController maxPlacementController;
  late final TextEditingController maxAvgPlacementController;
  late final TextEditingController minCounterController;

  @override
  void initState() {
    super.initState();

    patchController = TextEditingController(text: "13.22");
    regionController = TextEditingController(text: "europe");
    leagueController = TextEditingController(text: "challenger");
    maxPlacementController = TextEditingController(text: "4");
    maxAvgPlacementController = TextEditingController(text: "4");
    minCounterController = TextEditingController(text: "4");
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
    super.dispose();
  }

  getData() async {
    isLoaded = false;
    compositionGroups = await ApiRequestService().getCompositionGroups(
        groupBy,
        patchController.text,
        null,
        null,
        int.parse(maxPlacementController.text),
        int.parse(maxAvgPlacementController.text),
        int.parse(minCounterController.text),
        regionController.text,
        leagueController.text,
        null);
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
          buildSizedNumberField(maxPlacementController, "Max placement", 1, 8),
          buildSizedNumberField(
              maxAvgPlacementController, "Max average placement", 1, 8),
          buildSizedNumberField(minCounterController, "Min occurences", 0, 999),
          buildApplyButton()
        ],
      ));

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
}
