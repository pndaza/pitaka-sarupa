import 'package:flutter/material.dart';

import '../../../dialogs/confirm_dialog.dart';
import '../../../enums/state_status.dart';
import '../../../models/recent.dart';
import '../../../repositories/recent_repository.dart';

class RecentPageViewManager {
  final RecentRepository recentRepository;

  final _state = ValueNotifier(StateStaus.loading);

  RecentPageViewManager(this.recentRepository);
  ValueNotifier<StateStaus> get state => _state;

  final _isSelectionMode = ValueNotifier(false);
  ValueNotifier<bool> get isSelectionMode => _isSelectionMode;

  final _selectedItems = ValueNotifier<List<int>>([]);
  ValueNotifier<List<int>> get selectedItems => _selectedItems;

  final List<Recent> _recents = [];
  List<Recent> get recents => _recents;

  void load() async {
    recents.addAll(await _fetchRecents());
    if (recents.isEmpty) {
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

  Future<List<Recent>> _fetchRecents() async {
    return await recentRepository.getAll();
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
    if (_recents.length == _selectedItems.value.length) {
      // deselecting all
      _selectedItems.value = [];
      _isSelectionMode.value = false;
    } else {
      // selecting all
      _selectedItems.value = List.generate(_recents.length, (index) => index);
    }
  }

  Future<void> onDeleteActionClicked(int index) async {
    _state.value = StateStaus.loading;
    // deleting record
    await recentRepository.remove(_recents[index].topicID);
    // deleting from loaded
    _recents.removeAt(index);
    if (_recents.isEmpty) {
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
    if (_recents.length == _selectedItems.value.length) {
      await recentRepository.removeAll();
      _recents.clear();
      _state.value = StateStaus.empty;
    }
    for (var index in selectedItems.value) {
      await recentRepository.remove(_recents[index].topicID);
      _recents.removeAt(index);
    }
    // _recents.clear();
    // _recents.addAll(await recentRepository.getAll());
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
