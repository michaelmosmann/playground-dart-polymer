import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_slider.dart';
import 'package:paper_elements/paper_button.dart';
//import 'package:paper_elements/paper_fab.dart';
import 'package:core_elements/core_toolbar.dart';
import 'ed-events.dart' show EditEvents;
import 'ed-toolbar.dart' show EdToolbar;

@CustomTag('ed-main')
class Editor extends PolymerElement {
  @observable String title="Editor";
  
  Editor.created() : super.created();
  
  EdToolbar toolbar;
  
  void attached() {
    toolbar=$['toolbar'];
  }
  
  void menuAction(Event e, var detail, Node target) {
    
  }
  
  void moreAction(Event e, var detail, Node target) {
      
  }
  
  void onEditEvent(Event e, var detail, Node target) {
    print("..got in parent");
    EditEvents.toChildren(this, e, detail);
    //toolbar.onEditEvents(e,detail);
  }
  
}
