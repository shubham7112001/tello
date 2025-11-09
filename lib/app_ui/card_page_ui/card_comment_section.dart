import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/card_page_blocs/card_comment_cubit.dart';
import 'package:otper_mobile/app_ui/card_page_ui/card_page_row_background.dart';
import 'package:otper_mobile/utils/app_widgets/icons_app.dart';

class CardCommentSection extends StatelessWidget {
  final String cardId;
  final String boardId;
  const CardCommentSection({super.key, required this.cardId, required this.boardId});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CardCommentCubit>();

    return SafeArea(
      child: CardPageRowBackground(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end, // 👈 keep items bottom aligned
            spacing: 8,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: const CircleAvatar(radius: 15,backgroundColor: Colors.lightBlue,),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          width: 0.4,
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                      ),
                      padding: const EdgeInsets.only(
                          right: 40, left: 6, top: 10, bottom: 10), // leave space for send button
                      child: BlocBuilder<CardCommentCubit, String>(
                        builder: (context, comment) {
                          return TextField(
                            style: Theme.of(context).textTheme.labelSmall,
                            maxLines: 15,
                            minLines: 1,
                            onChanged: cubit.updateComment,
                            controller: TextEditingController(text: comment)
                              ..selection = TextSelection.fromPosition(
                                TextPosition(offset: comment.length),
                              ),
                            decoration: const InputDecoration(
                              isDense: true,
                              hintText: "Add Comment",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          );
                        },
                      ),
                    ),
        
                    // Send icon inside textfield (bottom right)
                    Positioned(
                      bottom: 10,
                      right: 4,
                      child: BlocBuilder<CardCommentCubit, String>(
                        builder: (context, comment) {
                          return InkWell(
                            onTap: () {
                              if (comment.isNotEmpty) {
                                debugPrint("Message sent");
                                cubit.addComment(cardId, boardId,comment);
                              }
                            },
                            child: Transform.rotate(
                              angle: 315 * 3.1415926535 / 180,
                              child: MediumLargeIcon(Icons.send, color: comment.isEmpty ? Colors.grey : Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white   // for dark mode
                                        : Colors.black, )
                            )
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
        
              // 🔹 Attachment icon on the right
              Padding(
                padding: const EdgeInsets.only(bottom : 6.0),
                child: Transform.rotate(
                  angle: 45 * 3.1415926535 / 180,
                  child: LargeIcon(Icons.attach_file, color: Colors.grey),
                )
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}
