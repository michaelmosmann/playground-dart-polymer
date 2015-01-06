library ed_events;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';

class EditEvents {
  static void editEventOnFocus(String type, HtmlElement element, PolymerElement sender) {
    //element.onFocus.listen(new EditEventWrapper(type, sender).action);
    element.onFocus.listen((Event e) {
      print("..activate");
      sender.fire("edit",detail: {"type":type});
    });
  }
  
  static void toChildren(PolymerElement parent, Event event, var detail) {
    //parent.childNodes.forEach(printNode);
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
    
    parent.childNodes.where((e) => e is EditEventListener).forEach((e) {
      EditEventListener l=e;
      l.onEditEvents(event, detail);
    });
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