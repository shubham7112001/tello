import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/board_blocs/board_drawer_blocs/board_comment_cubit.dart';
import 'package:otper_mobile/configs/router_configs.dart/app_navigator.dart';
import 'package:otper_mobile/data/models/home_board_model.dart';
import 'package:otper_mobile/utils/app_widgets/loader.dart';
import 'package:otper_mobile/utils/helper/helper_function.dart';

class CommentActivitySection extends StatelessWidget {
  final HomeBoardModel board;
  const CommentActivitySection({super.key, required this.board});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BoardCommentCubit()..fetchComments(slug: board.slug),
      child: _CommentActivityView(board: board),
    );
  }
}

class _CommentActivityView extends StatefulWidget {
  final HomeBoardModel board;
  const _CommentActivityView({required this.board});

  @override
  State<_CommentActivityView> createState() => _CommentActivityViewState();
}

class _CommentActivityViewState extends State<_CommentActivityView> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final cubit = context.read<BoardCommentCubit>();
    final state = cubit.state;
    if (state is BoardCommentLoaded &&
        !state.isLoadingMore &&
        state.paginatorInfo.hasMorePages &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
      cubit.fetchComments(page: state.paginatorInfo.currentPage + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<BoardCommentCubit, BoardCommentState>(
      builder: (context, state) {
        if (state is BoardCommentLoading) {
          return const Center(child: Loader());
        } else if (state is BoardCommentLoaded) {
          return ListView.builder(
            physics: ClampingScrollPhysics(),
            controller: _scrollController,
            itemCount: state.comments.length + (state.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.comments.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final comment = state.comments[index];
              return CommentTile(comment: comment, board: widget.board);
            },
          );
        } else if (state is BoardCommentError) {
          return Center(child: Text("Error: ${state.message}"));
        }
        return const SizedBox();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class CommentTile extends StatelessWidget {
  final BoardCommentModel comment;
  final HomeBoardModel board; // Assuming you have a BoardModel

  final VoidCallback? onTap;
  final String? createdPrefix;

  const CommentTile({
    super.key,
    required this.comment,
    required this.board,
    this.onTap,
    this.createdPrefix = ""
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey, width: 0.2),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              comment.comment.isNotEmpty
                  ? comment.comment[0].toUpperCase()
                  : board.name != null && board.name!.isNotEmpty
                      ? board.name![0].toUpperCase()
                      : "X",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          title: Text(
            "${board.name ?? "Board"} on ${comment.cardTitle}",
            style: Theme.of(context).textTheme.labelLarge,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                  ),
                ),
                child: Text(
                  comment.comment,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.labelSmall,
                  softWrap: true,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "$createdPrefix${HelperFunction.formatToReadableDateTime(comment.createdAt)}",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ],
          ),
          trailing: InkWell(
            onTap: () => AppNavigator.goToCard(
              slug: comment.cardSlug,
              title: comment.cardTitle,
              boardId: board.id ?? '',
            ),
            child: const Icon(Icons.chevron_right, size: 28),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        ),
      ),
    );
  }
}
