import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../../models/favourite.dart';
import '../../../widgets/multi_value_listenable_builder.dart';
import 'favourite_list_tile.dart';
import 'favourite_page_view_manager.dart';

class FavouritelistView extends StatelessWidget {
  const FavouritelistView({
    Key? key,
    required this.favourites,
  }) : super(key: key);

  final List<Favourite> favourites;

  @override
  Widget build(BuildContext context) {
    final viewManager = context.read<FavouritePageViewManager>();
    // final recents = controller.recents;
    return ValueListenableBuilder2<bool, List<int>>(
        first: viewManager.isSelectionMode,
        second: viewManager.selectedItems,
        builder: (_, isSelectionMode, selectedItems, __) {
          return SlidableAutoCloseBehavior(
            child: ListView.builder(
              itemCount: favourites.length,
              itemBuilder: (_, index) => FavouriteListTile(
                favourite: favourites[index],
                isSelectingMode: isSelectionMode,
                isSelected: selectedItems.contains(index),
                onTap: () => viewManager.onFavouriteItemClicked(context, index),
                onLongPress: () =>
                    viewManager.onRecentItemPressed(context, index),
                onDelete: () => viewManager.onDeleteActionClicked(index),
              ),
            ),
          );
        });
  }
}
