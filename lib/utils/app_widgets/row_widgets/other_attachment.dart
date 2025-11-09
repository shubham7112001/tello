import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/card_page_blocs/attachment_cubit.dart';
import 'package:otper_mobile/app_ui/card_page_ui/card_page_row_background.dart';

class OtherAttachment extends StatelessWidget {
  const OtherAttachment({super.key});

  @override
  Widget build(BuildContext context) {
    return CardPageRowBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          OtherAttachmentHeader(),
          OtherAttachmentContent(),
        ],
      ),
    );
  }
}

class CustomOtherTile extends StatelessWidget {
  final String fileUrl;
  final String label;

  const CustomOtherTile({
    super.key,
    required this.fileUrl,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              // Open file in browser or with appropriate handler
              // Could use url_launcher or a native intent
            },
            child: Container(
              width: 120,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.blue.shade100,
              ),
              child: const Icon(Icons.insert_drive_file, color: Colors.blue, size: 40),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class OtherAttachmentContent extends StatelessWidget {
  const OtherAttachmentContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttachmentCubit, AttachmentState>(
      builder: (context, state) {
        return AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: state.isOtherExpanded
              ? SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: state.otherFiles.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, index) => CustomOtherTile(
                      fileUrl: "${state.otherFiles[index].name}",
                      label: "File ${index + 1}",
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}

class OtherAttachmentHeader extends StatelessWidget {
  const OtherAttachmentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttachmentCubit, AttachmentState>(
      builder: (context, state) {
        return InkWell(
          onTap: () => context.read<AttachmentCubit>().toggleOtherExpanded(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Other Attachments", style: Theme.of(context).textTheme.labelSmall),
                AnimatedRotation(
                  turns: state.isOtherExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.keyboard_arrow_down_outlined),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
