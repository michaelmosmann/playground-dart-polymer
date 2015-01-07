library ed_components;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';

import 'visitors.dart';
import 'optionals.dart';

abstract class ParentPolymerListener {
  void attachedTo(PolymerElement parent);
}

class NodeVisitor extends Visitor {
  
  @override
  Optional<Visitor> visit(PolymerElement parent, Node n) {
    if (n is ParentPolymerListener) {
      ParentPolymerListener l=n;
      l.attachedTo(parent);
    }
    return new Optional<Visitor>();
  }
}

class EdComponent extends PolymerElement implements ParentPolymerListener {
  
  EdComponent.created() : super.created();
 
  PolymerElement _parent;
  
  void attached() {
    Visitors.visit(this, new NodeVisitor());
  }

  @override
  void attachedTo(PolymerElement parent) {
    _parent=parent;
    print("parent: "+_parent.toString());
  }
}