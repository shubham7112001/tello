import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/board_blocs/board_drawer_blocs/board_details_cubit.dart';
import 'package:otper_mobile/data/models/home_board_model.dart';

class BoardDetails extends StatelessWidget {
  final HomeBoardModel board;

  const BoardDetails({super.key, required this.board});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BoardDetailsCubit(board),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Board Details"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<BoardDetailsCubit, BoardDetailsState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Board Name", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(state.board.name ?? "-", style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
                  const Text("Board Key", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(state.board.key ?? "-", style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
                  const Text("Board Description", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Expanded(
                    child: TextFormField(
                      initialValue: state.description,
                      maxLines: null,
                      onChanged: (value) {
                        context.read<BoardDetailsCubit>().updateDescription(value);
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter board description...",
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        floatingActionButton: BlocBuilder<BoardDetailsCubit, BoardDetailsState>(
          builder: (context, state) {
            return FloatingActionButton.extended(
              onPressed: () {
                context.read<BoardDetailsCubit>().saveDescription();
                if(state.description.isNotEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Description saved!")),
                  );
                }
              },
              label: const Text("Save"),
              icon: const Icon(Icons.save),
            );
          },
        ),
      ),
    );
  }
}
