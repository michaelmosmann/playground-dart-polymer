import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_slider.dart';
import 'package:paper_elements/paper_button.dart';
//import 'package:paper_elements/paper_fab.dart';
import 'package:core_elements/core_toolbar.dart';

import 'ed-docs.dart';
import 'ed-events.dart';
import 'treecomponent.dart';
import 'optionals.dart';
import 'ed-types.dart';

@CustomTag('ed-render-paragraph')
class RenderParagraph extends PolymerElement {
  @observable String xtext;
  
  RenderParagraph.created() : super.created();
  
  ParagraphElement _para;
  void attached() {
    _para=$['p'] as ParagraphElement;
    
    changes.listen((List<ChangeRecord> changes) {
      for (ChangeRecord c in changes) {
        //print("Change "+c.toString());
        if (c is PropertyChangeRecord) {
          if (c.name==new Symbol('xtext')) {
            //print("Text changed to "+xtext);
            _para.innerHtml=xtext.replaceAll('\n', "<br>");
          }
        }
      }
    });
  }
  
}

@CustomTag('ed-render-node')
class RenderNode extends PolymerElement {
  @observable WithChilds p;
  @observable EdNode root;
  @observable int level;
  @observable String idx;
  @observable int numberOfType=-1;
  
  RenderNode.created() : super.created();
  
  void attached() {
    changes.listen((List<ChangeRecord> changes) {
          for (ChangeRecord c in changes) {
            //print("Change "+c.toString());
            if (c is PropertyChangeRecord) {
              if (c.name==new Symbol('root') || c.name==new Symbol('p')) {
                //print("Change calc numberOfType");
                numberOfType=_numberOfType();
              }
            }
          }
        });
  }
  int _numberOfType() {
    int ret=0;
    if (p!=null) {
      for (EdNode n in p.nodes) {
        //print(" "+n.runtimeType.toString()+"?"+root.runtimeType.toString());
        if (identical(n, root)) {
          break;
        }
        if (n.runtimeType==root.runtimeType) {
          ret++;
        }
      }
    }
    return ret;
  }
}

@CustomTag('ed-render-root')
class RenderRoot extends PolymerElement {
  @observable EdDoc root;
  @observable int level;
  
  RenderRoot.created() : super.created();
}

@CustomTag('ed-render')
class Render extends PolymerElement {
  @observable @published EdDoc doc;//=new EdDoc();
  
  Render.created() : super.created();
  
}
