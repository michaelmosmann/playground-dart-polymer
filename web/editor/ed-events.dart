library ed_events;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';

import 'visitors.dart';
import 'ed-types.dart';

class EditEvents {
  static void focusEvents(HtmlElement element, TreeEditor source) {
    //element.onFocus.listen(new EditEventWrapper(type, sender).action);
    element.onFocus.listen((Event e) {
      print("..activate");
      source.editorFocused();
    });
    element.onBlur.listen((Event e) {
      print("..deactivate");
      source.editorBlured();
    });
  }
  
  static void toChildren(Element parent, Event event, var detail) {
    //parent.childNodes.forEach(printNode);
    Visitors.visitAll(parent, (Element parent, Node node) {
      if (node is EditEventListener) {
        EditEventListener l=node as EditEventListener;
        l.onEditEvents(event, detail);
      }
    });
    
    /*
    parent.shadowRoot.nodes.forEach((e) {
      if (e is EditEventListener) {
        EditEventListener l=e;
        l.onEditEvents(event, detail);
      }
      if (e is PolymerElement) {
        PolymerElement pe=e;
        toChildren(pe, event, detail);
      }
    });
    */
    
    /*
    parent.childNodes.where((e) => e is EditEventListener).forEach((e) {
      EditEventListener l=e;
      l.onEditEvents(event, detail);
    });
    * */
    
/*    
    var nodes = (parent.shadowRoot.querySelector('content') as ContentElement).getDistributedNodes();
    var myElement = nodes.where((e) => e is EditEventListener).forEach((e) {
      EditEventListener l=e;
      l.onEditEvents(event, detail);
    });
    * 
     */
  }

  static printNode(var n) {
    print("Node: "+n.toString());
  }
}

abstract class EditEventListener {
  void onEditEvents(Event e, var detail);
}

/*
class EditEventWrapper {
  
  String type;
  PolymerElement sender;
  
  EditEventWrapper(String type, PolymerElement sender) {
    this.type=type;
    this.sender=sender;
  }
  
  void action(Event e) {
    print("..activate");
    sender.fire("edit",detail: {"type":type});
  }
}
*/