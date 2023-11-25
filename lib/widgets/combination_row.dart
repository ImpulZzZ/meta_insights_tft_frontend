part of widget_lib;

class CombinationRow extends StatelessWidget {
  final Map<String, int> composition;
  final Map<String, String> icons;
  final String groupBy;

  const CombinationRow(
      {super.key,
      required this.composition,
      required this.icons,
      required this.groupBy});

  Color getStyleColor(int? style) {
    switch (style) {
      case 0:
        return const Color.fromARGB(255, 255, 255, 255);
      case 1:
        return const Color.fromARGB(255, 167, 116, 98);
      case 2:
        return const Color.fromARGB(255, 132, 164, 180);
      case 3:
        return const Color.fromARGB(255, 194, 180, 58);
      default:
        return const Color.fromARGB(255, 102, 225, 241);
    }
  }

  Row getStarRow(int? starAmount) {
    List<Icon> stars = [];
    for (var i = 0; i < starAmount!; i++) {
      stars.add(const Icon(
        Icons.star,
        color: Color.fromARGB(255, 255, 115, 0),
        size: 10,
      ));
    }
    return Row(children: stars);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var current in composition.keys) ...[
          Column(
            children: [
              Text(current,
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.bold)),
              groupBy == "champion"
                  ? getStarRow(composition[current])
                  : Container(),
              Container(
                width: 65,
                height: 65,
                color: groupBy == "trait"
                    ? getStyleColor(composition[current])
                    : null,
                child: Image(
                  image: AssetImage('assets${icons[current]}'),
                  fit: BoxFit.fill,
                  color: groupBy == "trait" ? Colors.black : null,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
        ]
      ],
    );
  }
}
