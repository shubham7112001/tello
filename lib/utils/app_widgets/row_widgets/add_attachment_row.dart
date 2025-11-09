import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_ui/card_page_ui/card_page_row_background.dart';
import 'package:otper_mobile/utils/app_widgets/row_widgets/simple_row.dart';
import 'package:otper_mobile/app_bloc_cubit/card_page_blocs/attachment_cubit.dart';

class AttachmentRowView extends StatelessWidget {
  const AttachmentRowView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttachmentCubit, AttachmentState>(
      builder: (context, state) {
        return CardPageRowBackground(
          child: InkWell(
            onTap: () => showAttachmentOptions(context),
            child: SimpleRowView(
              icon: Icons.attachment,
              text: state.filePath != null
                  ? state.filePath!.split('/').last
                  : "Attachments",
              actions: const [Icon(Icons.add)],
            ),
          ),
        );
      },
    );
  }
}

 void showAttachmentOptions(BuildContext context) {
    final List<String> documentTypes = [
      "PDF",
      "Image",
      "Other"
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Select Document Type",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              ...documentTypes.map(
                (type) => ListTile(
                  leading: const Icon(Icons.insert_drive_file),
                  title: Text(type),
                  onTap: () {
                    context.read<AttachmentCubit>().pickFile(type);
                    GoRouter.of(context).pop();

                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

