library ed_visitors;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';

typedef void NodeVisitor(PolymerElement parent, Node n);

abstract class Visitors {
  
  static void visit(PolymerElement parent, NodeVisitor visitor) {
    //parent.childNodes.forEach(printNode);
    parent.shadowRoot.nodes.forEach((e) {
      visitor(parent, e);
      if (e is PolymerElement) {
        PolymerElement pe=e;
        visit(pe, visitor);
      }
    });
  }
  
}