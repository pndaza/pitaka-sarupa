import 'package:flutter/material.dart';
import 'favourite_page_view_manager.dart';
import 'package:provider/provider.dart';

import '../../../utils/mm_number.dart';
import '../../../widgets/multi_value_listenable_builder.dart';

class FavouritePageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const FavouritePageAppBar({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final viewManager = context.read<FavouritePageViewManager>();
    return ValueListenableBuilder2<bool, List<int>>(
        first: viewManager.isSelectionMode,
        second: viewManager.selectedItems,
        builder: (_, isSelectionMode, selectedItems, __) {
          if (!isSelectionMode || viewManager.selectedItems.value.isEmpty) {
            return AppBar(
              title: const Text('မှတ်သားထားသည်များ', textScaleFactor: 1.0),
              centerTitle: true,
            );
          } else {
            return AppBar(
              leading: IconButton(
                  onPressed: viewManager.onCancelButtonClicked,
                  icon: const Icon(Icons.cancel_outlined)),
              title: Text('${MmNumber.get(selectedItems.length)} ခု မှတ်ထား'),
              actions: <Widget>[
                // select all button
                IconButton(
                    onPressed: viewManager.onSelectAllButtonClicked,
                    icon: Icon(
                      Icons.select_all_outlined,
                      color:
                          viewManager.favourites.length == selectedItems.length
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onPrimary,
                    )),
                // delete button
                IconButton(
                    onPressed: selectedItems.isEmpty
                        ? null
                        : () => viewManager.onDeleteButtonClicked(context),
                    icon: const Icon(Icons.delete_outline_outlined)),
              ],
            );
          }
        });
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
