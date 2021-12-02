import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobichan_data/mobichan_data.dart';

abstract class PostLocalDatasource {
  Future<List<PostModel>> addThreadToHistory(
      PostModel thread, BoardModel board);

  Future<List<PostModel>> getHistory();
}

class PostLocalDatasourceImpl implements PostLocalDatasource {
  final String apiUrl = 'https://a.4cdn.org';
  final String threadHistoryKey = 'thread_history';

  final SharedPreferences sharedPreferences;

  PostLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<List<PostModel>> addThreadToHistory(
      PostModel thread, BoardModel board) async {
    Map<String, dynamic> threadJson = thread.toJson();
    threadJson['board'] = board.toJson();
    PostModel newThread = PostModel.fromJson(threadJson);

    // Gets the history strings from the shared preferences
    List<String> historyStrings;
    if (sharedPreferences.containsKey(threadHistoryKey)) {
      historyStrings = sharedPreferences.getStringList(threadHistoryKey)!;
    } else {
      historyStrings = List.empty(growable: true);
    }

    // Converts the history string list to a list of PostModel
    List<PostModel> history = List.generate(historyStrings.length, (index) {
      return PostModel.fromJson(jsonDecode(historyStrings[index]));
    });

    if (history.contains(newThread)) {
      history.remove(newThread);
    }
    history.add(newThread);

    // Converts the history back into a list of strings
    List<String> historyStringsNew = List.generate(history.length, (index) {
      return jsonEncode(history[index].toJson());
    });

    sharedPreferences.setStringList(threadHistoryKey, historyStringsNew);
    return history;
  }

  @override
  Future<List<PostModel>> getHistory() async {
    if (sharedPreferences.containsKey(threadHistoryKey)) {
      List<String> historyStringList =
          sharedPreferences.getStringList(threadHistoryKey)!.reversed.toList();
      List<PostModel> history = historyStringList
          .map((e) => PostModel.fromJson(jsonDecode(e)))
          .toList();
      return history;
    }
    return [];
  }
}