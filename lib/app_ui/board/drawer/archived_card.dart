import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/board_blocs/board_drawer_blocs/archived_card_cubit.dart';
import 'package:otper_mobile/data/models/home_board_model.dart';
import 'package:otper_mobile/utils/helper/helper_function.dart';

class ArchivedCardsPage extends StatelessWidget {
  final HomeBoardModel board;
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  ArchivedCardsPage({super.key, required this.board});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ArchivedCardsCubit()..fetchArchivedCards(board.slug ?? "tcvygbuhnj"),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Archived Cards"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search archived cards...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (query) {
                  context.read<ArchivedCardsCubit>().searchCards(query);
                },
              ),
            ),

            // 🔹 Cards list
            Expanded(
              child: BlocBuilder<ArchivedCardsCubit, ArchivedCardsState>(
                builder: (context, state) {
                  if (state is ArchivedCardsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ArchivedCardsLoaded) {
                    if (state.cards.isEmpty) {
                      return const Center(child: Text("No archived cards found."));
                    }

                    // Attach listener once to load more
                    _scrollController.addListener(() {
                      if (_scrollController.position.pixels >=
                          _scrollController.position.maxScrollExtent - 100) {
                        if (state.hasMore) {
                          context.read<ArchivedCardsCubit>().loadMore(board.slug ?? "");
                        }
                      }
                    });

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(12),
                      itemCount: state.cards.length + (state.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < state.cards.length) {
                          final card = state.cards[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(card.cardNumber),
                              ),
                              title: Text(
                                card.title,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "Archived on ${HelperFunction.formatToReadableDateTime(card.archivedAt)}",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                              trailing: Tooltip(
                                textStyle: Theme.of(context).textTheme.labelLarge,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerLow,
                                ),
                                message: 'Unarchive',
                                child: IconButton(
                                  icon: const Icon(Icons.unarchive_outlined),
                                  onPressed: () {
                                    context.read<ArchivedCardsCubit>().unarchiveCard(card.id);
                                  },
                                ),
                              ),
                            ),
                          );
                        } else {
                          // Loader at bottom while fetching next page
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      },
                    );
                  } else if (state is ArchivedCardsError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
