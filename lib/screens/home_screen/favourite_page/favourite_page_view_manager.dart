import 'package:flutter/material.dart';

import '../../../dialogs/confirm_dialog.dart';
import '../../../enums/state_status.dart';
import '../../../models/favourite.dart';
import '../../../models/topic.dart';
import '../../../repositories/favourite_repository.dart';
import '../../detail_screen/detail_screen.dart';

class FavouritePageViewManager {
  final FavouriteRepisotry favouriteRepository;

  final _state = ValueNotifier(StateStaus.loading);

  FavouritePageViewManager(this.favouriteRepository);
  ValueNotifier<StateStaus> get state => _state;

  final _isSelectionMode = ValueNotifier(false);
  ValueNotifier<bool> get isSelectionMode => _isSelectionMode;

  final _selectedItems = ValueNotifier<List<int>>([]);
  ValueNotifier<List<int>> get selectedItems => _selectedItems;

  final List<Favourite> _favourites = [];
  List<Favourite> get favourites => _favourites;

  void load() async {
    favourites.addAll(await _fetchFavourites());
    if (favourites.isEmpty) {
      _state.value = StateStaus.empty;
    } else
    {
      _state.value = StateStaus.data;
    }
  }

  void dispose() {
    _state.dispose();
    _isSelectionMode.dispose();
    _selectedItems.dispose();
  }

  Future<List<Favourite>> _fetchFavourites() async {
    return await favouriteRepository.getAll();
  }

  Future<void> _refresh() async {
    _state.value = StateStaus.loading;
    _favourites.clear();
    _favourites.addAll(await _fetchFavourites());
    if (favourites.isEmpty) {
      _state.value = StateStaus.empty;
    } else
    {
      _state.value = StateStaus.data;
    }
  }

  Future<void> onFavouriteItemClicked(BuildContext context, int index) async {
    if (!_isSelectionMode.value) {
      final favourite = _favourites[index];
      // opening book
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => DetailScreen(
                    topic: Topic(favourite.topicID, favourite.topicName),
                  ))).then((value) {
        _refresh();
      });
      return;
    }
    if (!_selectedItems.value.contains(index)) {
      _selectedItems.value = [..._selectedItems.value, index];
      return;
    }

    // remove form selected items
    _selectedItems.value.remove(index);
    _selectedItems.value = [..._selectedItems.value];
    // update selection mode
    if (_selectedItems.value.isEmpty) {
      _isSelectionMode.value = false;
    }
  }

  void onRecentItemPressed(BuildContext context, int index) {
    if (!_isSelectionMode.value) {
      _isSelectionMode.value = true;
      _selectedItems.value = [index];
    }
  }

  void onCancelButtonClicked() {
    // chnage mode
    _isSelectionMode.value = false;
    // clear selected items
    _selectedItems.value = [];
  }

  void onSelectAllButtonClicked() {
    if (_favourites.length == _selectedItems.value.length) {
      // deselecting all
      _selectedItems.value = [];
      _isSelectionMode.value = false;
    } else {
      // selecting all
      _selectedItems.value =
          List.generate(_favourites.length, (index) => index);
    }
  }

  Future<void> onDeleteActionClicked(int index) async {
    _state.value = StateStaus.loading;
    // deleting record
    await favouriteRepository.remove(_favourites[index].topicID);
    // deleting from loaded
    _favourites.removeAt(index);
    if (_favourites.isEmpty) {
      _state.value = StateStaus.empty;
    } else {
      _state.value = StateStaus.data;
    }
  }

  Future<void> onDeleteButtonClicked(BuildContext context) async {
    final userActions = await _getComfirmation(context);
    if (userActions == null || userActions == OkCancelAction.cancel) {
      return;
    }

    // chanage state to loading
    _state.value = StateStaus.loading;
    if (_favourites.length == _selectedItems.value.length) {
      await favouriteRepository.removeAll();
      _favourites.clear();
      _state.value = StateStaus.empty;
    }
    for (var index in selectedItems.value) {
      await favouriteRepository.remove(_favourites[index].topicID);
      _favourites.removeAt(index);
    }
    // _favourites.clear();
    // _favourites.addAll(await favouriteRepository.getAll());
    _isSelectionMode.value = false;
    _selectedItems.value = [];
    _state.value = StateStaus.data;
  }

  Future<OkCancelAction?> _getComfirmation(BuildContext context) async {
    return await showDialog<OkCancelAction>(
        context: context,
        builder: (context) {
          return const ConfirmDialog(
            message: 'ဖတ်ဆဲ စာအုပ်စာရင်း များကို ဖျက်ရန် သေချာပြီလား',
            okLabel: 'ဖျက်မယ်',
            cancelLabel: 'မဖျက်တော့ဘူး',
          );
        });
  }
}
