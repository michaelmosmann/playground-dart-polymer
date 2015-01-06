import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_slider.dart';
import 'package:paper_elements/paper_button.dart';
//import 'package:paper_elements/paper_fab.dart';
import 'package:core_elements/core_toolbar.dart';

class Editable extends PolymerElement {
  Editable.created() : super.created();
  
  HtmlElement editable;
  
  void attached() {
    editable = $['editable'];
    editable.onClick.listen(enableEdit);
    editable.onBlur.listen(disableEdit);
    editable.onKeyDown.listen(processKeys);
  }  
  
  void processKeys(KeyboardEvent event) {
  }
  
  void enableEdit(event) {
    editable.contentEditable="true";
  }
  
  void disableEdit(event) {
    editable.contentEditable="false";
  }
}

@CustomTag('ed-p')
class EdPara extends Editable {
  EdPara.created() : super.created();
  
  @override
  void processKeys(KeyboardEvent event) {
    switch (event.keyCode) {
      case KeyCode.ENTER:
        if (!event.shiftKey) {
          //var headline = new Element.tag("ed-h");
          //this.parentNode.append(headline);
          event.stopPropagation();
          //headline.focus();
        }
        break;
    }
  }
}

@CustomTag('ed-h')
class EdHeadline extends Editable {
  EdHeadline.created() : super.created();
  
  @override
  void attached() {
    super.attached();
    
    editable.innerHtml="Headline";
  }

  @override
  void processKeys(KeyboardEvent event) {
    switch (event.keyCode) {
      case KeyCode.ENTER:
        editable.innerHtml="Foooo";
        event.stopPropagation();
        break;
    }
  }
  
}

@CustomTag('ed-doc')
class EdDoc extends PolymerElement {
  
  EdDoc.created() : super.created();

  /*
  void processKeys(KeyboardEvent event) {
    switch (event.keyCode) {
      case KeyCode.ENTER:
        editable.innerHtml="Foooo";
        event.stopPropagation();
        break;
    }
  }*/
  
}

@CustomTag('ed-rich')
class RichEditorText extends PolymerElement {
  @observable String text="RichText";
  
  RichEditorText.created() : super.created() {
  }
  
  DivElement editor;
  
  void attached() {
    editor = $['editor'];
    //editor.contentEditable="true";
    editor.onBlur.listen(postProcess);
    //textElem.onKeyDown.listen(keyHandler);
    //textElem.onKeyUp.forEach(listener);
  }
  
  void postProcess(e) {
    editor.contentEditable="false";
  }
  
  void keyHandler(KeyboardEvent e) {
    text=text+":Key";
  }
  
  void edit(KeyboardEvent ke,var data, Node parent) {
    if (KeyCode.isCharacterKey(ke.keyCode)) {
      String append=new String.fromCharCodes([ke.keyCode]);
      text=text+":"+append;
    }
  }  

  void clicked(MouseEvent e) {
    text="Maus";
    editor.contentEditable="true";
  }  
}
