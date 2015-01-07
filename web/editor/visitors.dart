library ed_visitors;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';

import 'optionals.dart';

typedef NodeVisitor(Element parent, Node n);

abstract class Visitor {
  Optional<Visitor> visit(Element parent, Node n);
}

class _NodeVisitorAsVisitor extends Visitor {

  NodeVisitor visitor;
  
  _NodeVisitorAsVisitor(this.visitor);
  
  @override
  Optional<Visitor> visit(Element parent, Node n) {
    visitor(parent,n);
    return new Optional(this);
  }
}

class _ForEachVisitor {
  
  Element parent;
  Visitor visitor;
  
  _ForEachVisitor(this.parent, this.visitor);
  
  void call(Node e) {
    var next = visitor.visit(parent, e);
    if (next.isPresent) {
      if (e is Element) {
        Element pe=e;
        Visitors.visit(pe, next.get());
      } else {
        if (e is ShadowRoot) {
          Visitors.visit(e.host, next.get());
        } else {
          Visitors._visitNode(e, next.get());
        }
      }
    } else {
      //print("skip: "+e.toString()+"("+e.runtimeType.toString()+")");
    }
  }
}

abstract class Visitors {
  
  static void _visitNode(Node node, Visitor visitor) {
    node.nodes.forEach((n) {
      print("--------------------------->Node: "+n.toString());
      if (node is Element) {
        visit(node,visitor);
      } else {
        if (node is ShadowRoot) {
          visit(node.host, visitor);
        } else {
          _visitNode(node, visitor);
        }
      }
    });
  }
  
  static void visit(Element parent, Visitor visitor) {
    
    //parent.childNodes.forEach(printNode);
    parent.nodes.forEach(new _ForEachVisitor(parent, visitor));
    
    var shadowRoot = parent.shadowRoot;
    if ((shadowRoot!=null) && (shadowRoot.nodes!=null)) {
      shadowRoot.nodes.forEach(new _ForEachVisitor(parent, visitor));
    }
  }
  
  static void visitAll(Element parent, NodeVisitor visitor) {
    visit(parent, new _NodeVisitorAsVisitor(visitor));
  }
  
}

