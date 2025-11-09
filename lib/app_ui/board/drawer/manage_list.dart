import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/board_blocs/board_drawer_blocs/manage_list_cubit.dart';
import 'package:otper_mobile/app_bloc_cubit/utils/name_color_cubit.dart';
import 'package:otper_mobile/data/models/home_board_model.dart';
import 'package:otper_mobile/utils/app_widgets/loader.dart';
import 'package:otper_mobile/utils/app_widgets/name_color_selection.dart';
import 'package:otper_mobile/utils/utilities/name_color_tile.dart';

class ManageListPage extends StatelessWidget {
  final HomeBoardModel board;
  const ManageListPage({super.key, required this.board});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ListCubit()..loadLists(board.slug ?? ""),
      child: Scaffold(
        appBar: AppBar(title: const Text("Manage Lists")),
        body: ListCollection(boardId: board.id ?? '',),
        floatingActionButton: AddListButton(boardId: board.id ?? '',),
      ),
    );
  }
}

class ListCollection extends StatelessWidget {
  final String boardId;
  const ListCollection({super.key, required this.boardId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListCubit, ListState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: Loader());
        }
        if (state.lists.isEmpty) {
          return const Center(child: Text("No lists yet"));
        }

        return ReorderableListView.builder(
          physics: ClampingScrollPhysics(),
          itemCount: state.lists.length,
          onReorder: (oldIndex, newIndex) {
            context.read<ListCubit>().reorderList(oldIndex, newIndex);
          },
          proxyDecorator: (child, index, animation) {
            return AnimatedBuilder(
              animation: animation,
              builder: (context, childWidget) {
                final t = Curves.easeInOut.transform(animation.value);
                final angle = -0.02 * t; 
                return Transform.rotate(
                  angle: angle,
                  child: childWidget,
                );
              },
              child: child,
            );
          },
          itemBuilder: (context, index) {
            final item = state.lists[index];
            return NameColorTile(
              key: ValueKey(item),
              name: item.name ?? "No Name",
              color: item.color ?? Colors.transparent,
              onEdit: () {
                _showListDialog(
                  context,
                  isEdit: true,
                  index: index,
                  item: item,
                  boardId: boardId
                );
              },
              onDelete: () {
                context.read<ListCubit>().deleteList(item.id ?? '');
              },
            );
          },
        );
      },
    );
  }
}


class AddListButton extends StatelessWidget {
  final String boardId;
  const AddListButton({super.key, this.boardId = ''});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        _showListDialog(context, boardId: boardId);
      },
    );
  }
}

void _showListDialog(BuildContext context,
    {bool isEdit = false, int? index, ListItem? item, String? boardId}) {
  showDialog(
    context: context,
    builder: (_) => BlocProvider(
      create: (_) =>
          NameColorCubit(item?.name ?? "", item?.color ?? Colors.green),
      child: NameColorDialog(
        title: isEdit ? "Edit List" : "Add List",
        initialName: item?.name ?? "",
        initialColor: item?.color ?? Colors.green,
        onSave: (name, color) {
          if (isEdit && index != null) {
            context.read<ListCubit>().editList(id: item?.id ?? '',  boardId: boardId ?? '',newName: name, newColor: color);
          } else {
            context.read<ListCubit>().createList(boardId: boardId ?? '',name: name,color: color);
          }
        },
      ),
    ),
  );
}
