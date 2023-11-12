import 'package:flutter/material.dart';
import 'package:meta_insights_tft_frontend/models/composition.dart';
import 'package:meta_insights_tft_frontend/services/api_request_service.dart';

class CompositionPage extends StatefulWidget {
  const CompositionPage({super.key});

  @override
  State<CompositionPage> createState() => _CompositionPageState();
}

class _CompositionPageState extends State<CompositionPage> {
  List<Composition>? compositions;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();

    // fetch from API
    getData();
  }

  getData() async {
    compositions = await ApiRequestService().getCompositions();
    if (compositions != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Compositions'),
        ),
        body: Visibility(
            visible: isLoaded,
            replacement: Center(
              child: CircularProgressIndicator(),
            ),
            child: ListView.builder(
                itemCount: compositions?.length,
                itemBuilder: (context, index) {
                  return Text(compositions![index].id.toString());
                })));
  }
}
