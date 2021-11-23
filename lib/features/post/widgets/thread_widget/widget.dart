import 'package:flutter/material.dart';
import 'package:mobichan/features/core/core.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:shimmer/shimmer.dart';

class ThreadWidget extends StatelessWidget {
  final Post thread;
  final Board board;
  final bool inThread;

  final EdgeInsetsGeometry padding = const EdgeInsets.all(15.0);
  final SizedBox spacingBetweenIcons = const SizedBox(width: 25.0);
  final SizedBox spacingBetweenIconAndText = const SizedBox(width: 5.0);
  final double iconSize = 20.0;
  final double imageHeight = 250.0;
  final int maxLines = 5;

  const ThreadWidget(
      {required this.thread,
      required this.board,
      required this.inThread,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Wrap(
        children: [
          buildTitle(context),
          ThumbnailWidget(board: board, post: thread, height: 250),
          buildContent(),
          buildFooter(context),
        ],
      ),
    );
  }

  static Widget get shimmer {
    return Builder(
      builder: (context) {
        double deviceWidth = MediaQuery.of(context).size.width;
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade700,
          highlightColor: Colors.grey.shade600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: deviceWidth,
                      height: 15.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      width: RandomUtils.randomDouble(100, deviceWidth),
                      height: 15.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Image
              Container(
                height: 250.0,
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100,
                      height: 15.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(
                            Icons.reply,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          Icon(
                            Icons.image,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          Icon(
                            Icons.more_vert,
                            color: Colors.white,
                            size: 20.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
