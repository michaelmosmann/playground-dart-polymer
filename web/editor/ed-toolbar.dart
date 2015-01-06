import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_slider.dart';
import 'package:paper_elements/paper_button.dart';
//import 'package:paper_elements/paper_fab.dart';
import 'package:core_elements/core_toolbar.dart';

import 'ed-events.dart';

@CustomTag('ed-toolbar')
class EdToolbar extends PolymerElement implements EditEventListener {
  @published bool hideA=true;
  @published bool hideB=false;
  
  @published bool headline=false;
  @published bool paragraph=false;
  
  EdToolbar.created() : super.created();
  
  @override
  void onEditEvents(Event e, var detail) {
    print("got: "+detail.toString());
    String type=detail['type'];
    
    paragraph=false;
    headline=false;
    switch (type) {
      case 'headline':
        headline=true;
        break;
      case 'paragraph':
        paragraph=true;
        break;
    }
    
    hideA=!hideA;
    hideB=!hideB;
  }
}