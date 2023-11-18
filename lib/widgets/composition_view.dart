part of widget_lib;

class CompositionView extends StatelessWidget {
  final List<CompositionGroup> compositionGroups;
  final Map<String, String> icons;
  final String groupBy;

  const CompositionView(
      {super.key,
      required this.compositionGroups,
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
                DataCell(Text(compositionGroup.getCounter())),
                DataCell(Text(compositionGroup.getAvgPlacement())),
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
          const DataColumn(label: Text('Occurences')),
          const DataColumn(label: Text('Average Placement')),
          const DataColumn(label: Text('Traits'))
        ];
      case "champion":
        return [
          const DataColumn(label: Text('Occurences')),
          const DataColumn(label: Text('Average Placement')),
          const DataColumn(label: Text('Champions'))
        ];
    }
    return [];
  }
}
