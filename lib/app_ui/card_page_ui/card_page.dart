import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/card_page_blocs/card_blocs/card_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/card_page_blocs/card_blocs/card_event.dart';
import 'package:otper_mobile/app_bloc_cubit/card_page_blocs/card_blocs/card_state.dart';
import 'package:otper_mobile/app_ui/card_page_ui/card_view.dart';

class CardPage extends StatelessWidget {
  final String slug;
  final String title;
  final String boardId;

  const CardPage({super.key, required this.slug, required this.title, required this.boardId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CardBloc()..add(FetchCardEvent(slug)),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(title: Text(title),),
        body: SafeArea(
          child: BlocBuilder<CardBloc, CardState>(
            builder: (context, state) {
              if (state is CardInitial || state is CardLoading) {
                // Show loader when initial or loading
                return const Center(child: CircularProgressIndicator());
              } else if (state is CardLoaded) {
                // Pass the card data to CardView
                return CardView(card: state.card, boardId: boardId);
              } else if (state is CardError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}