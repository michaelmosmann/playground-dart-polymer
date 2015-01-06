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

abstract class EdEdit extends PolymerElement {
  
  String editorType;
  String editableId;
  
  EdEdit.created(String editorType, String editableId) : super.created() {
    this.editorType=editorType;
    this.editableId=editableId;
  }
  
  HtmlElement _editable;
  
  void attached() {
    _editable=$[editableId];
    
    _editable.contentEditable="true";
    //_para.onFocus.listen(active);
    _editable.onBlur.listen((Event e) {
      processInnerHtml(e, _editable.innerHtml);
    });
    _editable.onKeyDown.listen(keyEvents);
    EditEvents.editEventOnFocus(editorType, _editable, this);
    renderContent();
  }
  
  void renderContent() {
    _editable.innerHtml=formatedContent();
  }
  
  String formatedContent();
  
  void processInnerHtml(Event e, String innerHtml);
  
  void keyEvents(KeyboardEvent event);
  
  void focusNext() {
    _editable.blur();
    
    print("ShadowRoot: "+this.shadowRoot.toString());
    print("Parent: "+this.shadowRoot.parent.toString());
    print("ParentNode: "+this.shadowRoot.parentNode.toString());
    print("2.Parent: "+this.parent.toString());
    print("2.ParentNode: "+this.parentNode.toString());
    
    print("Children: "+this.shadowRoot.children.toString());
  }
  
}

@CustomTag('ed-paragraph')
class EditParagraph extends EdEdit {
  @published String xtext;

  EditParagraph.created() : super.created("paragraph", "p");
  

  @override
  void keyEvents(KeyboardEvent event) {
    switch (event.keyCode) {
      case KeyCode.ENTER:
        if (event.shiftKey) {
          event.preventDefault();
          //_editable.blur();
          focusNext();
        }
        break;
    }
  }

  @override
  void processInnerHtml(Event e, String innerHtml) {
    xtext=innerHtml.replaceAll("<br>", "\n");
  }
  
  @override
  String formatedContent() {
    return xtext.replaceAll("\n", "<br>");
  }
  
  void xtextChanged(String oldValue,String newValue) {
    renderContent();
  }
}

//@CustomTag('ed-paragraph')
/*
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
}
*/

@CustomTag('ed-headline')
class EditHeadLine extends EdEdit {
  @observable String xtitle;
  @observable int level;
  
  EditHeadLine.created() : super.created("headline", "h");

  
  @override
  String formatedContent() {
    return xtitle;
  }

  @override
  void keyEvents(KeyboardEvent event) {
    switch (event.keyCode) {
      case KeyCode.ENTER:
        event.preventDefault();
        //updateData(event);
        //_editable.blur();
        focusNext();
        // focus next..
        break;
    }
  }

  @override
  void processInnerHtml(Event e, String innerHtml) {
    xtitle=innerHtml;
  }
}

/*
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
*/

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
