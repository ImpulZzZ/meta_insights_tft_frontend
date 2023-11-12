part of widget_lib;

class CompositionGroupTable extends StatefulWidget {
  List<CompositionGroup> compositionGroups;
  Map<String, String> icons;
  String groupBy;

  CompositionGroupTable(
      {required this.compositionGroups,
      required this.icons,
      required this.groupBy});

  @override
  State<CompositionGroupTable> createState() => _CompositionGroupTableState();
}

class _CompositionGroupTableState extends State<CompositionGroupTable> {
  @override
  Widget build(BuildContext context) {
    return CompositionView(
        compositionGroups: widget.compositionGroups,
        icons: widget.icons,
        groupBy: widget.groupBy);
  }
}
