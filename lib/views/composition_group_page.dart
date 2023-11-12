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
  var isLoaded = false;

  @override
  void initState() {
    super.initState();

    // fetch from API
    getData();
  }

  getData() async {
    compositionGroups = await ApiRequestService().getCompositionGroupsByTrait();
    icons = await ApiRequestService().getIconMap('trait');
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
        body: isLoaded
            ? CompositionGroupTable(
                compositionGroups: compositionGroups!,
                icons: icons!,
                groupBy: "trait")
            : Center(child: CircularProgressIndicator()));
  }
}
