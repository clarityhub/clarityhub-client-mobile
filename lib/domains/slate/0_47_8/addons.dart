import 'package:clarityhub/domains/medias/widgets/mediaItem.dart';
import 'package:clarityhub/domains/slate/0_47_8/parser.dart';
import 'package:flutter/material.dart';


class MediaNode extends SlateObject {
  String type;
  var data;
  List<SlateObject> nodes;
  MediaNode({ this.type, this.data, this.nodes, object }) : super(object: object);

  @override
  Widget render(BuildContext context) {
    return MediaItem(
      mediaId: data['id'],
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

class SlateAddons {
  SlateObject parseBlock(Map<String, dynamic> json) {
    String object = json['object'];
    String type = json['type'];

    switch (type) {
      case 'media': {
        return MediaNode(
          object: object,
          data: json['data'],
          type: type,
          nodes: [],
        );
      }
      default: {
        return null;
      }
    }
  }
}