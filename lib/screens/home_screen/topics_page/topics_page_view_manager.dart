import 'package:flutter/foundation.dart';
import '../../../models/recent.dart';
import '../../../repositories/recent_repository.dart';

import '../../../enums/state_status.dart';
import '../../../models/topic.dart';
import '../../../repositories/topic_repository.dart';

class TopicsPageViewManager {
  TopicsPageViewManager({
    required this.topicRepository,
    required this.recentRepository,
  });
  final TopicRepositoryDatabase topicRepository;
  final RecentRepository recentRepository;

  late final ValueNotifier<StateStaus> _stateStatus =
      ValueNotifier<StateStaus>(StateStaus.loading);
  ValueListenable<StateStaus> get stateStatus => _stateStatus;

  late final List<Topic> _cached = [];
  late final ValueNotifier<List<Topic>> _filteredTopics =
      ValueNotifier<List<Topic>>([]);
  ValueListenable<List<Topic>> get filteredTopics => _filteredTopics;

  String _filteredText = '';
  String get filteredText => _filteredText;

  Future<void> load() async {
    if (_cached.isEmpty) {
      _cached.addAll(await topicRepository.getTopics());
    }
    _filteredTopics.value = [..._cached];
    _stateStatus.value = StateStaus.data;
  }

  void onFilterChanged(String filterdText) {
    _filteredText = normailizeMyanmarText(filterdText);

    if (_filteredText.isEmpty) {
      _stateStatus.value = StateStaus.data;
      _filteredTopics.value = [..._cached];
      return;
    }

    _filteredTopics.value = [
      ..._cached.where((topic) => topic.name.contains(_filteredText))
    ];
    if (_filteredTopics.value.isEmpty) {
      _stateStatus.value = StateStaus.empty;
    } else {
      _stateStatus.value = StateStaus.data;
    }
  }

  String normailizeMyanmarText(String input) {
    return input.replaceAll('င့်', 'င့်');
  }

  void addToRecent(int topicID) {
    recentRepository.add(Recent(
      topicID: topicID,
      topicName: '', // will not store
      dateTime: DateTime.now(),
    ));
  }
}
