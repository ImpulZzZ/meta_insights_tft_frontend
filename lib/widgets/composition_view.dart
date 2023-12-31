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
          dataRowMinHeight: 100,
          dataRowMaxHeight: 100,
          columns: [
            getUniformHeaderColumn("Occurences"),
            getUniformHeaderColumn("Average Placement"),
            getUniformHeaderColumn("Combination"),
          ],
          rows: [
            for (var compositionGroup in compositionGroups)
              DataRow(cells: [
                DataCell(
                  Text(compositionGroup.getCounter()),
                ),
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

  DataColumn getUniformHeaderColumn(String labelText) {
    return DataColumn(
        label: Text(
      labelText,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ));
  }
}
