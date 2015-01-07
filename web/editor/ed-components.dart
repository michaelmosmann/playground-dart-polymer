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

class _NodeVisitor extends Visitor {
  
  EdComponent componentParent;
  
  _NodeVisitor(this.componentParent);
  
  @override
  Optional<Visitor> visit(Element parent, Node n) {
    if (n is EdComponent) {
      EdComponent l=n;
      l.attachedTo(componentParent);
      //print("Node: "+parent.toString()+"->"+n.toString()+" matched");
      return new Optional(new _NodeVisitor(l));
    }
    if (n is Node) {
      return new Optional(new _NodeVisitor(componentParent));
    }
    //print("Missing: "+parent.toString()+"->"+n.toString()+" ?");
    return new Optional(new _NodeVisitor(componentParent));
  }
}

typedef void EdComponentVisitor(EdComponent component);

class _EdComponentVisitorAdapter extends Visitor {
  
  EdComponentVisitor visitor;
  
  _EdComponentVisitorAdapter(this.visitor);
  
  @override
  Optional<Visitor> visit(Element parent, Node n) {
    bool match=false;
    if (n is EdComponent) {
      EdComponent l=n;
      visitor(l);
      return new Optional<Visitor>();
      //l.visitChildren(visitor);
    }
    return new Optional<Visitor>(new _EdComponentVisitorAdapter(visitor));
  }
}

class EdComponent extends PolymerElement implements PolymerElementWithParent {
  
  static int counter=0;
  
  EdComponent.created() : super.created();
  String id=(counter++).toString();
 
  Optional<PolymerElement> _parent=new Optional();
  
  void attached() {
    super.attached();
    Optional<PolymerElement> guessedParent=_guessParent(this.parentNode);
    if (guessedParent.isPresent) {
      _parent=guessedParent;
    }
    print("attached: "+this.toString()+"("+this.runtimeType.toString()+") to parent: "+_parent.toString());
    //Visitors.visit(this, new _NodeVisitor(this));
  }
  
  static Optional<PolymerElement> _guessParent(Node parent) {
    if (parent!=null) {
      //print("try "+parent.runtimeType.toString());
      if (parent is ShadowRoot) {
        return _guessParent(parent.host);
      }
      if (parent is PolymerElement) {
        return new Optional(parent);
      }
      if (parent is Element) {
        if (parent.shadowRoot!=null) {
          return _guessParent(parent.shadowRoot.host);
        }
        return _guessParent(parent.parentNode);
      }
    }
    return new Optional();
  }

  @override
  void attachedTo(PolymerElement parent) {
    _parent=new Optional(parent);
    print("parent: "+_parent.toString()+" => "+this.toString());
  }
  
  void visitChildren(EdComponentVisitor visitor) {
    Visitors.visit(this, new _EdComponentVisitorAdapter(visitor));
  }

  String toString() {
    return super.toString()+"#"+id;
  }
  /*
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
   */

  @override
  Optional<PolymerElement> parentElement() {
    return _parent;
  }
}