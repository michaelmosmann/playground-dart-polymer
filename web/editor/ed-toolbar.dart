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
import 'optionals.dart';
import 'treecomponent.dart';

@CustomTag('ed-toolbar-headline')
class EdToolbarHeadline extends TreeComponent {
  
  EdToolbarHeadline.created() : super.created();
  
  void newHeadline(Event e, var detail, Node target) {
    TreeEditor source=(parentElement().get() as EdToolbar).lastSource().get();
    fire("edit", detail: {"type" : "headline", "action": "new","source": source});

  }
  void newSubHeadline(Event e, var detail, Node target) {
    TreeEditor source=(parentElement().get() as EdToolbar).lastSource().get();
    fire("edit", detail: {"type" : "headline", "action": "newchild","source": source});

  }
  void newText(Event e, var detail, Node target) {
    TreeEditor source=(parentElement().get() as EdToolbar).lastSource().get();
    fire("edit", detail: {"type" : "headline", "action": "newtext","source": source});

  }
  void newTextAfter(Event e, var detail, Node target) {
    TreeEditor source=(parentElement().get() as EdToolbar).lastSource().get();
    fire("edit", detail: {"type" : "headline", "action": "newtextafter","source": source});

  }
}

@CustomTag('ed-toolbar-paragraph')
class EdParagraphHeadline extends TreeComponent {
  
  EdParagraphHeadline.created() : super.created();
  
  void newHeadline(Event e, var detail, Node target) {
    print("------------->new paragraph:");
    TreeEditor source=(parentElement().get() as EdToolbar).lastSource().get();
    fire("edit", detail: {"type" : "paragraph", "action": "new","source": source});

  }
  void newSubHeadline(Event e, var detail, Node target) {
    print("------------->new sub paragraph:");
    TreeEditor source=(parentElement().get() as EdToolbar).lastSource().get();
    fire("edit", detail: {"type" : "paragraph", "action": "newchild","source": source});

  }
  void newText(Event e, var detail, Node target) {
    print("------------->new sub paragraph:");
    TreeEditor source=(parentElement().get() as EdToolbar).lastSource().get();
    fire("edit", detail: {"type" : "paragraph", "action": "newtext","source": source});

  }
}

@CustomTag('ed-toolbar')
class EdToolbar extends TreeComponent implements EditEventListener {
  @published bool hideA=true;
  @published bool hideB=false;
  
  @published bool headline=false;
  @published bool paragraph=false;
  
  EdToolbar.created() : super.created();
  Optional<TreeEditor> _lastSource=new Optional();
  
  
  Optional<TreeEditor> lastSource() {
    return _lastSource;
  }
  
  @override
  void onEditEvents(Event e, var detail) {
    print("got: "+e.type+":"+detail.toString());
    String type=detail['type'];
    String action=detail['action'];
    TreeEditor source=detail['source'] as TreeEditor;
    
    
    switch (action) {
      case 'focus':
        paragraph=false;
        headline=false;
        _lastSource=new Optional(source);    
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