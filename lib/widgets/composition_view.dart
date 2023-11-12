part of widget_lib;

class CompositionView extends StatelessWidget {
  List<CompositionGroup> compositionGroups;
  Map<String, String> icons;
  String groupBy;

  CompositionView(
      {required this.compositionGroups,
      required this.icons,
      required this.groupBy});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DataTable(
          columns: getTableHeaders(),
          rows: [
            for (var compositionGroup in compositionGroups)
              DataRow(cells: [
                DataCell(Text('${compositionGroup.getCounter()}')),
                DataCell(Text('${compositionGroup.getAvgPlacement()}')),
                DataCell(CombinationRow(
                  composition: compositionGroup.getCombination(),
                  icons: icons,
                  groupBy: groupBy,
                )),
              ]),
          ],
        )
      ],
    );
  }

  List<DataColumn> getTableHeaders() {
    switch (groupBy) {
      case "trait":
        return [
          DataColumn(label: Text('Occurences')),
          DataColumn(label: Text('Average Placement')),
          DataColumn(label: Text('Traits'))
        ];
      case "champion":
        return [
          DataColumn(label: Text('Occurences')),
          DataColumn(label: Text('Average Placement')),
          DataColumn(label: Text('Champions'))
        ];
    }
    return [];
  }
}
