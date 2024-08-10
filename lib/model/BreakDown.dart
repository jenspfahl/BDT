import 'dart:collection';

import 'package:bdt/util/dates.dart';
import 'package:flutter/material.dart';

class BreakDown implements Comparable<BreakDown> {

  int id;
  String name;
  Set<int> slices = HashSet<int>();
  Duration? duration;
  TimeOfDay? time;

  BreakDown._internal(this.id, this.name, this.slices, this.duration, this.time);
  BreakDown(this.id, this.name, this.slices);
  BreakDown.withDuration(this.id, this.name, this.slices, this.duration);
  BreakDown.withTime(this.id, this.name, this.slices, this.time);

  BreakDown.data(int id, String name, List<int> slices, Duration? duration, TimeOfDay? time)
      : this._internal(id * -1, name, slices.toSet(), duration, time);

  BreakDown.fromJson(Map<String, dynamic> jsonMap)
      : this._internal(
      jsonMap['id'],
      jsonMap['name'],
      jsonMap['slices'].toString()
          .split(',')
          .map((e) => int.tryParse(e))
          .whereType<int>()
          .toSet(),
      jsonMap['duration'] != null
        ? Duration(seconds: jsonMap['duration'])
        : null,
      jsonMap['time'] != null
          ? TimeOfDay(
            hour: int.parse(jsonMap['time'].toString().split(':').first),
            minute: int.parse(jsonMap['time'].toString().split(':').last))
          : null,
  );


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

  String getPresetName() {
    if (duration != null) {
      return '$name [for ${formatDuration(duration!)}]';
    }
    else if (time != null) {
      return '$name [at ${formatTimeOfDay(time!)}]';
    }
    else {
      return name;
    }
  }

  bool isPredefined() => id < 0;


  Map<String, dynamic> toJson() => {
    'id' : id,
    'name': name,
    'slices': getSlicesAsString(),
    'duration': duration?.inSeconds,
    'time': time != null
        ? '${time!.hour}:${time!.minute}'
        : null
  };

}


List<BreakDown> predefinedBreakDowns = [
  BreakDown.data(1, '1/2', [30], null, null),
  BreakDown.data(2, '1/3   1/3', [20, 40], null, null),
  BreakDown.data(3, '1/4   1/4   1/4', [15, 30, 45], null, null),
  BreakDown.data(4, '1/8   1/8   1/8   1/8   1/8   1/8   1/8', [7, 15, 22, 30, 37, 45, 52], null, null),
  BreakDown.data(5, 'every 5th slice', [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55], null, null),
  BreakDown.data(6, 'every 3rd slice', [3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45, 48, 51, 54, 57], null, null),
  BreakDown.data(7, '1/2   1/4   1/8', [30, 45, 53], null, null),
  BreakDown.data(8, '1/4   1/4   1/4   1/8   1/16', [15, 30, 45, 52, 56], null, null),
  BreakDown.data(9, 'every 5 minutes', [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55], const Duration(hours: 1), null),
  BreakDown.data(10, 'every 10 minutes', [10, 20, 30, 40, 50], const Duration(hours: 1), null),
  BreakDown.data(11, 'every 15 minutes', [15, 30, 45], const Duration(hours: 1), null),
];


