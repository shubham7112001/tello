import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/data/models/card_model.dart';

class MembersState {
  final List<CardMember> members;

  MembersState({this.members = const []});

  MembersState copyWith({List<CardMember>? members}) {
    return MembersState(members: members ?? this.members);
  }
}

class MembersCubit extends Cubit<MembersState> {
  MembersCubit({List<CardMember>? initialMembers}) 
      : super(MembersState(members: initialMembers ?? []));

  void addMember(CardMember member) {
    emit(state.copyWith(members: [...state.members, member]));
  }

  void removeMember(CardMember member) {
    emit(state.copyWith(
        members: state.members.where((m) => m != member).toList()));
  }
}

