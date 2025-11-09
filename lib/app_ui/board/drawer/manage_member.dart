import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/board_blocs/board_drawer_blocs/manage_member_cubit.dart';
import 'package:otper_mobile/data/models/home_board_model.dart';
import 'package:otper_mobile/utils/app_widgets/icons_app.dart';
import 'package:otper_mobile/utils/helper/app_extensions.dart';

class ManageMembersPage extends StatelessWidget {
  final HomeBoardModel board;
  const ManageMembersPage({super.key, required this.board});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ManageMembersCubit()..loadBoardUsers(board.slug ?? ''),
      child: Scaffold(
        appBar: AppBar(title: const Text("Manage Members")),
        body: BlocBuilder<ManageMembersCubit, ManageMembersState>(
          builder: (context, state) {
            final cubit = context.read<ManageMembersCubit>();

            return Column(
              children: [
                // Error display
                if (state.error != null)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => cubit.emit(state.copyWith(clearError: true)),
                        ),
                      ],
                    ),
                  ),

                // FORM AT TOP
                if (state.isCreating || state.editingMember != null)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ManageMemberForm(),
                  ),

                // Loading indicator
                if (state.isLoading)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (state.members.isEmpty && !state.isLoading)
                  const Expanded(
                    child: Center(
                      child: Text(
                        "No members found",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.members.length,
                      itemBuilder: (context, index) {
                        final member = state.members[index];
                        final isCurrentlyEditing = state.editingMember?.id == member.id;
                        
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: Card(
                            elevation: isCurrentlyEditing ? 4 : 1,
                            color: isCurrentlyEditing
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context).colorScheme.surface,
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  (member.name?.isNotEmpty == true 
                                      ? member.name![0] 
                                      : '?').capitalizeFirst(),
                                ),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    member.name ?? 'No name',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    member.role ?? 'No role',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  if (member.email != null) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      member.email!,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              // trailing: Row(
                              //   mainAxisSize: MainAxisSize.min,
                              //   children: [
                              //     InkWell(
                              //       onTap: () => cubit.setEditing(member),
                              //       borderRadius: BorderRadius.circular(20),
                              //       child: const Padding(
                              //         padding: EdgeInsets.all(8.0),
                              //         child: LargeIcon(Icons.edit),
                              //       ),
                              //     ),
                              //     const SizedBox(width: 8),
                              //     InkWell(
                              //       onTap: () => _showDeleteConfirmation(
                              //         context,
                              //         member,
                              //         cubit,
                              //       ),
                              //       borderRadius: BorderRadius.circular(20),
                              //       child: const Padding(
                              //         padding: EdgeInsets.all(8.0),
                              //         child: LargeIcon(
                              //           Icons.delete,
                              //           color: Colors.red,
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
        // floatingActionButton: BlocBuilder<ManageMembersCubit, ManageMembersState>(
        //   builder: (context, state) {
        //     if (state.isCreating || state.editingMember != null) {
        //       return const SizedBox.shrink();
        //     }
        //     return FloatingActionButton(
        //       onPressed: () => context.read<ManageMembersCubit>().startCreating(),
        //       child: const Icon(Icons.add),
        //     );
        //   },
        // ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    ManageMember member,
    ManageMembersCubit cubit,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Member'),
          content: Text(
            'Are you sure you want to delete ${member.name ?? 'this member'}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                cubit.deleteMember(member);
                Navigator.of(dialogContext).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

// ---------------- MEMBER FORM ----------------
class ManageMemberForm extends StatelessWidget {
  const ManageMemberForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageMembersCubit, ManageMembersState>(
      builder: (context, state) {
        final cubit = context.read<ManageMembersCubit>();
        final isEditing = state.editingMember != null;

        return Card(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? "Edit Member" : "Add New Member",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),

                // Name text field
                TextField(
                  decoration: InputDecoration(
                    labelText: "Member Name *",
                    border: const OutlineInputBorder(),
                    errorText: state.tempName.trim().isEmpty && 
                               (state.isCreating || state.editingMember != null)
                        ? "Name is required"
                        : null,
                  ),
                  controller: cubit.nameController,
                  onChanged: cubit.updateTempName,
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(height: 16),

                // Role dropdown
                DropdownButtonFormField<String>(
                  value: state.tempRole.isNotEmpty ? state.tempRole : "Editor",
                  decoration: const InputDecoration(
                    labelText: "Role",
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: "Editor", child: Text("Editor")),
                    DropdownMenuItem(value: "Admin", child: Text("Admin")),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      cubit.updateTempRole(value);
                    }
                  },
                ),

                const SizedBox(height: 20),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.close),
                      label: const Text("Cancel"),
                      onPressed: cubit.cancelForm,
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      icon: Icon(isEditing ? Icons.save : Icons.add),
                      label: Text(isEditing ? "Save Changes" : "Add Member"),
                      onPressed: state.tempName.trim().isEmpty
                          ? null
                          : () {
                              if (isEditing) {
                                cubit.updateMember();
                              } else {
                                cubit.addMember();
                              }
                            },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
