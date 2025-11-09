import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/card_page_blocs/attachment_cubit.dart';
import 'package:otper_mobile/app_bloc_cubit/card_page_blocs/card_comment_cubit.dart';
import 'package:otper_mobile/app_bloc_cubit/card_page_blocs/description_cubit.dart';
import 'package:otper_mobile/app_bloc_cubit/card_page_blocs/members_cubit.dart';
import 'package:otper_mobile/app_bloc_cubit/checklist_blocs/checklist_cubit.dart';
import 'package:otper_mobile/app_ui/card_page_ui/card_comment_section.dart';
import 'package:otper_mobile/app_ui/card_page_ui/card_page_elements/activity_row.dart';
import 'package:otper_mobile/app_ui/card_page_ui/card_page_elements/description_row.dart';
import 'package:otper_mobile/app_ui/card_page_ui/card_page_elements/labels_view.dart';
import 'package:otper_mobile/app_ui/card_page_ui/card_page_elements/members_view.dart';
import 'package:otper_mobile/app_ui/card_page_ui/card_page_elements/quick_actions/quick_action_section.dart';
import 'package:otper_mobile/app_ui/card_page_ui/card_page_row_background.dart';
import 'package:otper_mobile/data/models/card_model.dart';
import 'package:otper_mobile/utils/app_widgets/row_widgets/add_attachment_row.dart';
import 'package:otper_mobile/utils/app_widgets/row_widgets/board_detail_row.dart';
import 'package:otper_mobile/utils/app_widgets/row_widgets/checklist_view.dart';
import 'package:otper_mobile/app_ui/card_page_ui/card_page_elements/card_datetime.dart';
import 'package:otper_mobile/utils/app_widgets/row_widgets/image_attachment.dart';
import 'package:otper_mobile/utils/app_widgets/row_widgets/other_attachment.dart';
import 'package:otper_mobile/utils/app_widgets/row_widgets/pdf_attachment.dart';
import 'package:otper_mobile/utils/app_widgets/row_widgets/simple_row.dart';
import 'package:otper_mobile/utils/helper/helper_function.dart';

class CardView extends StatelessWidget {
  final CardModel card;
  final String boardId;
  const CardView({super.key, required this.card, required this.boardId});

  @override
  Widget build(BuildContext context) {
    debugPrint("Card User length: ${card.users?.length}");
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DescriptionCubit(initial: card.description ?? ""),
        ),
        BlocProvider(
          create: (_) => AttachmentCubit(
            initialState: AttachmentState(files: card.files ?? []),
          ),
        ),
        BlocProvider(
          create: (_) => ChecklistCubit(card: card),
        ),
        BlocProvider(
          create: (_) => CardCommentCubit(),
        ),
        BlocProvider(
          create: (_) => MembersCubit(initialMembers: card.users ?? []),
        ),
      ],
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              spacing: 2.0,
              children: [
                // CardPageRowBackground(
                //   child: TitleRow(
                //     title: card.title ?? "No title",
                //     isTitleLarge: true,
                //   ),
                // ),
                CardPageRowBackground(
                  child: BoardDetailRow(
                    title: card.board?.name,
                    description: card.board?.description,
                  ),
                ),
                CardPageRowBackground(child: QuickActionsSection()),
                CardPageRowBackground(child: DescriptionText(icon: Icons.notes)),
                LabelsView(labels: card.labels ?? []),

                BlocBuilder<MembersCubit, MembersState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: () => HelperFunction.showCustomDialog(
                        context: context,
                        child: BlocProvider.value(
                          value: context.read<MembersCubit>(),
                          child: const MembersView(),
                        ),
                        useIntrinsic: false,
                      ),
                      child: CardPageRowBackground(
                        child: SimpleRowView(
                          icon: Icons.person_outline_sharp,
                          text: "Members",
                        ),
                      ),
                    );
                  },
                ),

                CardDateTime(startDate: card.startTime, dueDate: card.dueDate),
                BlocBuilder<AttachmentCubit, AttachmentState>(
                  builder: (context, state) {
                    return Column(
                      spacing: 2,
                      children: [
                        AttachmentRowView(),
                        if (state.imageFiles.isNotEmpty) ImageAttachment(),
                        if (state.pdfFiles.isNotEmpty) PdfAttachment(),
                        if (state.otherFiles.isNotEmpty) OtherAttachment(),
                      ],
                    );
                  },
                ),
                ChecklistView(),
                ActivityRow(),
                SizedBox(height: 300),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CardCommentSection(cardId: card.id ?? "",boardId: boardId,),
          ),
        ],
      ),
    );
  }
}


