import 'package:equatable/equatable.dart';

abstract class CardEvent extends Equatable {
  const CardEvent();

  @override
  List<Object?> get props => [];
}

class FetchCardEvent extends CardEvent {
  final String slug;

  const FetchCardEvent(this.slug);

  @override
  List<Object?> get props => [slug];
}
