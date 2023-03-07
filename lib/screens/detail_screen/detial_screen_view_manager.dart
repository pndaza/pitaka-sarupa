import 'package:flutter/foundation.dart';

import '../../enums/state_status.dart';
import '../../models/detail.dart';
import '../../models/favourite.dart';
import '../../models/topic.dart';
import '../../repositories/favourite_repository.dart';
import '../../repositories/topic_repository.dart';

class DetailScreenViewManager {
  DetailScreenViewManager({
    required this.topicRepository,
    required this.favouriteRepisotry,
    required this.topic,
  });
  final TopicRepositoryDatabase topicRepository;
  final FavouriteRepisotry favouriteRepisotry;
  final Topic topic;

  late final ValueNotifier<StateStaus> _stateStatus =
      ValueNotifier<StateStaus>(StateStaus.loading);
  ValueListenable<StateStaus> get stateStatus => _stateStatus;

  late final ValueNotifier<bool?> _isFavourtie = ValueNotifier<bool?>(null);
  ValueListenable<bool?> get isFavourtie => _isFavourtie;

  late final Detail _detail;
  Detail get detail => _detail;

  void load() async {
    _detail = await topicRepository.getDetial(topic.id);
    var isFavourited = await favouriteRepisotry.isContain(topic.id);
    _isFavourtie.value = isFavourited;
    _stateStatus.value = StateStaus.data;
  }

  void onFavouritButtonCliked(bool isFavouriteOldValue) {
    if (isFavouriteOldValue) {
      removeFromFavourite(topic.id);
    } else {
      addToFavourite(topic.id);
    }
  }

  void addToFavourite(int topicID) async {
    var favourite = Favourite(
      topicID: topicID,
      topicName: '',
      dateTime: DateTime.now(),
    );
    await favouriteRepisotry.add(favourite);
  }

  void removeFromFavourite(int topicID) async {
    favouriteRepisotry.remove(topicID);
  }
}
