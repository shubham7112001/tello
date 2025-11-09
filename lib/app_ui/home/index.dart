import 'package:flutter/material.dart';
import 'package:otper_mobile/data/models/home_team_model.dart';
import 'package:otper_mobile/utils/app_widgets/horizontal_scroller.dart';
import 'package:otper_mobile/utils/constants/app_text_styles.dart';

class HomeView extends StatelessWidget {
  final List<HomeTeamModel> teams;
  const HomeView({super.key, required this.teams});

  @override
  Widget build(BuildContext context) {
    final teamStyle = Theme.of(context).textTheme.bodyLarge;

    if (teams.isEmpty) {
      return const Center(child: Text("No Teams Found"));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: teams.length,
      itemBuilder: (context, index) {
        final team = teams[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                team.name ?? "NA",
                style: teamStyle,
              ),
            ),
            const SizedBox(height: 8),
            ImageScroller(boards: team.boards ?? []),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}

