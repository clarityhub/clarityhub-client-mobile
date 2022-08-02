import 'dart:convert';

import 'package:clarityhub/domains/slate/0_47_8/addons.dart';
import 'package:clarityhub/domains/slate/0_47_8/empty.dart';
import 'package:clarityhub/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:linkify/linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class InlineContext {
  final int numbered;

  InlineContext({ this.numbered });
}

class SlateObject {
  String object;
  SlateObject({ this.object });

  Widget render(BuildContext context) {
    return Text("$object not implemented");
  }

  Widget renderPreview(BuildContext context) {
    return Text("$object not implemented");
  }

  List<InlineSpan> renderInline(BuildContext context, { TextStyle style, InlineContext inlineContext }) {
    return [TextSpan(text: "$object inline not implemented")];
  }

  bool isEmpty() {
    return false;
  }

  Map<String, dynamic> toJson() =>
    {
      'object': object,
    };
}

class Slate extends SlateObject {
  Document document;
  Slate({ this.document, object }) : super(object: object);

  @override
  Widget render(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[document.render(context)]
    );
  }

  @override
  Widget renderPreview(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[document.renderPreview(context)]
    );
  }

  @override
  bool isEmpty() {
    return document == null || document.isEmpty();
  }

  void addBlock(SlateObject so) {
    document.nodes.add(so);
  }

  @override
  Map<String, dynamic> toJson() =>
    {
      'object': object,
      'document': document.toJson(),
    };
}

class Document extends SlateObject {
  var data;
  List<SlateObject> nodes;
  Document({ this.data, this.nodes, object }) : super(object: object);

  @override
  Widget render(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: nodes.map((node) => node.render(context)).toList()
    );
  }

  @override
  bool isEmpty() {
    if (nodes == null || nodes.length == 0) {
      return true;
    }

    if (nodes != null && nodes.every((node) {
      return node.isEmpty();
    })) {
      return true;
    }

    return false;
  }

  @override
  Widget renderPreview(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[nodes.first.renderPreview(context)],
    );
  }

  @override
  Map<String, dynamic> toJson() =>
    {
      'object': object,
      'data': data,
      'nodes': nodes.map((node) => node.toJson()).toList(), 
    };
}

class Node extends SlateObject {
  String type;
  var data;
  List<SlateObject> nodes;

  Node({ this.type, this.data, this.nodes, object }) : super(object: object);

  @override
  bool isEmpty() {
    if (nodes == null || nodes.length == 0) {
      return true;
    }

    if (nodes != null && nodes.every((node) {
      return node.isEmpty();
    })) {
      return true;
    }

    return false;
  }

  @override
  Widget render(BuildContext context) {
    MyTheme.init(context);

    TextStyle style;

    switch (type) {
      case 'heading-one':
        style = TextStyle(
          fontSize: MyTheme.largeText(),
        );
        break;
      case 'heading-two':
        style = TextStyle(
          fontSize: MyTheme.largeText()  * 2.0 / 3.0,
        );
        break;
      case 'bulleted-list':
      case 'numbered-list':
        style = TextStyle(
          fontSize: MyTheme.normalTextSize(),
        );
        break;
      default:
        style = TextStyle(
          fontSize: MyTheme.normalTextSize(),
        );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
      child: Text.rich(
        TextSpan(
          text: '',
          children: nodes.asMap().entries.map((entry) {
            int index = entry.key;
            var node = entry.value;
            switch (type) {
              case 'bulleted-list':
              case 'numbered-list': {
                List<InlineSpan> spans = node.renderInline(
                  context,
                  style: style,
                  inlineContext: InlineContext(numbered: type == 'numbered-list' ? index + 1 : null),
                );
                for (var i = spans.length - 1; i >= 0; i--) {
                  spans.insert(i, new TextSpan(text: '\n'));
                }
                return spans;
              }
              default: {
                return node.renderInline(context, style: style);
              }
            }
          }).toList().expand((x) => x).toList(),
        ),
      )
    );
  }

  @override
  List<InlineSpan> renderInline(BuildContext context, { style, InlineContext inlineContext }) {
    switch (type) {
      case 'list-item':
        return [TextSpan(
          text: '',
          children: nodes.map((node) {
            String prefix = inlineContext?.numbered != null ? '${inlineContext?.numbered}. ' :  '\u2022 ';

            List<InlineSpan> spans = node.renderInline(context, style: style);
            spans.insert(0, new TextSpan(text: prefix, style: style));
            return spans;
          }).toList().expand((x) => x).toList(),
        )];
      case 'heading-one':
      case 'heading-two':
      default:
        return [TextSpan(
          text: '',
          children: nodes.map((node) => node.renderInline(context, style: style )).toList().expand((x) => x).toList(),
        )];
    }
  }

  @override
  Widget renderPreview(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: '',
        children: nodes.first.renderInline(context),
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 3,
    );
  }

  @override
  Map<String, dynamic> toJson() =>
    {
      'object': object,
      'type': type,
      'data': data,
      'nodes': nodes.map((node) => node.toJson()).toList(), 
    };
}

class BlockQuoteNode extends Node {
  BlockQuoteNode({ type, data, nodes, object }) : super(
    type: type, data: data, nodes: nodes, object: object
  );

  @override
  Widget render(BuildContext context) {
    MyTheme.init(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
      child: Text.rich(
        TextSpan(
          text: '> ',
          style: TextStyle(
            fontStyle: FontStyle.italic,
          ),
          children: nodes.map((node) => node.renderInline(context)).toList().expand((x) => x).toList(),
        ),
      )
    );
  }
}

class LinkifyWrapper {
  InlineSpan getTextSpan({
    String text, Function onOpen, BuildContext context, TextStyle style
  }) {
    final elements = linkify(
      text,
    );

    return buildTextSpan(
      elements,
      style: Theme.of(context).textTheme.body1.merge(style),
      onOpen: onOpen,
      linkStyle: Theme.of(context)
          .textTheme
          .body1
          .copyWith(
            color: Colors.blueAccent,
            decoration: TextDecoration.underline,
          )
    );
  }
}

class TextNode extends SlateObject {
  String text;
  dynamic marks;

  TextNode({ this.text, this.marks, object }) : super(object: object);

  @override
  bool isEmpty() {
    if (text == null || text.isEmpty) {
      return true;
    }

    return false;
  }

  @override
  Widget render(BuildContext context) {
    return Text(text);
  }

  @override
  List<InlineSpan> renderInline(BuildContext context, { TextStyle style, InlineContext inlineContext }) {
    LinkifyWrapper link = new LinkifyWrapper();

    return [link.getTextSpan(
      onOpen: (link) async {
        if (await canLaunch(link.url)) {
          await launch(link.url);
        }
      },
      text: text,
      context: context,
      style: style
    )];
  }

  @override
  Map<String, dynamic> toJson() =>
    {
      'object': object,
      'text': text,
      'marks': marks,
    };
}

class InlineNode extends SlateObject {
  String type;
  var data;
  List<SlateObject> nodes;

  InlineNode({ this.type, this.data, this.nodes, object }) : super(object: object);

  @override
  Widget render(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: nodes.map((node) => node.render(context)).toList()
    );
  }

  @override
  List<InlineSpan> renderInline(BuildContext context, { TextStyle style, InlineContext inlineContext }) {
    return nodes.map((node) => node.renderInline(context, style: style )).toList().expand((x) => x).toList();
  }

  @override
  Map<String, dynamic> toJson() =>
    {
      'object': object,
      'type': type,
      'data': data,
      'nodes': nodes.map((node) => node.toJson()).toList(), 
    };
}

class SeparatorNode extends SlateObject {
  String type;
  var data;
  List<SlateObject> nodes;

  SeparatorNode({ this.type, this.data, this.nodes, object }) : super(object: object);

  @override
  Widget render(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Divider(
            color: Colors.black,
            height: 36,
          )
        )
      ]
    );
  }

  @override
  Widget renderPreview(BuildContext context) {
    return Divider(
      color: Colors.black,
      height: 36,
    );
  }

  @override
  Map<String, dynamic> toJson() =>
    {
      'object': object,
      'type': type,
      'data': data,
      'nodes': nodes.map((node) => node.toJson()).toList(), 
    };
}

class UnknownNode extends SlateObject {}

class Parser {
  static SlateObject parseText(Map<String, dynamic> json) {
    String object = json['object'];
  
    switch (object) {
      case 'text': {
        return new TextNode(
          text: json['text'] as String,
          marks: json['marks'],
          object: object,
        );
      }
      case 'inline':
        return new InlineNode(
          data: json['data'],
          type: json['type'],
          nodes: (json['nodes'] as List<dynamic>).map((node) => parseText(node)).toList(),
          object: object,
        );
      case 'block':
        print('json $json');
        return parseBlock(json);
      default: {
        // Unknown block
        print('Unknown object type in parseText: $object');
        return new UnknownNode();
      }
    }
  }

  static SlateObject parseBlock(Map<String, dynamic> json) {
    String object = json['object'];
    String type = json['type'];

    // TODO have this injected at the parse() call
    SlateObject addonObject = new SlateAddons().parseBlock(json);

    if (addonObject != null) {
      return addonObject;
    }

    print('object $object, type: $type');

    switch (type) {
      case 'separator': {
        return SeparatorNode(
          object: object,
          data: json['data'],
          type: type,
          nodes: (json['nodes'] as List<dynamic>).map((node) => parseText(node)).toList(),
        );
      }
      case 'block-quote':
        return BlockQuoteNode(
          object: object,
          data: json['data'],
          type: type,
          nodes: (json['nodes'] as List<dynamic>).map((node) => parseText(node)).toList(),
        );
      case 'bulleted-list':
      case 'numbered-list':
      case 'list-item':
      case 'paragraph':
      case 'heading-one': 
      default: {
        return Node(
          object: object,
          data: json['data'],
          type: type,
          nodes: (json['nodes'] as List<dynamic>).map((node) => parseText(node)).toList(),
        );
      }
      // default: {
      //   // Unknown block
      //   print('Unknown type in parseBlock: $type');
      //   return new UnknownNode();
      // }
    }
  }

  static SlateObject parse(Map<String, dynamic> json) {
    String object = json['object'];

    switch (object) {
      case 'value': {
        return new Slate(
          object: object,
          document: parse(json['document']),
        );
      }
      case 'document': {
        return new Document(
          object: object,
          data: json['data'],
          nodes: (json['nodes'] as List<dynamic>).map((node) => parse(node)).toList(),
        );
      }
      case 'block':{
        return parseBlock(json);
      }
      default: {
        // Unknown block
        print('Unknown object type in parse: $object');
        return new UnknownNode();
      }
    }
  }

  static Slate parseJsonString(String jsonString) {
    if (jsonString == null) {
      return emptySlate();
    }
    Map<String, dynamic> data = jsonDecode(jsonString);
    
    try {
      Slate slate = parse(data);
      return slate;
    } catch(e) {
      return emptySlate();
    }
  } 
}