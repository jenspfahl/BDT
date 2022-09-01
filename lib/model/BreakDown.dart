import 'dart:collection';

class BreakDown implements Comparable<BreakDown> {

  int id;
  String name;
  Set<int> slices = HashSet<int>();

  BreakDown(this.id, this.name, this.slices);

  BreakDown.data(int id, String name, List<int> slices)
      : this(id * -1, name, slices.toSet());

  BreakDown.fromJson(Map<String, dynamic> jsonMap)
      : this(
      jsonMap['id'],
      jsonMap['name'],
      jsonMap['slices'].toString()
          .split(',')
          .map((e) => int.parse(e))
          .toSet());


  @override
  int compareTo(BreakDown other) {
    return id.compareTo(other.id);
  }

  bool operator == (Object other) {
    if (other is BreakDown) {
      return compareTo(other) == 0;
    }
    return false;
  }

  @override
  String toString() {
    return 'BreakDown{id: $id, name: $name}';
  }

  String getSlicesAsString() {
    final sorted = slices.toList()..sort();
    return sorted.join(',');
  }

  bool isPredefined() => id < 0;


  Map<String, dynamic> toJson() => {
    'id' : id,
    'name': name,
    'slices': getSlicesAsString(),
  };

}


List<BreakDown> predefinedBreakDowns = [
  BreakDown.data(1, '1/2', [30]),
  BreakDown.data(2, '1/3   1/3', [20, 40]),
  BreakDown.data(3, '1/4   1/4   1/4', [15, 30, 45]),
  BreakDown.data(4, '1/8   1/8   1/8   1/8   1/8   1/8   1/8', [7, 15, 22, 30, 37, 45, 52]),
  BreakDown.data(5, 'every 5th slice', [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55]),
  BreakDown.data(6, 'every 3rd slice', [3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45, 48, 51, 54, 57]),
  BreakDown.data(7, '1/2   1/4   1/8', [30, 45, 53]),
  BreakDown.data(8, '1/4   1/4   1/4   1/8   1/16', [15, 30, 45, 52, 56]),
];


