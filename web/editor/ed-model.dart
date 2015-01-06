import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_slider.dart';
import 'package:paper_elements/paper_button.dart';
//import 'package:paper_elements/paper_fab.dart';
import 'package:core_elements/core_toolbar.dart';

import 'ed-events.dart';

abstract class EdNode extends Observable {
  @observable String type;
  
  EdNode(String type) {
    this.type=type;
  }
}

abstract class EdNodeWithChilds extends EdNode {
  @observable List<EdNode> nodes=toObservable([]);

  EdNodeWithChilds(String type) : super(type);  
}

class EdHeadLine extends EdNodeWithChilds {
  @observable String title="Headline";

  EdHeadLine() : super("headline");
}

class EdParagraph extends EdNodeWithChilds {
  @observable String text="Text";

  EdParagraph() : super("paragraph");
}

class EdDoc extends Observable {
  @observable String title="Title";
  
  @observable List<EdNode> nodes=toObservable([
    new EdHeadLine()
      ..title='Foo', 
    new EdHeadLine()
      ..title='Bar'
      ..nodes.add(
          new EdParagraph()
          ..text='Some Text\nfoo'
          ..nodes.add(
              new EdHeadLine()
              ..title='Sub'
              )
          )]);
}





@CustomTag('ed-paragraph')
class EdEditParagraph extends PolymerElement {
  @published String xtext;
  
  EdEditParagraph.created() : super.created();
  
  HtmlElement _para;
  
  void attached() {
    _para=$["p"];
    _para.contentEditable="true";
    EditEvents.editEventOnFocus("paragraph", _para, this);
    //_para.onFocus.listen(active);
    _para.onBlur.listen(updateData);
    _para.onKeyDown.listen(keyEvents);
    updateText();
  }

  void updateText() {
    _para.innerHtml=textAsHtml();
  }
  
  String textAsHtml() {
    return xtext.replaceAll("\n", "<br>");
  }
  
  void xtextChanged(String oldValue,String newValue) {
    updateText();
    //print('xtext: ${oldValue} -> ${newValue}');
    //print('stored: ${xtext}');
    
    //this.injectBoundHTML(xtext.replaceAll("\n", "<br>"), _para);
    
  }
  
  void updateData(Event event) {
    xtext=_para.innerHtml.replaceAll("<br>", "\n");
  }
  
  
  
  void keyEvents(KeyboardEvent event) {
    switch (event.keyCode) {
      case KeyCode.ENTER:
        if (event.shiftKey) {
          event.preventDefault();
          _para.blur();
        }
        break;
    }
  }

/*  
  void active(Event event) {
    print("active...");
    fire("edit", detail: { "type":"paragraph"}, canBubble: true, cancelable: true);
    //dispatchEvent(new CustomEvent("edit"));
  }
   */
}

@CustomTag('ed-headline')
class EdEditHeadLine extends PolymerElement {
  @observable String xtitle;
  @observable int level;
  
  EdEditHeadLine.created() : super.created();
  
  HtmlElement headline;
  void attached() {
    headline=$["h"];
    headline.contentEditable="true";
    headline.onBlur.listen(updateData);
    headline.onKeyDown.listen(keyEvents);
    
    EditEvents.editEventOnFocus("headline", headline, this);
  }
  
  void updateData(Event event) {
    xtitle=headline.innerHtml;
  }
  
  void keyEvents(KeyboardEvent event) {
    switch (event.keyCode) {
      case KeyCode.ENTER:
        event.preventDefault();
        //updateData(event);
        headline.blur();
        // focus next..
        break;
    }
  }
}

@CustomTag('ed-root')
class EdRoot extends PolymerElement {
  @observable EdDoc root;
  @published String mode;
  
  EdRoot.created() : super.created() {
    
  }
}

@CustomTag('ed-nodes')
class EdNodes extends PolymerElement {
  @observable EdNode root;
  @observable int level;
  
  EdNodes.created() : super.created() {
    
  }
}

@CustomTag('ed-view')
class EdView extends PolymerElement {
  @observable EdNode root;
  @observable int level;
  
  EdView.created() : super.created() {
    
  }
}

@CustomTag('ed-model')
class EdModel extends PolymerElement {
  @observable EdDoc doc=new EdDoc();
  
  EdModel.created() : super.created();
  
  void clicked(MouseEvent e, var data, Node parent) {
    doc.title="Clicked";
  }
}
