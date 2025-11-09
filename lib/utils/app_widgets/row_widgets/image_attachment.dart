import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/card_page_blocs/attachment_cubit.dart';
import 'package:otper_mobile/app_graphql/graph_config.dart';
import 'package:otper_mobile/app_ui/card_page_ui/card_page_row_background.dart';
import 'package:otper_mobile/data/api/rest_api/api_endpoints.dart';


class ImageAttachment extends StatelessWidget {
  const ImageAttachment({super.key});

  @override
  Widget build(BuildContext context) {
    return CardPageRowBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          ImageAttachmentHeader(),
          ImageAttachmentContent(),
        ],
      ),
    );
  }
}


class CustomImageTile extends StatelessWidget {
  final String imageUrl;
  final String label;

  const CustomImageTile({
    super.key,
    required this.imageUrl,
    required this.label,
  });

  String normalizeUrl(String url) {
    url = url.replaceAll(RegExp(r'\s+'), ' ');
    return Uri.encodeFull(url);
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              normalizeUrl("${ApiEndpoints.docs}$imageUrl"),
              headers: {
                'Authorization': '${GraphConfig.token}', // or whatever your API expects
              },
              width: 120,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 120,
                  height: 80,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                );
              },
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

class ImageAttachmentContent extends StatelessWidget {
  const ImageAttachmentContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttachmentCubit, AttachmentState>(
      builder: (context, state) {
        return AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: state.isImageExpanded
              ? SizedBox(
                  height: 120, // height of the horizontal list
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: state.imageFiles.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, index) => CustomImageTile(
                      imageUrl: "${state.imageFiles[index].name}",
                      label: "Image ${index + 1}",
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}

class ImageAttachmentHeader extends StatelessWidget {
  const ImageAttachmentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttachmentCubit, AttachmentState>(
      builder: (context, state) {
        return InkWell(
          onTap: () => context.read<AttachmentCubit>().toggleImageExpanded(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Image attachments", style: Theme.of(context).textTheme.labelSmall,),
                AnimatedRotation(
                  turns: state.isImageExpanded ? 0.5 : 0,
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
