enum FileType {
  png,
  jpg,
  jpeg,
  gif,
  bmp,
  webp,
  mp4,
  mov,
  avi,
  mkv,
  pdf,
  doc,
  docx,
  xls,
  xlsx,
  txt,
  unknown,
}

FileType getFileType(String fileName) {
  String extension = '';
  if (fileName.contains('.')) {
    extension = fileName.split('.').last.toLowerCase();
  }

  switch (extension) {
    case 'png':
      return FileType.png;
    case 'jpg':
      return FileType.jpg;
    case 'jpeg':
      return FileType.jpeg;
    case 'gif':
      return FileType.gif;
    case 'bmp':
      return FileType.bmp;
    case 'webp':
      return FileType.webp;
    case 'mp4':
      return FileType.mp4;
    case 'mov':
      return FileType.mov;
    case 'avi':
      return FileType.avi;
    case 'mkv':
      return FileType.mkv;
    case 'pdf':
      return FileType.pdf;
    case 'doc':
      return FileType.doc;
    case 'docx':
      return FileType.docx;
    case 'xls':
      return FileType.xls;
    case 'xlsx':
      return FileType.xlsx;
    case 'txt':
      return FileType.txt;
    default:
      return FileType.unknown;
  }
}

