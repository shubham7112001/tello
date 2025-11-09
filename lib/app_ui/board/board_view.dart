import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/zoom/zoom_bloc.dart';
import 'package:otper_mobile/app_flowy_board/appflowy_board.dart';
import 'package:otper_mobile/app_graphql/graph_service.dart';
import 'package:otper_mobile/app_ui/board/drawer/board_drawer.dart';
import 'package:otper_mobile/configs/router_configs.dart/app_navigator.dart';
import 'package:otper_mobile/data/models/board_model.dart';
import 'package:otper_mobile/data/models/home_board_model.dart';
import 'package:otper_mobile/utils/app_widgets/app_card.dart';
import 'package:otper_mobile/app_bloc_cubit/board_blocs/board_bloc.dart';
import 'package:otper_mobile/utils/app_widgets/icons_app.dart';
import 'package:otper_mobile/utils/app_widgets/zoomable_widget.dart';
import 'package:otper_mobile/utils/constants/app_colors.dart';
import 'package:otper_mobile/utils/constants/app_text_styles.dart';
import 'package:otper_mobile/utils/helper/helper_function.dart';

class BoardView extends StatelessWidget {
  final HomeBoardModel board;
  const BoardView({super.key, required this.board});

  Widget _buildCard(AppFlowyGroupItem item) {
    if (item is CardItem) {
      final card = item.card;
      return AppFlowyGroupCard(
        key: ValueKey(item.id),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: AppCard(card: card, board: board),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BoardBloc, BoardState>(
      builder: (context, state) {
        if (state is BoardLoaded) {
          return SizedBox(
            child: ZoomableWidget(
              child: AppFlowyBoard(
                controller: state.controller,
                scrollController: ScrollController(),
                headerBuilder: (context, columnData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            columnData.headerData.groupName,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const MediumIcon(Icons.more_vert),
                      ],
                    ),
                  );
                },
              
                cardBuilder: (context, group, groupItem) {
                  return _buildCard(groupItem);
                },
              
                footerBuilder: (context, columnData) {
                  return AppFlowyGroupFooter(
                    icon: const SmallIcon(Icons.add, color: Colors.blue),
                    title: Text(
                      'Add Card',
                      style: AppTextStyles.smallBlueText,
                    ),
                    height: 30,
                    onAddButtonClick: () async{
                      await addCard(context, listId: columnData.id);
                    },
                  );
                },
                groupConstraints: const BoxConstraints.tightFor(width: 240),
              
                config: AppFlowyBoardConfig(
                  groupBackgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.listBackgroundDark : AppColors.listBackgroundLight,
                  stretchGroupHeight: true,
                  groupMargin: const EdgeInsets.only(left: 8, right: 8,top: 4,bottom: 12),
                ),
              ),
            ),
          
            
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  
  }
}

// Future addCard(BuildContext context, {String? listId}) async {
//   await showModalBottomSheet(
//     context: context,
//     isScrollControlled: true, // To allow keyboard to push up the sheet
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//     ),
//     builder: (context) {
//       final TextEditingController titleController = TextEditingController();
//       final TextEditingController descriptionController = TextEditingController();

//       return Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
//           left: 16,
//           right: 16,
//           top: 16,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Add New Card",
//               style: Theme.of(context).textTheme.labelLarge,
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: titleController,
//               decoration: const InputDecoration(
//                 labelText: "Title",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: descriptionController,
//               maxLines: 3,
//               decoration: const InputDecoration(
//                 labelText: "Description",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context); // Close bottom sheet
//                   },
//                   child: const Text("Cancel"),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: () {
//                     final title = titleController.text.trim();
//                     final description = descriptionController.text.trim();

//                     if (title.isEmpty) {
//                       HelperFunction.showAppSnackBar(message: "Title cannot be empty", backgroundColor: Colors.red);
//                       return;
//                     }
//                     context.read<BoardBloc>().add(AddCardEvent(
//                       listId: listId ?? "-1", // Add to first list for simplicity
//                       title: title,
//                       description: description,
//                     ));

//                     debugPrint("Card Added: Title: $title, Description: $description");

//                     AppNavigator.pop();
//                   },
//                   child: const Text("Add"),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       );
//     },
//   );
// }

// Future<void> addCard(BuildContext context, {String? listId}) async {
//   // Validate that we have a valid listId
//   if (listId == null || listId.isEmpty) {
//     HelperFunction.showAppSnackBar(
//       message: "Unable to add card: Invalid list", 
//       backgroundColor: Colors.red
//     );
//     return;
//   }

//   // Check if board is loaded
//   final boardState = context.read<BoardBloc>().state;
//   if (boardState is! BoardLoaded) {
//     HelperFunction.showAppSnackBar(
//       message: "Board is not loaded yet", 
//       backgroundColor: Colors.red
//     );
//     return;
//   }

//   await showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//     ),
//     builder: (modalContext) {
//       final TextEditingController titleController = TextEditingController();
//       final TextEditingController descriptionController = TextEditingController();

//       return Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(modalContext).viewInsets.bottom,
//           left: 16,
//           right: 16,
//           top: 16,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Add New Card",
//               style: Theme.of(modalContext).textTheme.labelLarge,
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: titleController,
//               decoration: const InputDecoration(
//                 labelText: "Title",
//                 border: OutlineInputBorder(),
//               ),
//               autofocus: true,
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: descriptionController,
//               maxLines: 3,
//               decoration: const InputDecoration(
//                 labelText: "Description",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(modalContext);
//                   },
//                   child: const Text("Cancel"),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: () async {
//                     final title = titleController.text.trim();
//                     final description = descriptionController.text.trim();

//                     if (title.isEmpty) {
//                       HelperFunction.showAppSnackBar(
//                         message: "Title cannot be empty", 
//                         backgroundColor: Colors.red
//                       );
//                       return;
//                     }

//                     // Close the modal first
//                     Navigator.pop(modalContext);

//                     // Show loading indicator
//                     HelperFunction.showAppSnackBar(
//                       message: "Adding card...", 
//                       backgroundColor: Colors.blue
//                     );

//                     // Add the card using the original context (not modalContext)
//                     context.read<BoardBloc>().add(AddCardEvent(
//                       listId: listId,
//                       title: title,
//                       description: description,
//                     ));

//                     debugPrint("Card Add Requested: Title: $title, Description: $description, ListId: $listId");
//                   },
//                   child: const Text("Add"),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       );
//     },
//   );
// }

// Future<void> addCard(BuildContext context, {String? listId}) async {
//   // Validate that we have a valid listId
//   if (listId == null || listId.isEmpty) {
//     HelperFunction.showAppSnackBar(
//       message: "Unable to add card: Invalid list", 
//       backgroundColor: Colors.red
//     );
//     return;
//   }

//   // Check if board is loaded
//   final boardState = context.read<BoardBloc>().state;
//   if (boardState is! BoardLoaded) {
//     HelperFunction.showAppSnackBar(
//       message: "Board is not loaded yet", 
//       backgroundColor: Colors.red
//     );
//     return;
//   }

//   await showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     isDismissible: false, // Prevent dismissal during loading
//     enableDrag: false, // Prevent drag to dismiss during loading
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//     ),
//     builder: (modalContext) {
//       return _AddCardBottomSheet(
//         listId: listId,
//         parentContext: context,
//       );
//     },
//   );
// }

// class _AddCardBottomSheet extends StatefulWidget {
//   final String listId;
//   final BuildContext parentContext;

//   const _AddCardBottomSheet({
//     required this.listId,
//     required this.parentContext,
//   });

//   @override
//   State<_AddCardBottomSheet> createState() => _AddCardBottomSheetState();
// }

// class _AddCardBottomSheetState extends State<_AddCardBottomSheet> {
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   bool isLoading = false;
//   String? errorMessage;

//   @override
//   void dispose() {
//     titleController.dispose();
//     descriptionController.dispose();
//     super.dispose();
//   }

//   Future<void> _addCard() async {
//     final title = titleController.text.trim();
//     final description = descriptionController.text.trim();

//     if (title.isEmpty) {
//       setState(() {
//         errorMessage = "Title cannot be empty";
//       });
//       return;
//     }

//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//     });

//     try {
//       // Call GraphQL directly here instead of through BLoC
//       final result = await GraphQLService.callGraphQL(
//         query: '''
//           mutation CreateCard(\$listId: ID!, \$title: String!, \$description: String!) {
//             createCard(input: { list: { connect: \$listId }, title: \$title, description: \$description }) {
//               id
//               slug
//               title
//               pos
//               card_number
//               due_date
//               users {
//                 id
//                 name
//               }
//               labels {
//                 id
//                 name
//                 color
//               }
//             }
//           }
//         ''',
//         variables: {
//           "listId": widget.listId,
//           "title": title,
//           "description": description,
//         },
//         isMutation: true,
//       );

//       if (result.hasException) {
//         setState(() {
//           isLoading = false;
//           errorMessage = "Failed to create card: ${result.exception?.graphqlErrors.first.message ?? 'Unknown error'}";
//         });
//         return;
//       }

//       final cardData = result.data?['createCard'];
//       if (cardData == null) {
//         setState(() {
//           isLoading = false;
//           errorMessage = "No data returned from server";
//         });
//         return;
//       }

//       // Card created successfully, now update the BLoC
//       final newCard = BoardViewCardModel.fromJson(cardData);
//       final cardItem = CardItem(newCard);

//       // Update the BLoC state
//       final currentBoardState = widget.parentContext.read<BoardBloc>().state;
//       if (currentBoardState is BoardLoaded) {
//         // Add to controller
//         currentBoardState.controller.addGroupItem(widget.listId, cardItem);

//         // Update groups
//         final updatedGroups = currentBoardState.groups.map((group) {
//           if (group.id == widget.listId) {
//             final updatedItems = List<AppFlowyGroupItem>.from(group.items)..add(cardItem);
//             return AppFlowyGroupData(
//               id: group.id,
//               name: group.headerData.groupName,
//               items: updatedItems,
//             );
//           }
//           return group;
//         }).toList();

//         // Emit updated state
//         widget.parentContext.read<BoardBloc>().emit(
//           BoardLoaded(controller: currentBoardState.controller, groups: updatedGroups)
//         );
//       }

//       // Close the bottom sheet
//       if (mounted) {
//         Navigator.pop(context);
//         HelperFunction.showAppSnackBar(
//           message: "Card added successfully!", 
//           backgroundColor: Colors.green
//         );
//       }

//       debugPrint("Card added successfully: ${newCard.title}");
//     } catch (e, st) {
//       debugPrint("Error while adding card: $e");
//       debugPrint(st.toString());
//       setState(() {
//         isLoading = false;
//         errorMessage = "Failed to add card: $e";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//         left: 16,
//         right: 16,
//         top: 16,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Add New Card",
//             style: Theme.of(context).textTheme.labelLarge,
//           ),
//           const SizedBox(height: 16),
//           TextField(
//             controller: titleController,
//             enabled: !isLoading,
//             decoration: const InputDecoration(
//               labelText: "Title",
//               border: OutlineInputBorder(),
//             ),
//             autofocus: true,
//             onSubmitted: (_) => _addCard(),
//           ),
//           const SizedBox(height: 12),
//           TextField(
//             controller: descriptionController,
//             enabled: !isLoading,
//             maxLines: 3,
//             decoration: const InputDecoration(
//               labelText: "Description",
//               border: OutlineInputBorder(),
//             ),
//           ),
//           if (errorMessage != null) ...[
//             const SizedBox(height: 12),
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.red.shade50,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.red.shade200),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       errorMessage!,
//                       style: TextStyle(
//                         color: Colors.red.shade700,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               TextButton(
//                 onPressed: isLoading ? null : () {
//                   Navigator.pop(context);
//                 },
//                 child: const Text("Cancel"),
//               ),
//               const SizedBox(width: 8),
//               ElevatedButton(
//                 onPressed: isLoading ? null : _addCard,
//                 child: isLoading
//                     ? const SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(strokeWidth: 2),
//                       )
//                     : const Text("Add"),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }
// }

Future<void> addCard(BuildContext context, {String? listId}) async {
  // Validate that we have a valid listId
  if (listId == null || listId.isEmpty) {
    HelperFunction.showAppSnackBar(
      message: "Unable to add card: Invalid list", 
      backgroundColor: Colors.red
    );
    return;
  }

  // Check if board is loaded
  final boardState = context.read<BoardBloc>().state;
  if (boardState is! BoardLoaded) {
    HelperFunction.showAppSnackBar(
      message: "Board is not loaded yet", 
      backgroundColor: Colors.red
    );
    return;
  }

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false, // Prevent dismissal during loading
    enableDrag: false, // Prevent drag to dismiss during loading
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (modalContext) {
      return _AddCardBottomSheet(
        listId: listId,
        parentContext: context,
      );
    },
  );
}

class _AddCardBottomSheet extends StatefulWidget {
  final String listId;
  final BuildContext parentContext;

  const _AddCardBottomSheet({
    required this.listId,
    required this.parentContext,
  });

  @override
  State<_AddCardBottomSheet> createState() => _AddCardBottomSheetState();
}

class _AddCardBottomSheetState extends State<_AddCardBottomSheet> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;
  BoardBloc? _boardBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Store the BLoC reference safely
    _boardBloc = widget.parentContext.read<BoardBloc>();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _addCard() async {
    final String title = titleController.text.trim();
    final String description = descriptionController.text.trim();

    if (title.isEmpty) {
      if (mounted) {
        setState(() {
          errorMessage = "Title cannot be empty";
        });
      }
      return;
    }

    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      Map<String, dynamic> data = {
          "listId": widget.listId,
          "title": title,
          "description": description.isNotEmpty ? description : title,
        };
        debugPrint("GraphQL Variables: $data");
      final result = await GraphQLService.callGraphQL(
        query: '''
          mutation CreateCard(\$listId: ID!, \$title: String!, \$description: String!) {
            createCard(input: { list: { connect: \$listId }, title: \$title, description: \$description }) {
              id
              slug
              title
              pos
              card_number
              due_date
              users {
                id
                name
              }
              labels {
                id
                name
                color
              }
            }
          }
        ''',
        variables: data,
        isMutation: true,
      );

      if (!mounted) return;

      if (result.hasException) {
        setState(() {
          isLoading = false;
          errorMessage = "Failed to create card: ${result.exception?.graphqlErrors.first.message ?? 'Unknown error'}";
        });
        return;
      }

      final cardData = result.data?['createCard'];
      if (cardData == null) {
        if (mounted) {
          setState(() {
            isLoading = false;
            errorMessage = "No data returned from server";
          });
        }
        return;
      }

      // Card created successfully, now update the BLoC
      final newCard = BoardViewCardModel.fromJson(cardData);
      final cardItem = CardItem(newCard);

      // Update the BLoC state using the stored reference
      if (_boardBloc != null) {
        final currentBoardState = _boardBloc!.state;
        if (currentBoardState is BoardLoaded) {
          // Add to controller
          currentBoardState.controller.addGroupItem(widget.listId, cardItem);

          // Update groups
          final updatedGroups = currentBoardState.groups.map((group) {
            if (group.id == widget.listId) {
              final updatedItems = List<AppFlowyGroupItem>.from(group.items)..add(cardItem);
              return AppFlowyGroupData(
                id: group.id,
                name: group.headerData.groupName,
                items: updatedItems,
              );
            }
            return group;
          }).toList();

          // Emit updated state
          _boardBloc!.emit(
            BoardLoaded(controller: currentBoardState.controller, groups: updatedGroups)
          );
        }
      }

      // Close the bottom sheet and show success message
      if (mounted) {
        Navigator.pop(context);
        // Use the stored context for showing snackbar
        HelperFunction.showAppSnackBar(
          message: "Card added successfully!", 
          backgroundColor: Colors.green
        );
      }

      debugPrint("Card added successfully: ${newCard.title}");
    } catch (e, st) {
      debugPrint("Error while adding card: $e");
      debugPrint(st.toString());
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = "Failed to add card: $e";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add New Card",
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: titleController,
            enabled: !isLoading,
            decoration: const InputDecoration(
              labelText: "Title",
              border: OutlineInputBorder(),
            ),
            autofocus: true,
            onSubmitted: (_) => _addCard(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: descriptionController,
            enabled: !isLoading,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder(),
            ),
          ),
          if (errorMessage != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      errorMessage!,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: isLoading ? null : () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: isLoading ? null : _addCard,
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Add"),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}