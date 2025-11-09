import 'package:flutter/material.dart';
import 'package:otper_mobile/app_ui/board/drawer/board_activities/board_action_section.dart';
import 'package:otper_mobile/app_ui/board/drawer/board_activities/comment_activity_section.dart';
import 'package:otper_mobile/data/models/home_board_model.dart';

class BoardActivity extends StatelessWidget {
  final HomeBoardModel board;
  const BoardActivity({super.key, required this.board});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Board Activities'),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Comments',),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BoardActionSection(board: board,),
            CommentActivitySection(board: board,)
          ],
        ),
      ),
    );
  }
}