import 'package:flutter/material.dart';
import 'package:http/http.dart';
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

  @override
  void initState() {
    super.initState();

    patchController = TextEditingController(text: "13.22");
    getData();
  }

  @override
  void dispose() {
    patchController.dispose();
    super.dispose();
  }

  getData() async {
    compositionGroups = await ApiRequestService()
        .getCompositionGroups(groupBy, patchController.text);
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
                  Row(
                    children: [
                      buildPatchTextfield(patchController),
                      buildApplyButton()
                    ],
                  ),
                  Flexible(
                    child: CompositionGroupTable(
                      compositionGroups: compositionGroups!,
                      icons: icons!,
                      groupBy: groupBy,
                    ),
                  ),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }

  Expanded buildApplyButton() => Expanded(
        child: SizedBox(
            child: TextButton(
          child: const Text("Apply filters"),
          onPressed: () => setState(() {
            final String patch = patchController.text;
            getData();
          }),
        )),
      );

  Expanded buildGroupByButton() => Expanded(
        child: SizedBox(
            child: TextButton(
          child: Text("Group by $groupBy"),
          onPressed: () => setState(() {
            switch (groupBy) {
              case "trait":
                groupBy = "champion";
                break;
              case "champion":
                groupBy = "trait";
                break;
            }
            getData();
          }),
        )),
      );

  Expanded buildPatchTextfield(TextEditingController controller) => Expanded(
        child: SizedBox(
            child: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Patch'),
        )),
      );
}
