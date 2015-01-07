library ed_visitors;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';

import 'optionals.dart';

typedef NodeVisitor(PolymerElement parent, Node n);

/*
typedef NodeVisitor(Context context, PolymerElement parent, Node node);

class Context {
  void childsWith(NodeVisitor visitor) {
    
  }
}
*/

abstract class Visitor {
  Optional<Visitor> visit(PolymerElement parent, Node n);
}

class NodeVisitorAsVisitor extends Visitor {

  NodeVisitor visitor;
  
  NodeVisitorAsVisitor(this.visitor);
  
  @override
  Optional<Visitor> visit(PolymerElement parent, Node n) {
    visitor(parent,n);
    return new Optional(this);
  }
}

abstract class Visitors {
  
  static void visit(PolymerElement parent, Visitor visitor) {
    //parent.childNodes.forEach(printNode);
    parent.shadowRoot.nodes.forEach((e) {
      var next = visitor.visit(parent, e);
      if (next.isPresent) {
        if (e is PolymerElement) {
          PolymerElement pe=e as PolymerElement;
          visit(pe, next.get());
        }
      }
    });
  }
  
  static void visitAll(PolymerElement parent, NodeVisitor visitor) {
    visit(parent, new NodeVisitorAsVisitor(visitor));
  }
  
}
