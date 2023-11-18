part of widget_lib;

class CombinationRow extends StatelessWidget {
  final Map<String, int> composition;
  final Map<String, String> icons;
  final String groupBy;

  const CombinationRow(
      {super.key, required this.composition, required this.icons, required this.groupBy});

  Color getStyleColor(int? style) {
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
        for (var current in composition.keys)
          Container(
            width: 30,
            height: 30,
            color:
                groupBy == "trait" ? getStyleColor(composition[current]) : null,
            child: Image(
              image: AssetImage('assets${icons[current]}'),
              fit: BoxFit.fill,
              color: groupBy == "trait" ? Colors.black : null,
            ),
          )
      ],
    );
  }
}
