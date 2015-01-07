import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_slider.dart';
import 'package:paper_elements/paper_button.dart';
//import 'package:paper_elements/paper_fab.dart';
import 'package:core_elements/core_toolbar.dart';

import 'ed-events.dart';
import 'ed-types.dart';

@CustomTag('ed-toolbar')
class EdToolbar extends PolymerElement implements EditEventListener {
  @published bool hideA=true;
  @published bool hideB=false;
  
  @published bool headline=false;
  @published bool paragraph=false;
  
  EdToolbar.created() : super.created();
  
  @override
  void onEditEvents(Event e, var detail) {
    print("got: "+e.type+":"+detail.toString());
    String type=detail['type'];
    String action=detail['action'];
    TreeEditor source=detail['source'] as TreeEditor;
    
    paragraph=false;
    headline=false;
    
    switch (action) {
      case 'focus':
        switch (type) {
          case 'headline':
            headline=true;
            break;
          case 'paragraph':
            paragraph=true;
            break;
        }
        break;
      case 'blur':
        break;
    }
    
    hideA=!hideA;
    hideB=!hideB;
  }
}