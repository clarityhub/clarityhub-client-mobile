import 'package:clarityhub/domains/slate/0_47_8/parser.dart';

Slate emptySlate() {
  return new Slate(
    object: 'value',
    document: new Document(
      object: 'document',
      nodes: [
        new Node(
          object: 'block',
          type: 'paragraph',
          data: {},
          nodes: [new TextNode(
            object: 'text',
            text: '',
            marks: [],
          )],
        )
      ]
    )
  );
}