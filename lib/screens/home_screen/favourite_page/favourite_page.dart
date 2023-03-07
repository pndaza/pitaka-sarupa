import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../clients/database_client.dart';
import '../../../enums/state_status.dart';
import '../../../repositories/favourite_repository.dart';
import '../../../widgets/loading_view.dart';
import 'favourite_list_view.dart';
import 'favourite_page_app_bar.dart';
import 'favourite_page_view_manager.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<FavouritePageViewManager>(
        create: (_) => FavouritePageViewManager(
              FavouriteRepositoryDatabase(DatabaseClient()),
            )..load(),
        dispose: (context, value) => value.dispose(),
        builder: (context, __) {
          final viewManager = context.read<FavouritePageViewManager>();
          return Scaffold(
            appBar: const FavouritePageAppBar(),
            body: ValueListenableBuilder<StateStaus>(
                valueListenable: viewManager.state,
                builder: (_, state, __) {
                  if (state == StateStaus.loading) {
                    return const LoadingView();
                  }
                  if (state == StateStaus.empty) {
                    return const Center(
                        child: Text('မှတ်သားထားသည်များ မရှိသေးပါ'));
                  }
                  return FavouritelistView(favourites: viewManager.favourites);
                }),
          );
        });
  }
}
