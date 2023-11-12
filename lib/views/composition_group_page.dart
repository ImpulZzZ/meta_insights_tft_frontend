import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();

    // fetch from API
    getData();
  }

  getData() async {
    compositionGroups = await ApiRequestService().getCompositionGroups(groupBy);
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
        title: Text("Meta Insights"),
      ),
      body: Center(
        child: isLoaded
            ? Column(
                children: [
                  Expanded(
                    child: SizedBox(
                        height: 100,
                        width: 100,
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
                  ),
                  Expanded(
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
}
