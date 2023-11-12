part of widget_lib;

class CompositionGroupTable extends StatefulWidget {
  List<CompositionGroup> compositionGroups;
  Map<String, String> traitIcons;

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
          columns: getTableHeaders('trait'),
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

  List<DataColumn> getTableHeaders(String groupBy) {
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
