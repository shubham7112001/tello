import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/card_page_blocs/attachment_cubit.dart';
import 'package:otper_mobile/app_graphql/graph_config.dart';
import 'package:otper_mobile/app_ui/card_page_ui/card_page_row_background.dart';

class PdfAttachment extends StatelessWidget {
  const PdfAttachment({super.key});

  @override
  Widget build(BuildContext context) {
    return CardPageRowBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          PdfAttachmentHeader(),
          PdfAttachmentContent(),
        ],
      ),
    );
  }
}

class CustomPdfTile extends StatelessWidget {
  final String pdfUrl;
  final String label;

  const CustomPdfTile({
    super.key,
    required this.pdfUrl,
    required this.label,
  });

  String normalizeUrl(String url) {
    return Uri.encodeFull(url);
  }

  @override
  Widget build(BuildContext context) {
    log("Authorization': 'Bearer ${GraphConfig.token}");

    return SizedBox(
      width: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              // Open PDF in viewer or browser
              // You could integrate a PDF viewer package here
            },
            child: Container(
              width: 120,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.red.shade100,
              ),
              child: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 40),
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

class PdfAttachmentContent extends StatelessWidget {
  const PdfAttachmentContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttachmentCubit, AttachmentState>(
      builder: (context, state) {
        return AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: state.isPdfExpanded
              ? SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: state.pdfFiles.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, index) => CustomPdfTile(
                      pdfUrl: "${state.pdfFiles[index].name}",
                      label: "PDF ${index + 1}",
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}

class PdfAttachmentHeader extends StatelessWidget {
  const PdfAttachmentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttachmentCubit, AttachmentState>(
      builder: (context, state) {
        return InkWell(
          onTap: () => context.read<AttachmentCubit>().togglePdfExpanded(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Pdf attachments", style: Theme.of(context).textTheme.labelSmall),
                AnimatedRotation(
                  turns: state.isPdfExpanded ? 0.5 : 0,
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
