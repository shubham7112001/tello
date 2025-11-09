import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/board_blocs/board_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/zoom/zoom_bloc.dart';
import 'package:otper_mobile/app_ui/board/board_view.dart';
import 'package:otper_mobile/app_ui/board/drawer/board_drawer.dart';
import 'package:otper_mobile/configs/router_configs.dart/app_navigator.dart';
import 'package:otper_mobile/data/models/home_board_model.dart';
import 'package:otper_mobile/utils/app_widgets/icons_app.dart';
import 'package:otper_mobile/utils/app_widgets/internet_connectivity.dart';
import 'package:otper_mobile/utils/app_widgets/loader.dart';


class BoardPage extends StatelessWidget {
  final HomeBoardModel homeBoardModel;
  const BoardPage({super.key, required this.homeBoardModel});

  @override
  Widget build(BuildContext context) {
    context.read<ZoomBloc>().reset();

    return InternetConnectivity(
      child: BlocProvider(
        create: (_) => BoardBloc()..add(LoadBoardEvent(board: homeBoardModel)),
        child: WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: Colors.blue,
            appBar: AppBar(
              title: Text(homeBoardModel.name ?? "No Board name"),
              actions: [
                IconButton(onPressed: (){
                  AppNavigator.pop();
                }, icon: MediumIcon(Icons.cancel_outlined))
              ],
            ),
            drawer: BoardDrawer(board: homeBoardModel),
            body: BlocBuilder<BoardBloc, BoardState>(
              builder: (context, state) {
                if (state is BoardLoading) {
                  return const Center(child: Loader());
                } else if (state is BoardLoaded) {
                  return BoardView(
                    board: homeBoardModel
                  );
                } else if (state is BoardError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                // Default fallback (BoardInitial)
                return const SizedBox.shrink();
              },
            ),
            floatingActionButton: BlocBuilder<ZoomBloc, ZoomState>(
              builder: (context, state) {
                debugPrint("Current scale: ${state.scale}");
                final isZoomedOut = state.scale <= 0.7;

                return FloatingActionButton(
                  onPressed: () => context.read<ZoomBloc>().toggleZoom(),
                  child: Icon(isZoomedOut ? Icons.add : Icons.remove),
                );
              },
            ),
          
          ),
        ),
      ),
    );
  }
}
