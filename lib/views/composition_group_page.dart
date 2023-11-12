import 'package:flutter/material.dart';
import 'package:meta_insights_tft_frontend/models/composition_group.dart';
import 'package:meta_insights_tft_frontend/services/api_request_service.dart';

class CompositionGroupPage extends StatefulWidget {
  const CompositionGroupPage({super.key});

  @override
  State<CompositionGroupPage> createState() => _CompositionGroupPageState();
}

class _CompositionGroupPageState extends State<CompositionGroupPage> {
  List<CompositionGroup>? compositionGroups;
  Map<String, String>? traitIcons;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();

    // fetch from API
    getData();
  }

  getData() async {
    compositionGroups = await ApiRequestService().getCompositionGroupsByTrait();
    traitIcons = await ApiRequestService().getIconMap('trait');
    if (compositionGroups != null && traitIcons != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Composition Groups'),
        ),
        body: isLoaded
            ? CompositionGroupTable(
                compositionGroups: compositionGroups!, traitIcons: traitIcons!)
            : Center(child: CircularProgressIndicator()));
  }
}

class CompositionGroupTable extends StatefulWidget {
  final List<CompositionGroup> compositionGroups;
  final Map<String, String> traitIcons;

  CompositionGroupTable(
      {required this.compositionGroups, required this.traitIcons});

  @override
  State<CompositionGroupTable> createState() => _CompositionGroupTableState();
}

class _CompositionGroupTableState extends State<CompositionGroupTable> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DataTable(
          columns: [
            DataColumn(label: Text('Counter')),
            DataColumn(label: Text('Average Placement')),
            DataColumn(label: Text('Traits'))
          ],
          rows: [
            for (var compositionGroup in widget.compositionGroups)
              DataRow(cells: [
                DataCell(Text('${compositionGroup.getCounter()}')),
                DataCell(Text('${compositionGroup.getAvgPlacement()}')),
                DataCell(TraitStylesRow(
                  traitStyles: compositionGroup.getTraitStyles(),
                  traitIcons: widget.traitIcons,
                )),
              ]),
          ],
        )
      ],
    );
  }
}

class TraitStylesRow extends StatelessWidget {
  final Map<String, int> traitStyles;
  final Map<String, String> traitIcons;

  TraitStylesRow({required this.traitStyles, required this.traitIcons});

  Color getStyleColor(int style) {
    switch (style) {
      case 1:
        return const Color.fromARGB(255, 167, 116, 98);
      case 2:
        return const Color.fromARGB(255, 132, 164, 180);
      case 3:
        return const Color.fromARGB(255, 194, 180, 58);
      case 4:
        return const Color.fromARGB(255, 102, 225, 241);
    }
    return const Color.fromARGB(255, 255, 255, 255);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var trait in traitStyles.keys)
          Container(
            width: 30,
            height: 30,
            color: getStyleColor(traitStyles[trait]!),
            child: Image(
              image: AssetImage('assets${traitIcons[trait]}'),
              fit: BoxFit.fill,
              color: Colors.black,
            ),
          )
      ],
    );
  }
}
