import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_graphql/graph_service.dart';

class ManageMember extends Equatable {
  final String id;
  final String? name;
  final int? activeCard;
  final String? email;
  final String? username;
  final String? emailVerifiedAt;
  final String? currentTeamId;
  final String? updatedAt;
  final String? role;

  const ManageMember({
    required this.id,
    this.name,
    this.activeCard,
    this.email,
    this.username,
    this.emailVerifiedAt,
    this.currentTeamId,
    this.updatedAt,
    this.role,
  });

  // Factory constructor to create a ManageMember from JSON
  factory ManageMember.fromJson(Map<String, dynamic> json) {
    return ManageMember(
      id: json['id'] as String,
      name: json['name'] as String?,
      activeCard: json['active_card'] != null
          ? int.tryParse(json['active_card'].toString())
          : null,
      email: json['email'] as String?,
      username: json['username'] as String?,
      emailVerifiedAt: json['email_verified_at'] as String?,
      currentTeamId: json['current_team_id'] as String?,
      updatedAt: json['updated_at'] as String?,
      role: json['pivot']?['role'] ?? "Editor",
    );
  }

  ManageMember copyWith({
    String? id,
    String? name,
    int? activeCard,
    String? email,
    String? username,
    String? emailVerifiedAt,
    String? currentTeamId,
    String? updatedAt,
    String? role,
  }) {
    return ManageMember(
      id: id ?? this.id,
      name: name ?? this.name,
      activeCard: activeCard ?? this.activeCard,
      email: email ?? this.email,
      username: username ?? this.username,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      currentTeamId: currentTeamId ?? this.currentTeamId,
      updatedAt: updatedAt ?? this.updatedAt,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        activeCard,
        email,
        username,
        emailVerifiedAt,
        currentTeamId,
        updatedAt,
        role,
      ];

  @override
  String toString() {
    return 'ManageMember(id: $id, name: $name, email: $email, username: $username, activeCard: $activeCard, role: $role)';
  }
}

class ManageMembersState extends Equatable {
  final List<ManageMember> members;
  final ManageMember? editingMember;
  final bool isCreating;
  final String tempName;
  final String tempRole;
  final bool isLoading;
  final String? error;

  const ManageMembersState({
    this.members = const [],
    this.editingMember,
    this.isCreating = false,
    this.tempName = "",
    this.tempRole = "Editor",
    this.isLoading = false,
    this.error,
  });

  ManageMembersState copyWith({
    List<ManageMember>? members,
    ManageMember? editingMember,
    bool? isCreating,
    String? tempName,
    String? tempRole,
    bool? isLoading,
    String? error,
    bool clearEditingMember = false,
    bool clearError = false,
  }) {
    return ManageMembersState(
      members: members ?? this.members,
      editingMember: clearEditingMember ? null : (editingMember ?? this.editingMember),
      isCreating: isCreating ?? this.isCreating,
      tempName: tempName ?? this.tempName,
      tempRole: tempRole ?? this.tempRole,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
        members,
        editingMember,
        isCreating,
        tempName,
        tempRole,
        isLoading,
        error,
      ];
}

class ManageMembersCubit extends Cubit<ManageMembersState> {
  final nameController = TextEditingController();

  ManageMembersCubit() : super(const ManageMembersState());

  Future<void> loadBoardUsers(String slug) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    const String query = r'''
      query BoardBySlug($slug: String!) {
        boardBySlug(slug: $slug) {
          users {
            id
            name
            active_card
            email
            username
            email_verified_at
            current_team_id
            updated_at
            pivot {
              role
            }
          }
        }
      }
    ''';

    try {
      final result = await GraphQLService.callGraphQL(
        query: query,
        variables: {"slug": slug},
        isMutation: false,
      );

      if (!result.hasException && result.data != null) {
        final data = result.data!['boardBySlug'];
        if (data != null && data['users'] != null) {
          final users = List<Map<String, dynamic>>.from(data['users']);
          emit(state.copyWith(
            members: users.map((u) => ManageMember.fromJson(u)).toList(),
            isLoading: false,
          ));
          debugPrint("Board users loaded: ${users.length} users");
        } else {
          emit(state.copyWith(
            isLoading: false,
            error: "No board data found",
          ));
        }
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: result.exception?.toString() ?? "Unknown GraphQL error",
        ));
        debugPrint("GraphQL error: ${result.exception}");
      }
    } catch (e, stackTrace) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
      debugPrint("Exception while loading users: $e");
      debugPrint("Stack trace: $stackTrace");
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    return super.close();
  }

  /// Start creating a new member
  void startCreating() {
    nameController.clear();
    emit(state.copyWith(
      isCreating: true,
      clearEditingMember: true,
      tempName: "",
      tempRole: "Editor",
    ));
  }

  /// Start editing an existing member
  void startEditing(ManageMember member) {
    nameController.text = member.name ?? "";
    emit(state.copyWith(
      editingMember: member,
      isCreating: false,
      tempName: member.name ?? "",
      tempRole: member.role ?? "Editor",
    ));
  }

  /// Update temporary name (form input)
  void updateTempName(String name) {
    emit(state.copyWith(tempName: name));
  }

  /// Update temporary role (dropdown input)
  void updateTempRole(String role) {
    emit(state.copyWith(tempRole: role));
  }

  /// Add a new member
  void addMember() {
    if (state.tempName.trim().isEmpty) return;

    final newMember = ManageMember(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: state.tempName.trim(),
      role: state.tempRole,
    );

    nameController.clear();
    emit(state.copyWith(
      members: [...state.members, newMember],
      isCreating: false,
      clearEditingMember: true,
      tempName: "",
      tempRole: "Editor",
    ));
  }

  void updateMember() {
    if (state.editingMember == null) return;
    if (state.tempName.trim().isEmpty) return;

    final updated = state.editingMember!.copyWith(
      name: state.tempName.trim(),
      role: state.tempRole,
    );

    final updatedList = state.members.map((m) {
      return m.id == updated.id ? updated : m;
    }).toList();

    nameController.clear();
    emit(state.copyWith(
      members: updatedList,
      clearEditingMember: true,
      isCreating: false,
      tempName: "",
      tempRole: "Editor",
    ));
  }

  void deleteMember(ManageMember member) {
    final updatedList = state.members.where((m) => m.id != member.id).toList();

    // If we're currently editing the member being deleted, cancel the form
    bool shouldClearForm = state.editingMember?.id == member.id;

    if (shouldClearForm) {
      nameController.clear();
      emit(state.copyWith(
        members: updatedList,
        clearEditingMember: true,
        isCreating: false,
        tempName: "",
        tempRole: "Editor",
      ));
    } else {
      emit(state.copyWith(members: updatedList));
    }
  }

  void cancelForm() {
    nameController.clear();
    emit(state.copyWith(
      isCreating: false,
      clearEditingMember: true,
      tempName: "",
      tempRole: "Editor",
    ));
  }

  void clearEditing() {
    nameController.clear();
    emit(state.copyWith(
      clearEditingMember: true,
      isCreating: false,
      tempName: "",
      tempRole: "Editor",
    ));
  }

  void setEditing(ManageMember member) {
    startEditing(member);
  }
}