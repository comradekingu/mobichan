import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mobichan/core/extensions/string_extension.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class ContentWidget extends StatelessWidget {
  final Board board;
  final Post reply;
  final List<Post> threadReplies;
  final bool inDialog;
  final Post? replyingTo;

  const ContentWidget({
    required this.board,
    required this.reply,
    required this.threadReplies,
    this.inDialog = false,
    this.replyingTo,
    Key? key,
  }) : super(key: key);

  String highlightReplyingTo(String? str, Post? replyingTo) {
    if (str == null) return '';
    if (replyingTo == null) return str;

    final exp = RegExp(r'<a href="#p\d+" class="quotelink">');

    final newStr = str.replaceAllMapped(exp, (match) {
      String matchStr = match.group(0) ?? '';
      if (!matchStr.contains('${replyingTo.no}')) {
        return matchStr.replaceAll(
            'class="quotelink"', 'class="quotelink-lowlight"');
      }
      return matchStr;
    });

    return newStr;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return SelectableHtml(
          selectionControls: PostTextSelectionControls(
            customButton: (start, end) => handleQuote(context, start, end),
          ),
          data: insertATags(highlightReplyingTo(reply.com, replyingTo)),
          onAnchorTap: (str, renderContext, attributes, element) {
            if (attributes['class'] == 'quotelink' ||
                attributes['class'] == 'quotelink-lowlight') {
              handleTapQuotelink(context, str!);
            } else {
              handleTapUrl(str!);
            }
          },
          style: {
            "body": Style(margin: const EdgeInsets.all(0)),
            "a": Style(
              color: Colors.lightBlueAccent,
            ),
            ".quote": Style(
              color: Colors.green.shade300,
            ),
            ".quotelink": Style(
              color: Theme.of(context).colorScheme.secondary,
            ),
            ".quotelink-lowlight": Style(
              color: Theme.of(context).colorScheme.secondaryVariant,
            ),
          },
        );
      },
    );
  }

  String insertATags(String? str) {
    if (str == null) {
      return '';
    }
    final regExp = RegExp(
      r'(?<!(href="))http[s?]:\/\/[^\s<]+(?!<\/a>)',
    );
    return str.removeWbr.replaceAllMapped(regExp, (match) {
      return '<a href="${match.group(0)}">${match.group(0)}</a>';
    });
  }
}
