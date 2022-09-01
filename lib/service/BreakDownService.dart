import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bdt/model/BreakDown.dart';
import 'package:flutter/cupertino.dart';

import 'PreferenceService.dart';




class BreakDownService {
  static final BreakDownService _service = BreakDownService._internal();

  factory BreakDownService() {
    return _service;
  }

  BreakDownService._internal() {}

  Future<List<BreakDown>> getAllBreakDowns() async {
    final breakDowns = List.of(predefinedBreakDowns, growable: true);
    final keys = await PreferenceService().getKeys(PreferenceService.DATA_SAVED_BREAK_DOWNS_PREFIX.key);
    keys.sort();
    debugPrint('breakdown keys: $keys');
    for (var key in keys) {
      final jsonString = await PreferenceService().getString(PrefDef(key, null));
      if (jsonString != null) {
        final savedBreakDown = BreakDown.fromJson(jsonDecode(jsonString));
        breakDowns.add(savedBreakDown);
      }
    }
    debugPrint('loaded breakdowns: $breakDowns');
    return List.of(breakDowns);
  }

  Future<BreakDown> getBreakDown(int id) async {
    if (id < 0) {
      return predefinedBreakDowns.firstWhere((element) => element.id == id);
    }
    else {
      final jsonString = await PreferenceService().getString(
          _createPrefKey(id));
      if (jsonString != null) {
        return BreakDown.fromJson(jsonDecode(jsonString));
      }
      throw Exception('BreakDown for id $id not found in prefs');
    }
  }

  Future<BreakDown> saveBreakDown(BreakDown breakDown) async {
    if (breakDown.isPredefined()) {
      throw Exception('Predefined breakdowns may not be overwritten');
    }

    if (breakDown.id == 0) {
      // new one
      final all = await getAllBreakDowns();
      int newId = max(all.last.id + 1, 1);
      breakDown.id = newId;
    }
    final json = jsonEncode(breakDown);
    final key = _createPrefKey(breakDown.id);
    await PreferenceService().setString(key, json);
    return breakDown;
  }
  
  deleteBreakDown(BreakDown breakDown) async {
    if (breakDown.isPredefined()) {
      throw Exception('Predefined breakdowns may not be deleted');
    }
    final key = _createPrefKey(breakDown.id);
    await PreferenceService().remove(key);
  }

  PrefDef _createPrefKey(int id) => PrefDef(PreferenceService.DATA_SAVED_BREAK_DOWNS_PREFIX.key + id.toString(), null);

}