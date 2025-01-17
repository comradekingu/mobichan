import 'package:mobichan_data/mobichan_data.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class PostModel extends Post {
  const PostModel({
    required int no,
    required String now,
    required int time,
    required int resto,
    String? name,
    int? sticky,
    int? closed,
    String? sub,
    String? com,
    String? filename,
    String? ext,
    int? w,
    int? h,
    int? tnW,
    int? tnH,
    int? tim,
    String? md5,
    int? fsize,
    String? capcode,
    String? semanticUrl,
    int? replies,
    int? images,
    int? uniqueIps,
    String? trip,
    int? lastModified,
    String? country,
    String? boardId,
    String? boardTitle,
    int? boardWs,
  }) : super(
          no: no,
          now: now,
          name: name,
          time: time,
          resto: resto,
          sticky: sticky,
          closed: closed,
          sub: sub,
          com: com,
          filename: filename,
          ext: ext,
          w: w,
          h: h,
          tnW: tnW,
          tnH: tnH,
          tim: tim,
          md5: md5,
          fsize: fsize,
          capcode: capcode,
          semanticUrl: semanticUrl,
          replies: replies,
          images: images,
          uniqueIps: uniqueIps,
          trip: trip,
          lastModified: lastModified,
          country: country,
          boardId: boardId,
          boardTitle: boardTitle,
          boardWs: boardWs,
        );

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      no: json['no'],
      sticky: json['sticky'],
      closed: json['closed'],
      now: json['now'],
      name: json['name'],
      sub: json['sub'],
      com: json['com'],
      filename: json['filename'],
      ext: json['ext'],
      w: json['w'],
      h: json['h'],
      tnW: json['tn_w'],
      tnH: json['tn_h'],
      tim: json['tim'],
      time: json['time'],
      md5: json['md5'],
      fsize: json['fsize'],
      resto: json['resto'],
      capcode: json['capcode'],
      semanticUrl: json['semantic_url'],
      replies: json['replies'],
      images: json['images'],
      uniqueIps: json['unique_ips'],
      trip: json['trip'],
      lastModified: json['last_modified'],
      country: json['country'],
      boardId: json['board_id'],
      boardTitle: json['board_title'],
      boardWs: json['board_ws'],
    );
  }

  factory PostModel.fromEntity(Post post) {
    return PostModel(
      no: post.no,
      now: post.now,
      name: post.name,
      time: post.time,
      resto: post.resto,
      sticky: post.sticky,
      closed: post.closed,
      sub: post.sub,
      com: post.com,
      filename: post.filename,
      ext: post.ext,
      w: post.w,
      h: post.h,
      tnW: post.tnW,
      tnH: post.tnH,
      tim: post.tim,
      md5: post.md5,
      fsize: post.fsize,
      capcode: post.capcode,
      semanticUrl: post.semanticUrl,
      replies: post.replies,
      images: post.images,
      uniqueIps: post.uniqueIps,
      trip: post.trip,
      lastModified: post.lastModified,
      country: post.country,
      boardId: post.boardId,
      boardTitle: post.boardTitle,
      boardWs: post.boardWs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'no': no,
      'now': now,
      'name': name,
      'time': time,
      'resto': resto,
      'sticky': sticky,
      'closed': closed,
      'sub': sub,
      'com': com,
      'filename': filename,
      'ext': ext,
      'w': w,
      'h': h,
      'tn_w': tnW,
      'tn_h': tnH,
      'tim': tim,
      'md5': md5,
      'fsize': fsize,
      'capcode': capcode,
      'semantic_url': semanticUrl,
      'replies': replies,
      'images': images,
      'unique_ips': uniqueIps,
      'trip': trip,
      'last_modified': lastModified,
      'country': country,
      'board_id': boardId,
      'board_title': boardTitle,
      'board_ws': boardWs,
    };
  }
}

extension PostModelListExtension on List<PostModel> {
  List<PostModel> sortedBySort(SortModel sort) {
    switch (sort.order) {
      case Order.byBump:
        return this
          ..sort((a, b) {
            return a.lastModified!.compareTo(b.lastModified!);
          });
      case Order.byReplies:
        return this
          ..sort((a, b) {
            return b.replies!.compareTo(a.replies!);
          });
      case Order.byImages:
        return this
          ..sort((a, b) {
            return b.images!.compareTo(a.images!);
          });
      case Order.byNew:
        return this
          ..sort((a, b) {
            return b.time.compareTo(a.time);
          });
      case Order.byOld:
        return this
          ..sort((a, b) {
            return a.time.compareTo(b.time);
          });
    }
  }
}
