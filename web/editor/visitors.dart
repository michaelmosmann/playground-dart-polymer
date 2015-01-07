library ed_visitors;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';

import 'optionals.dart';

typedef NodeVisitor(PolymerElement parent, Node n);

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

/*
abstract class Collector<T> {
  Optional<T> collect(PolymerElement parent, Node n);
}
*/

typedef Optional<T> Collector<T>(PolymerElement parent, Node n);

typedef List<T> CollectFunc<T>(PolymerElement parent, Collector<T> collector);

class CollectingVisitor<T> extends Visitor {
  
  Collector<T> collector;
  CollectingVisitor(this.collector);
  List<T> collection=[];
  
  @override
  Optional<Visitor> visit(PolymerElement parent, Node n) {
    Optional<T> result = collector(parent, n);
    if (result.isPresent) {
      collection.add(result.get());
    }
    return new Optional();
  }
  
  static List<dynamic> collect(PolymerElement parent, Collector<dynamic> collector) {
    CollectingVisitor<dynamic> visitor = new CollectingVisitor(collector);
    Visitors.visit(parent, visitor);
    return visitor.collection;
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
      } else {
      }
    });
  }
  
  static void visitAll(PolymerElement parent, NodeVisitor visitor) {
    visit(parent, new NodeVisitorAsVisitor(visitor));
  }
  
}

