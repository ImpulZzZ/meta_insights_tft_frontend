part of widget_lib;

class CompositionGroupTable extends StatefulWidget {
  final List<CompositionGroup>? compositionGroups;
  final Map<String, String>? icons;
  final String groupBy;

  const CompositionGroupTable(
      {super.key,
      required this.compositionGroups,
      required this.icons,
      required this.groupBy});

  @override
  State<CompositionGroupTable> createState() => _CompositionGroupTableState();
}

class _CompositionGroupTableState extends State<CompositionGroupTable> {
  @override
  Widget build(BuildContext context) {
    return CompositionView(
        compositionGroups: widget.compositionGroups ?? [],
        icons: widget.icons ?? {},
        groupBy: widget.groupBy);
  }
}
