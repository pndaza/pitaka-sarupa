import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../models/topic.dart';
import '../../detail_screen/detail_screen.dart';
import '../../../models/recent.dart';
import 'recent_list_tile.dart';
import 'recent_page_view_manager.dart';
import 'package:provider/provider.dart';

import '../../../widgets/multi_value_listenable_builder.dart';

class RecentlistView extends StatelessWidget {
  const RecentlistView({
    Key? key,
    required this.recents,
  }) : super(key: key);

  final List<Recent> recents;

  @override
  Widget build(BuildContext context) {
    final viewManager = context.read<RecentPageViewManager>();
    // final recents = controller.recents;
    return ValueListenableBuilder2<bool, List<int>>(
        first: viewManager.isSelectionMode,
        second: viewManager.selectedItems,
        builder: (_, isSelectionMode, selectedItems, __) {
          return SlidableAutoCloseBehavior(
            child: ListView.builder(
              itemCount: recents.length,
              itemBuilder: (_, index) => RecentListTile(
                recent: recents[index],
                isSelectingMode: isSelectionMode,
                isSelected: selectedItems.contains(index),
                onTap: () => onTap(context, recents[index]),
                onLongPress: () =>
                    viewManager.onRecentItemPressed(context, index),
                onDelete: () => viewManager.onDeleteActionClicked(index),
              ),
            ),
          );
        });
  }

  void onTap(BuildContext context, Recent recent) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            DetailScreen(topic: Topic(recent.topicID, recent.topicName)),
      ),
    );
  }
}
