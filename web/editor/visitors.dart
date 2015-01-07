library ed_visitors;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';

import 'optionals.dart';

typedef NodeVisitor(Element parent, Node n);

abstract class Visitor {
  Optional<Visitor> visit(Element parent, Node n);
}

class NodeVisitorAsVisitor extends Visitor {

  NodeVisitor visitor;
  
  NodeVisitorAsVisitor(this.visitor);
  
  @override
  Optional<Visitor> visit(Element parent, Node n) {
    visitor(parent,n);
    return new Optional(this);
  }
}

/*
abstract class Collector<T> {
  Optional<T> collect(PolymerElement parent, Node n);
}
*/

typedef Optional<T> Collector<T>(Element parent, Node n);

typedef List<T> CollectFunc<T>(Element parent, Collector<T> collector);

class CollectingVisitor<T> extends Visitor {
  
  Collector<T> collector;
  CollectingVisitor(this.collector);
  List<T> collection=[];
  
  @override
  Optional<Visitor> visit(Element parent, Node n) {
    Optional<T> result = collector(parent, n);
    if (result.isPresent) {
      collection.add(result.get());
    }
    return new Optional();
  }
  
  static List<dynamic> collect(Element parent, Collector<dynamic> collector) {
    CollectingVisitor<dynamic> visitor = new CollectingVisitor(collector);
    Visitors.visit(parent, visitor);
    return visitor.collection;
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
    visit(parent, new NodeVisitorAsVisitor(visitor));
  }
  
}

