library ed_components;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';

import 'visitors.dart';
import 'optionals.dart';

abstract class PolymerElementWithParent {
  void attachedTo(PolymerElement parent);
  Optional<PolymerElement> parentElement();
}

class NodeVisitor extends Visitor {
  
  @override
  Optional<Visitor> visit(PolymerElement parent, Node n) {
    bool match=false;
    if (n is PolymerElementWithParent) {
      PolymerElementWithParent l=n as PolymerElementWithParent;
      l.attachedTo(parent);
      //print("Node: "+parent.toString()+"->"+n.toString()+" matched");
      match=true;
    }
    if (n is PolymerElement) {
      return new Optional(this);
    }
    if (!match) {
      //print("Node: "+parent.toString()+"->"+n.toString()+" not matched");
    }
    return new Optional<Visitor>();
  }
}

class EdComponent extends PolymerElement implements PolymerElementWithParent {
  
  EdComponent.created() : super.created();
 
  Optional<PolymerElement> _parent;
  
  void attached() {
    Visitors.visit(this, new NodeVisitor());
  }

  @override
  void attachedTo(PolymerElement parent) {
    _parent=new Optional(parent);
    print("parent: "+_parent.toString());
  }
  
  Optional<EdComponent> nextComponent() {
    if (_parent.isPresent) {
      var parentElement = _parent.get();
      
      List<EdComponent> result = CollectingVisitor.collect(parentElement, (PolymerElement parent, Node n) {
        if (n is EdComponent) {
          return new Optional(n);
        }
        return new Optional();
      });
      
      int idx=result.indexOf(this);
      print("Parent List: "+result.toString()+" -> "+idx.toString());
      if ((idx!=-1) && ((idx+1)<result.length)) {
        return new Optional(result[idx+1]);
      }
      
      if (parentElement is EdComponent) {
        parentElement.nextComponent();
      }
    }
    return new Optional();
  }

  @override
  Optional<PolymerElement> parentElement() {
    return _parent;
  }
}