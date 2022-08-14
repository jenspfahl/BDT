import 'dart:collection';

class BreakDown {

  int? id;
  String name;
  Set<int> slices = HashSet<int>();

  BreakDown(this.id, this.name, this.slices);

  BreakDown.data(int id, String name, List<int> slices) : this(id * -10000, name, slices.toSet());

}

List<BreakDown> predefinedBreakDowns = [
  BreakDown.data(1, "1/2", [30]),
  BreakDown.data(2, "1/3   1/3", [20, 40]),
  BreakDown.data(3, "1/4   1/4   1/4", [15, 30, 45]),
  BreakDown.data(4, "1/8   1/8   1/8   1/8   1/8   1/8   1/8", [7, 15, 22, 30, 37, 45, 52]),
  BreakDown.data(5, "1/2   1/4   1/8", [30, 45, 53]),
  BreakDown.data(6, "1/4   1/4   1/4   1/8   1/16", [15, 30, 45, 52, 56]),
];

