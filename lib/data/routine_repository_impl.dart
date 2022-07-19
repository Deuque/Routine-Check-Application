import 'dart:convert';

import 'package:nomba/data/routine_repository.dart';
import 'package:nomba/domain/routine_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoutineRepositoryImpl implements RoutineRepository {
  Future<SharedPreferences> get _prefInstance =>
      SharedPreferences.getInstance();

  @override
  Future<Set<RoutineModel>> getRoutines() async {
    final instance = await _prefInstance;
    final storedList = instance.getStringList('routines') ?? [];
    return storedList.map((e) => RoutineModel.fromJson(jsonDecode(e))).toSet();
  }

  @override
  Future<bool> saveRoutines(Set<RoutineModel> routines) async {
    final instance = await _prefInstance;
    final encodedStringList = routines.map((e) => jsonEncode(e)).toList();
    return instance.setStringList('routines', encodedStringList);
  }
}
