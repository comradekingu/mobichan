import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/features/setting/setting.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan/core/core.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ThreadPageArguments {
  final Board board;
  final Post thread;

  ThreadPageArguments({required this.board, required this.thread});
}

class ComputeArgs {
  final Board board;
  final Post thread;
  final List<Post> replies;

  ComputeArgs({
    required this.board,
    required this.thread,
    required this.replies,
  });
}

class ThreadPage extends StatelessWidget {
  static const routeName = '/thread';
  static const maxRecursion = 7;

  final ItemScrollController itemScrollController = ItemScrollController();

  ThreadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ThreadPageArguments;

    return MultiBlocProvider(
      providers: [
        BlocProvider<RepliesCubit>(
          create: (context) =>
              sl<RepliesCubit>()..getReplies(args.board, args.thread),
        ),
        BlocProvider<PostFormCubit>(
          create: (context) => PostFormCubit(),
        ),
        BlocProvider<SettingsCubit>(
          create: (context) => sl<SettingsCubit>()..getSettings(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return BlocBuilder<RepliesCubit, RepliesState>(
            builder: (context, repliesState) {
              return Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () => handleFormButtonPressed(context),
                  child: const Icon(Icons.edit),
                ),
                appBar: AppBar(
                  title: Text(args
                      .thread.displayTitle.replaceBrWithSpace.removeHtmlTags),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.image),
                      onPressed: () => repliesState is RepliesLoaded
                          ? handleGalleryButton(
                              context,
                              args.board,
                              repliesState.replies
                                  .where((element) => element.filename != null)
                                  .toList(),
                            )
                          : null,
                    ),
                    buildPopupMenuButton(
                      context: context,
                      board: args.board,
                      thread: args.thread,
                      replies: repliesState is RepliesLoaded
                          ? repliesState.replies
                          : [],
                    ),
                  ],
                ),
                body: RefreshIndicator(
                  onRefresh: () async =>
                      handleRefresh(context, args.board, args.thread),
                  child: SettingProvider(
                    settingTitle: 'threaded_replies',
                    builder: (threadedReplies) {
                      if (repliesState is RepliesLoaded) {
                        return Stack(
                          children: [
                            threadedReplies.value
                                ? buildThreadedReplies(
                                    board: args.board,
                                    thread: args.thread,
                                    replies: repliesState.replies,
                                  )
                                : buildLinearReplies(
                                    board: args.board,
                                    thread: args.thread,
                                    replies: repliesState.replies,
                                  ),
                            FormWidget(
                              board: args.board,
                              thread: args.thread,
                            ),
                          ],
                        );
                      } else {
                        return buildLoading(args.board, args.thread);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
