
import 'package:flutter/material.dart';

import '../ui/utils.dart';


class BdtColorScheme implements Comparable<BdtColorScheme> {

  int id;
  String name;
  Color primary;
  MaterialColor button;
  Color accent;
  Color foreground;
  Color background;

  BdtColorScheme(this.id, this.name, this.primary, this.button, this.accent, this.foreground, this.background);

  @override
  int compareTo(BdtColorScheme other) {
    return id.compareTo(other.id);
  }

  BdtColorScheme darken() {
    if (id == 5) { // yellow on white is tricky, so we have to adjust it a bit
      return BdtColorScheme(
          id,
          name,
          Colors.yellow[800]!,
          button,
          darker(accent, 180),
          Colors.yellow[600]!,
          lighter(background, 250));
    }
    else {
      return BdtColorScheme(
          id,
          name,
          darker(primary, 90),
          button,
          darker(accent, 180),
          darker(foreground, 90),
          lighter(background, 240));
    }
  }

}

List<BdtColorScheme> predefinedColorSchemes = [
  BdtColorScheme(0, 'Ocean Blue', Colors.blue[900]!, Colors.blue, Colors.blue[50]!, Colors.lightBlue, Colors.black),
  BdtColorScheme(1, 'Cool Cyan', Colors.cyan[900]!, Colors.cyan, Colors.cyan[50]!, Colors.cyanAccent, Colors.black),
  BdtColorScheme(2, 'Magic Teal', Colors.teal[900]!, Colors.teal, Colors.teal[50]!, Colors.tealAccent, Colors.black),
  BdtColorScheme(3, 'Velvet Green', Colors.green[900]!, Colors.green, Colors.green[50]!, Colors.greenAccent, Colors.black),
  BdtColorScheme(4, 'Fresh Lime', Colors.lime[900]!, Colors.lime, Colors.lime[50]!, Colors.limeAccent, Colors.black),
  BdtColorScheme(5, 'Sunny Yellow', Colors.yellow[900]!, Colors.yellow, Colors.white, Colors.yellowAccent, Colors.black),
  BdtColorScheme(6, 'Golden Orange', Colors.orange[900]!, Colors.orange, Colors.white, Colors.orangeAccent, Colors.black),
  BdtColorScheme(7, 'Tomato Red', Colors.red[900]!, Colors.red, Colors.red[50]!, Colors.redAccent, Colors.black),
  BdtColorScheme(8, 'Rainy Purple', Colors.purple[900]!, Colors.purple, Colors.purple[50]!, Colors.purpleAccent, Colors.black),
  BdtColorScheme(9, 'Pinky Panther', Colors.pink[900]!, Colors.pink, Colors.pink[50]!, Colors.pinkAccent, Colors.black),
  BdtColorScheme(10, 'Woody Brown', Colors.brown[900]!, Colors.brown, Colors.brown[50]!, Colors.brown[100]!, Colors.black),
  BdtColorScheme(11, 'Concrete Gray', Colors.grey[900]!, Colors.grey, Colors.grey[50]!, Colors.grey[200]!, Colors.black),
  BdtColorScheme(12, 'Stone Gray', Colors.blueGrey[700]!, Colors.blueGrey, Colors.blueGrey[50]!, Colors.blueGrey[100]!, Colors.black),

];

