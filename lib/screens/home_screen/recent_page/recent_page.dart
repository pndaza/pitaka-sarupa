import 'package:flutter/material.dart';
import '../../../clients/database_client.dart';
import '../../../repositories/recent_repository.dart';
import 'package:provider/provider.dart';

import '../../../enums/state_status.dart';
import '../../../widgets/loading_view.dart';
import 'recent_list_view.dart';
import 'recent_page_app_bar.dart';
import 'recent_page_view_manager.dart';

class RecentPage extends StatelessWidget {
  const RecentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<RecentPageViewManager>(
        create: (_) => RecentPageViewManager(
              RecentRepositoryDatabase(DatabaseClient()),
            )..load(),
        dispose: (context, value) => value.dispose(),
        builder: (context, __) {
          final viewManager = context.read<RecentPageViewManager>();
          return Scaffold(
            appBar: const RecentPageAppBar(),
            body: ValueListenableBuilder<StateStaus>(
                valueListenable: viewManager.state,
                builder: (_, state, __) {
                  if (state == StateStaus.loading) {
                    return const LoadingView();
                  }
                  if (state == StateStaus.empty) {
                    return const Center(
                      child: Text('ကြည့်ရှုခဲ့သည်များ မရှိသေးပါ'),
                    );
                  }
                  return RecentlistView(recents: viewManager.recents);
                }),
          );
        });
  }
}
