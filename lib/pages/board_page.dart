import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/api/api.dart';
import 'package:mobichan/classes/arguments/board_page_arguments.dart';
import 'package:mobichan/classes/arguments/thread_page_arguments.dart';
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/enums/enums.dart';
import 'package:mobichan/pages/thread_page.dart';
import 'package:mobichan/widgets/drawer_widget.dart';
import 'package:mobichan/widgets/form_widget.dart';
import 'package:mobichan/widgets/post_action_button_widget.dart';
import 'package:mobichan/widgets/post_widget.dart';

class BoardPage extends StatefulWidget {
  static const routeName = '/board';
  final BoardPageArguments args;
  const BoardPage({Key? key, required this.args}) : super(key: key);

  @override
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  late Future<List<Post>> _futureOPs;
  bool _postFormIsOpened = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _onPressPostActionButton() {
    setState(() {
      _postFormIsOpened = !_postFormIsOpened;
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _futureOPs = Api.fetchOPs(board: widget.args.board);
    });
  }

  void _onCloseForm() {
    setState(() {
      _postFormIsOpened = false;
    });
  }

  void _onFormPost(Response<String> response) async {
    _onCloseForm();
    await _refresh();
  }

  Widget Function(BuildContext, int) _listViewItemBuilder(
      AsyncSnapshot<List<Post>> snapshot) {
    return (BuildContext context, int index) {
      Post op = snapshot.data![index];
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: PostWidget(
          post: op,
          board: widget.args.board,
          height: 150,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ThreadPage(
                args: ThreadPageArguments(
                  board: widget.args.board,
                  thread: op.no,
                  title: op.sub ?? op.com ?? '',
                ),
              ),
            ),
          ),
        ),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      floatingActionButton: PostActionButton(
        onPressed: _onPressPostActionButton,
      ),
      appBar: AppBar(
        title: Text('/${widget.args.board}/ - ${widget.args.title}'),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refresh,
            child: FutureBuilder<List<Post>>(
              future: _futureOPs,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: _listViewItemBuilder(snapshot),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          FormWidget(
            postType: PostType.thread,
            board: widget.args.board,
            isOpened: _postFormIsOpened,
            onPost: _onFormPost,
            onClose: _onCloseForm,
          ),
        ],
      ),
    );
  }
}
