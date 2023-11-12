part of widget_lib;

class TraitStylesRow extends StatelessWidget {
  final Map<String, int> traitStyles;
  final Map<String, String> icons;

  TraitStylesRow({required this.traitStyles, required this.icons});

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
              image: AssetImage('assets${icons[trait]}'),
              fit: BoxFit.fill,
              color: Colors.black,
            ),
          )
      ],
    );
  }
}
