import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/data/models/card_model.dart';
import 'package:otper_mobile/services/app_permissions.dart';
import 'package:otper_mobile/utils/helper/helper_function.dart';

class AttachmentState {
  final String? docType;
  final String? filePath;
  final bool isImageExpanded;
  final bool isPdfExpanded;
  final bool isOtherExpanded;
  final List<CardFile> files;
  final List<CardFile> imageFiles;
  final List<CardFile> pdfFiles;
  final List<CardFile> otherFiles;

  AttachmentState({
    this.docType,
    this.filePath,
    this.isImageExpanded = false,
    this.isPdfExpanded = false,
    this.isOtherExpanded = false,
    this.files = const [],
  }) : imageFiles = _categorizeFiles(files)["images"]!,
        pdfFiles = _categorizeFiles(files)["pdfs"]!,
        otherFiles = _categorizeFiles(files)["others"]!;

  AttachmentState copyWith({
    String? docType,
    String? filePath,
    bool? isImageExpanded,
    bool? isPdfExpanded,
    bool? isOtherExpanded,
    List<CardFile>? files,
  }) {

    return AttachmentState(
      docType: docType ?? this.docType,
      filePath: filePath ?? this.filePath,
      isImageExpanded: isImageExpanded ?? this.isImageExpanded,
      isPdfExpanded: isPdfExpanded ?? this.isPdfExpanded,
      isOtherExpanded: isOtherExpanded ?? this.isOtherExpanded,
      files: files ?? this.files,
    );
  }

  static Map<String, List<CardFile>> _categorizeFiles(List<CardFile> files) {
    final imageExts = ["jpg", "jpeg", "png", "gif", "webp", "bmp"];

    final images = <CardFile>[];
    final pdfs = <CardFile>[];
    final others = <CardFile>[];

    for (final f in files) {
      final ext = f.name?.split('.').last.toLowerCase();
      if (ext == "pdf") {
        pdfs.add(f);
      } else if (ext != null && imageExts.contains(ext)) {
        images.add(f);
      } else {
        others.add(f);
      }
    }

    return {
      "images": images,
      "pdfs": pdfs,
      "others": others,
    };
  }
}

class AttachmentCubit extends Cubit<AttachmentState> {
  AttachmentCubit({AttachmentState? initialState})
      : super(initialState ?? AttachmentState());

  Future<void> pickFile(String docType) async {

    bool permitted = await AppPermissions.isStoragePermissionGranted();
    
    if(!permitted){
      HelperFunction.showAppSnackBar(message: "Please provide the permission");
      await AppPermissions.requestStoragePermission();
      return;
    }

    FilePickerResult? result;

    switch (docType) {
      case "PDF":
        result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ["pdf"],
        );
        break;
      case "Image":
        result = await FilePicker.platform.pickFiles(type: FileType.image);
        break;
      default:
        result = await FilePicker.platform.pickFiles();
    }

    if (result != null && result.files.isNotEmpty) {
      final filePath = result.files.single.path;
      debugPrint("Attached file: $filePath");
      emit(AttachmentState(docType: docType, filePath: filePath));
    }
  }

  void toggleImageExpanded() {
    emit(state.copyWith(isImageExpanded: !state.isImageExpanded));
  }

  void togglePdfExpanded(){
    emit(state.copyWith(isPdfExpanded: !state.isPdfExpanded));
  }

  void toggleOtherExpanded(){
    emit(state.copyWith(isOtherExpanded: !state.isOtherExpanded));
  }
}
