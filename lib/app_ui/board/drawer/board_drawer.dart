import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/board_blocs/board_drawer_blocs/board_drawer_cubit.dart';
import 'package:otper_mobile/configs/router_configs.dart/app_navigator.dart';
import 'package:otper_mobile/data/models/home_board_model.dart';
import 'package:otper_mobile/utils/constants/app_text_styles.dart';

class BoardDrawer extends StatelessWidget {
  final HomeBoardModel board;
  const BoardDrawer({super.key, required this.board});

  @override
  Widget build(BuildContext context) {
    final drawerItems = [
      {
        'icon': Icons.label,
        'title': 'Manage Labels',
        'onTap': (BuildContext context) {
          AppNavigator.goToManageLabels(homeBoard: board);
        },
      },
      {
        'icon': Icons.list,
        'title': 'Manage List',
        'onTap': (BuildContext context) {
          AppNavigator.goToManageLists(homeBoard: board);
        },
      },
      {
        'icon': Icons.archive,
        'title': 'Archived Cards',
        'onTap': (BuildContext context) {
          AppNavigator.goToArchivedPage(homeBoard: board);
        },
      },
      {
        'icon': Icons.group,
        'title': 'Manage Member',
        'onTap': (BuildContext context) {
          AppNavigator.goToManageMember(homeBoard: board);
        },
      },
      {
        'icon': Icons.history,
        'title': 'Board Activities',
        'onTap': (BuildContext context) {
          AppNavigator.goToBoardActivity(homeBoard: board);
        },
      },
      {
        'icon': Icons.info_outline,
        'title': 'About This Board',
        'onTap': (BuildContext context) {
          AppNavigator.goToBoardDetails(homeBoard: board);
        },
      },
    ];

    return BlocProvider(
      create: (_) => BoardDrawerCubit(),
      child: Drawer(
        child: BlocBuilder<BoardDrawerCubit, BoardDrawerState>(
          builder: (context, state) {
            return ListView(
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.indigo, Colors.blueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.dashboard, color: Colors.indigo, size: 30),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Board Options',
                        style: AppTextStyles.titleSmallDark,
                      ),
                    ],
                  ),
                ),
                ...List.generate(drawerItems.length, (index) {
                  final item = drawerItems[index];
                  final isSelected = state.selectedIndex == index;
                  return ListTile(
                    leading: Icon(
                      item['icon'] as IconData,
                      // color: isSelected ? Colors.indigo : Colors.grey[600],
                    ),
                    title: Text(
                      item['title'] as String,
                    ),
                    tileColor: isSelected ? Colors.indigo.withOpacity(0.1) : null,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    onTap: () {
                      context.read<BoardDrawerCubit>().selectItem(index);
                      AppNavigator.pop();
                      final onTapCallback = item['onTap'] as Function(BuildContext);
                      onTapCallback(context);
                    },
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}
