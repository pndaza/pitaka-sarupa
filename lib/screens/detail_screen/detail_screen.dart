// import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:like_button/like_button.dart';
import 'package:pitaka_sarupa/repositories/favourite_repository.dart';
import 'package:provider/provider.dart';

import '../../clients/database_client.dart';
import '../../enums/state_status.dart';
import '../../models/detail.dart';
import '../../models/topic.dart';
import '../../repositories/topic_repository.dart';
import 'detial_screen_view_manager.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.topic});
  final Topic topic;

  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (context) => DetailScreenViewManager(
            topicRepository: TopicRepositoryDatabase(DatabaseClient()),
            favouriteRepisotry: FavouriteRepositoryDatabase(DatabaseClient()),
            topic: topic)
          ..load(),
        builder: (context, _) {
          final viewManager = context.read<DetailScreenViewManager>();
          return Scaffold(
            appBar: AppBar(
              elevation: 0.3,
              title: const Text('သရုပ်အဖွင့်', textScaleFactor: 1.0),
              actions: [
                IconButton(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(
                          text: _formatText(
                        topicName: topic.name,
                        detail: viewManager.detail.detail,
                        reference: viewManager.detail.reference,
                      )));
                      if (context.mounted) {
                        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                          const SnackBar(
                            elevation: 6.0,
                            duration: Duration(milliseconds: 1000),
                            behavior: SnackBarBehavior.floating,
                            content: Text('ကော်ပီကူးယူပြီးပါပြီ'),
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      Icons.copy,
                      color: Theme.of(context).colorScheme.secondary,
                    )),
                const SizedBox(width: 8),
                ValueListenableBuilder(
                  valueListenable: viewManager.isFavourtie,
                  builder: (context, isFavourite, child) {
                    if (isFavourite == null) {
                      // loading favourite
                      return const SizedBox.shrink();
                    }
                    return Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: LikeButton(
                          isLiked: isFavourite,
                          likeBuilder: (bool isLiked) {
                            return Icon(
                              Icons.favorite,
                              color: isLiked
                                  ? Theme.of(context).colorScheme.secondary
                                  : Colors.grey,
                              size: 32,
                            );
                          },
                          onTap: (isLiked) async {
                            viewManager.onFavouritButtonCliked(isLiked);
                            return !isLiked;
                          },
                        ));
                  },
                )
              ],
            ),
            body: ValueListenableBuilder(
                valueListenable:
                    context.read<DetailScreenViewManager>().stateStatus,
                builder: (context, stateStatus, _) {
                  if (stateStatus == StateStaus.loading) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  }
                  return _DetailScreenView(
                    topic: topic,
                    detail: context.read<DetailScreenViewManager>().detail,
                  );
                }),
          );
        });
  }

  String _formatText(
      {required String topicName,
      required String detail,
      required String reference}) {
    return '''$topicName\n
                              ${detail.replaceAll('\\n', '\n')}\n
                              $reference'''
        .splitMapJoin(RegExp(r'^', multiLine: true),
            onMatch: (_) => '\n', onNonMatch: (n) => n.trim());
  }
}

class _DetailScreenView extends StatelessWidget {
  final Topic topic;
  final Detail detail;
  const _DetailScreenView({required this.topic, required this.detail});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SelectionArea(
        child: ListView(
          children: [
            Text(
              topic.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(
              height: 16,
              child: Text('\n', selectionColor: Colors.transparent),
            ),
            _OrderedList(
              _formatDetail(detail.detail),
            ),
            const SizedBox(height: 16),
            if (detail.reference != '+')
              FractionallySizedBox(
                  alignment: Alignment.centerRight,
                  widthFactor: 0.8,
                  child: Text(
                    detail.reference,
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.blueGrey),
                  )),
          ],
        ),
      ),
    );
  }

  List<String> _formatDetail(String detail) {
    // var formatted = detail.replaceAll('\\n', '\n\n');
    // formatted = formatted.replaceAllMapped(
    //     RegExp('[၀-၉]+။'), (match) => '- ${match.group(0)}');

    return detail.split('\\n');
  }
}

class _OrderedList extends StatelessWidget {
  const _OrderedList(this.texts);
  final List<String> texts;

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[];
    for (var text in texts) {
      // Add list item
      widgetList.add(_OrderedListItem(text));
      // Add space between items
      widgetList.add(const SizedBox(
        height: 8.0,
        child: Text('\n', selectionColor: Colors.transparent),
      ));
    }

    return Column(mainAxisSize: MainAxisSize.min, children: widgetList);
  }
}

class _OrderedListItem extends StatelessWidget {
  const _OrderedListItem(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final texts = _parseListItem(text);
    if (texts.length == 1) {
      return Text(text);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
            width: 56.0,
            child: Text(
              texts[0],
              textScaleFactor: MediaQuery.of(context).textScaleFactor + 0.1,
            )),
        Expanded(
            child: Text(
          texts[1],
          style: const TextStyle(height: 1.8),
          textScaleFactor: MediaQuery.of(context).textScaleFactor + 0.1,
        )),
      ],
    );
  }

  List<String> _parseListItem(String text) {
    return text.split(RegExp('(?<=[၀-၉]+။ )'));
  }
}
