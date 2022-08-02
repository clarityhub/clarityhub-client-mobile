import 'package:clarityhub/domains/slate/0_47_8/parser.dart';

class Interview {
  String workspaceId;
  String id;
  String updatedAt;
  String content;
  String title;
  String createdAt;
  Slate slateContent;

  Interview({
    this.workspaceId,
    this.id,
    this.updatedAt,
    this.content,
    this.title,
    this.slateContent,
    this.createdAt
  });

  factory Interview.fromJson(Map<String, dynamic> parsedJson) {
    if (parsedJson != null)
      return Interview(
        createdAt: parsedJson['createdAt'],
        id: parsedJson['id'],
        updatedAt: parsedJson['updatedAt'],
        workspaceId: parsedJson['workspaceId'],
        title: parsedJson['title'],
        content: parsedJson['content'],
        slateContent: Parser.parseJsonString(parsedJson['content'])
      );
    else
      return null;
  }
}
