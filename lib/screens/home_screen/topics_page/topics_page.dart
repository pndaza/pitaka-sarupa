import 'package:flutter/material.dart';
import 'package:pitaka_sarupa/utils/platform_util.dart';
import '../../../repositories/recent_repository.dart';
import 'package:provider/provider.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../../../clients/database_client.dart';
import '../../../enums/state_status.dart';
import '../../../models/topic.dart';
import '../../../repositories/topic_repository.dart';
import '../../about_screen/about_screen.dart';
import '../../detail_screen/detail_screen.dart';
import 'search_field.dart';
import 'topic_list_tile.dart';
import 'topics_page_view_manager.dart';

class TopicsPage extends StatelessWidget {
  const TopicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('သရုပ်စုံအဘိဓာန်', textScaleFactor: 1.0),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutScreen()),
                );
              },
              icon: Icon(
                Icons.info,
                color: Theme.of(context).colorScheme.secondary,
              ))
        ],
      ),
      body: Provider(
        create: (_) => TopicsPageViewManager(
          topicRepository: TopicRepositoryDatabase(DatabaseClient()),
          recentRepository: RecentRepositoryDatabase(DatabaseClient()),
        )..load(),
        child: const _TopicPageView(),
      ),
    );
  }
}

class _TopicPageView extends StatelessWidget {
  const _TopicPageView();

  @override
  Widget build(BuildContext context) {
    final viewManager = context.read<TopicsPageViewManager>();
    return Column(
      children: [
        Expanded(
          child: ValueListenableBuilder<StateStaus>(
              valueListenable: viewManager.stateStatus,
              builder: (_, stateStatus, __) {
                if (stateStatus == StateStaus.loading) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }
                if (stateStatus == StateStaus.empty) {
                  return const Center(child: Text('မတွေ့ပါ။'));
                }

                return ValueListenableBuilder(
                    valueListenable: viewManager.filteredTopics,
                    builder: (_, topics, __) {
                      return ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context)
                            .copyWith(scrollbars: false),
                        child: Scrollbar(
                          thickness: 8.0,
                          radius: const Radius.circular(4.0),
                          child: CustomScrollView(
                            primary: true,
                            slivers: [
                              SuperSliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      childCount: topics.length,
                                      (context, index) => TopicListTile(
                                            enumText: topics[index].name,
                                            highlightText:
                                                viewManager.filteredText,
                                            onTap: () => _onClickedTopic(
                                              context,
                                              topics[index],
                                            ),
                                          )))
                            ],
                          ),
                        ),
                      );
                    });
              }),
        ),
        SearchField(
          onChanged: context.read<TopicsPageViewManager>().onFilterChanged,
          hint: 'ရှာလိုသောသရုပ် ရိုက်ရှာရန်',
        )
      ],
    );
  }

  void _onClickedTopic(BuildContext context, Topic topic) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DetailScreen(
              topic: topic,
            )));

    context.read<TopicsPageViewManager>().addToRecent(topic.id);
  }
}
