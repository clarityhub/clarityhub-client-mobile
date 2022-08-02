class Media {
  String id;
  String createdAt;
  String filename;
  String fileType;
  String status;
  String transcript;
  String presignedUrl;
  String presignedDownloadUrl;

  Media({
    this.id,
    this.createdAt,
    this.filename,
    this.fileType,
    this.status,
    this.transcript,
    this.presignedUrl,
    this.presignedDownloadUrl,
  });

  factory Media.fromJson(Map<String, dynamic> parsedJson) {
    if (parsedJson != null) {
      return Media(
        id: parsedJson['id'],
        createdAt: parsedJson['createdAt'],
        filename: parsedJson['filename'],
        fileType: parsedJson['fileType'],
        status: parsedJson['status'],
        transcript: parsedJson['transcript'],
        presignedUrl: parsedJson['presignedUrl'],
        presignedDownloadUrl: parsedJson['presignedDownloadUrl'],
      );
    } else {
      return null;
    }
  }
}