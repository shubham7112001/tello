import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/board_blocs/board_drawer_blocs/baord_activity_cubit.dart';
import 'package:otper_mobile/app_bloc_cubit/board_blocs/board_drawer_blocs/board_comment_cubit.dart';
import 'package:otper_mobile/app_ui/board/drawer/board_activities/comment_activity_section.dart';
import 'package:otper_mobile/configs/router_configs.dart/app_navigator.dart';
import 'package:otper_mobile/data/models/home_board_model.dart';
import 'package:otper_mobile/utils/app_widgets/loader.dart';
import 'package:otper_mobile/utils/helper/helper_function.dart';

class BoardActionSection extends StatefulWidget {
  final HomeBoardModel board;
  const BoardActionSection({super.key, required this.board});

  @override
  State<BoardActionSection> createState() => _BoardActionSectionState();
}

class _BoardActionSectionState extends State<BoardActionSection> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); 
    return BlocProvider(
      create: (_) => ActionBloc()..add(LoadBoardActions(slug: widget.board.slug ?? '')),
      child: BlocBuilder<ActionBloc, ActionState>(
        builder: (context, state) {
          if (state is ActionLoading) {
            return const Center(child: Loader());
          }
          if (state is ActionLoaded) {
            return NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent &&
                    state.paginator.hasMorePages) {
                  context.read<ActionBloc>().add(
                        LoadBoardActions(
                          slug: widget.board.slug ?? '',
                          page: state.paginator.currentPage + 1,
                          loadMore: true,
                        ),
                      );
                }
                return false;
              },
              child: ListView.builder(
                physics: ClampingScrollPhysics(),
                itemCount: state.paginator.hasMorePages
                    ? state.actions.length + 1 // extra slot for loader
                    : state.actions.length,
                itemBuilder: (context, index) {
                  if (index == state.actions.length &&
                      state.paginator.hasMorePages) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final action = state.actions[index];
                  return ActionItemRenderer(action: action, board: widget.board,);
                },
              ),
            );
          }
          if (state is ActionError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const SizedBox.shrink();
        },
      )

    );
  }
}

class ActionTile extends StatelessWidget {
  final String actionText;
  final DateTime? createdAt;
  final VoidCallback? onTap;

  const ActionTile({
    super.key,
    required this.actionText,
    this.createdAt,
    this.onTap,
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
              actionText.isNotEmpty
                  ? actionText[0].toUpperCase()
                  : "X",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          title: Text(
            actionText,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          subtitle: createdAt != null
              ? Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    HelperFunction.formatToReadableDateTime(createdAt),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                )
              : null,
          trailing: onTap != null
              ? InkWell(
                  onTap: onTap,
                  child: const Icon(Icons.chevron_right, size: 28),
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        ),
      ),
    );
  }
}

class ActionItemRenderer extends StatelessWidget {
  final BoardAction action;
  final HomeBoardModel board;

  const ActionItemRenderer({
    super.key,
    required this.action,
    required this.board,
  });

  String _buildActionText() {
    final creator = action.creator?.name ?? '';
    final meta = action.metadata ?? {};

    switch (action.action) {
      case "update-card-status":
        return '$creator moved card ${meta["card-title"]} from ${meta["from-list-name"]} to ${meta["to-list-name"]}';

      case "update-card-due":
        return '$creator updated due date of card ${meta["card-title"]} '
               'to ${meta["due-month-date"]} at ${meta["due-time"]}';

      case "set-card-due":
        return '$creator set due date of card ${meta["card-title"]} '
               'to ${meta["due-month-date"]} at ${meta["due-time"]}';

      case "clear-card-due":
        return '$creator cleared due date of card ${meta["card-title"]}';

      case "marked-card-complete":
        return '$creator marked card ${meta["card-title"]} as complete';

      case "marked-card-incomplete":
        return '$creator marked card ${meta["card-title"]} as incomplete';

      case "archived-card":
        return '$creator archived card ${meta["card-title"]}';

      case "unArchived-card":
        return '$creator unarchived card ${meta["card-title"]}';

      default:
        return action.action;
    }
  }

  @override
  Widget build(BuildContext context) {

    if (action.action == "commented") {
      return CommentTile(
        comment: BoardCommentModel(
          id: "id",
          comment: action.owner?.comment ?? "no comment",
          cardSlug: action.card?.slug ?? "",
          cardTitle: action.card?.title ?? "No title",
          files: [],
          createdAt: action.createdAt,
        ),
        board: board,
      );
    }

    return ActionTile(
      actionText: _buildActionText(),
      createdAt: action.createdAt,
      onTap: () => AppNavigator.goToCard(
        slug: action.card?.slug ?? '',
        title: action.card?.title ?? '',
        boardId: board.id ?? '',
      ),
    );
  }
}


