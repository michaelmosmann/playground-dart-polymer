library ed_components;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';

import 'ed-visitors.dart';

abstract class ParentPolymerListener {
  void attachedTo(PolymerElement parent);
}

class EdComponent extends PolymerElement implements ParentPolymerListener {
  
  EdComponent.created() : super.created();
 
  PolymerElement _parent;
  
  void attached() {
    Visitors.visit(this, (PolymerElement parent, Node n) {
      if (n is ParentPolymerListener) {
        ParentPolymerListener l=n;
        l.attachedTo(parent);
      }
    });
  }

  @override
  void attachedTo(PolymerElement parent) {
    _parent=parent;
    print("parent: "+_parent.toString());
  }
}