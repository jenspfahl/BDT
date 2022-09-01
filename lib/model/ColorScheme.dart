
import 'package:flutter/material.dart';


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

}

List<BdtColorScheme> predefinedColorSchemes = [
  BdtColorScheme(0, 'Ocean blue', Colors.blue[900]!, Colors.blue, Colors.blue[50]!, Colors.lightBlue, Colors.black),
  BdtColorScheme(1, 'Cool Cyan', Colors.cyan[900]!, Colors.cyan, Colors.cyan[50]!, Colors.cyanAccent, Colors.black),
  BdtColorScheme(2, 'So teal', Colors.teal[900]!, Colors.teal, Colors.teal[50]!, Colors.tealAccent, Colors.black),
  BdtColorScheme(3, 'Velvet green', Colors.green[900]!, Colors.green, Colors.green[50]!, Colors.greenAccent, Colors.black),
  BdtColorScheme(4, 'Fresh lime', Colors.lime[900]!, Colors.lime, Colors.lime[50]!, Colors.limeAccent, Colors.black),
  BdtColorScheme(5, 'Sunny yellow', Colors.yellow[900]!, Colors.yellow, Colors.white, Colors.yellowAccent, Colors.black),
  BdtColorScheme(6, 'Golden orange', Colors.orange[900]!, Colors.orange, Colors.white, Colors.orangeAccent, Colors.black),
  BdtColorScheme(7, 'Tomato red', Colors.red[900]!, Colors.red, Colors.red[50]!, Colors.redAccent, Colors.black),
  BdtColorScheme(8, 'Rainy purple', Colors.purple[900]!, Colors.purple, Colors.purple[50]!, Colors.purpleAccent, Colors.black),
  BdtColorScheme(9, 'Pinky panther', Colors.pink[900]!, Colors.pink, Colors.pink[50]!, Colors.pinkAccent, Colors.black),
  BdtColorScheme(10, 'Woody brown', Colors.brown[900]!, Colors.brown, Colors.brown[50]!, Colors.brown[100]!, Colors.black),
  BdtColorScheme(11, 'Concrete gray', Colors.grey[900]!, Colors.grey, Colors.grey[50]!, Colors.grey[200]!, Colors.black),
  BdtColorScheme(12, 'Stone gray', Colors.blueGrey[700]!, Colors.blueGrey, Colors.blueGrey[50]!, Colors.blueGrey[100]!, Colors.black),

];

