import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/board_blocs/board_drawer_blocs/manage_labels_cubit.dart';
import 'package:otper_mobile/data/models/home_board_model.dart';
import 'package:otper_mobile/utils/app_widgets/loader.dart';
import 'package:otper_mobile/utils/app_widgets/name_color_selection.dart';
import 'package:otper_mobile/utils/utilities/name_color_tile.dart';

class ManageLabelPage extends StatelessWidget {
  final HomeBoardModel board;
  const ManageLabelPage({super.key, required this.board});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = LabelCubit();
        cubit.loadLabels(board.slug ?? "");
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Manage Labels")),
        body: LabelList(board: board),
        floatingActionButton: AddLabelButton(boardId: board.id ?? '',),
      ),
    );
  }
}

class LabelList extends StatelessWidget {
  final HomeBoardModel board;
  const LabelList({super.key, required this.board});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LabelCubit, LabelState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: Loader(),
          );
        }
        if (state.labels.isEmpty) {
          return const Center(child: Text("No labels yet"));
        }
        return ListView.builder(
          itemCount: state.labels.length,
          itemBuilder: (context, index) {
            final label = state.labels[index];
            return NameColorTile(
              key: ValueKey(label),
              name: label.name,
              color: label.color,
              onEdit: () {
                _showLabelDialog(context, isEdit: true, index: index, label: label, boardId: board.id);
              },
              onDelete: () {
                context.read<LabelCubit>().deleteLabel(label.id ?? '');
              },
            );
          },
        );
      },
    );
  }
}

class AddLabelButton extends StatelessWidget {
  final String boardId;
  const AddLabelButton({super.key, required this.boardId});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        _showLabelDialog(context, boardId: boardId);
      },
    );
  }
}

void _showLabelDialog(BuildContext context, {bool isEdit = false, int? index, Label? label, String? boardId}) {
  showDialog(
    context: context,
    builder: (_) => NameColorDialog(
      title: isEdit ? "Edit Label" : "Add Label",
      initialName: label?.name ?? "",
      initialColor: label?.color ?? Colors.blue,
      onSave: (name, color) {
        if (isEdit && index != null) {
          context.read<LabelCubit>().editLabel(
            id: label?.id ?? '',
            boardId: boardId ?? '',
            name: name,
            color: color,
          );
        } else {
          context.read<LabelCubit>().createLabel(boardId: boardId ?? '', name: name, color: color);
        }
      },
    ),
  );
}
