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

abstract class EdEdit extends TreeComponent implements TreeEditor,EditEventListener {
  
  String editorType;
  String editableId;
  
  EdEdit.created(String editorType, String editableId) : super.created() {
    this.editorType=editorType;
    this.editableId=editableId;
  }
  
  HtmlElement _editable;
  
  @override
  void attached() {
    super.attached();
    _editable=$[editableId];
    
    _editable.contentEditable="true";
    //_para.onFocus.listen(active);
    _editable.onBlur.listen((Event e) {
      processInnerHtml(e, _editable.innerHtml);
    });
    _editable.onKeyDown.listen(keyEvents);
    EditEvents.focusEvents(_editable, this);
    renderContent();
  }
  
  void editorFocused() {
    fire("edit", detail: {"type" : editorType, "action": "focus", "source" : this});
  }
  
  void editorBlured() {
    fire("edit", detail: {"type" : editorType, "action": "blur", "source" : this});
  }
  
  void renderContent() {
    _editable.innerHtml=formatedContent();
  }
  
  String formatedContent();
  
  void processInnerHtml(Event e, String innerHtml);
  
  void keyEvents(KeyboardEvent event);
  
  @override
  void onEditEvents(Event e, var detail) {
    if ((detail['type']==editorType) && (identical(detail['source'],this))) {
      print("got..."+e.toString()+":"+detail.toString());
      onEditAction(detail['action']);
    }
  }
  
  void onEditAction(String action) {
  }
  
  void focusThis() {
    print("focusThis: "+this.toString());
    _editable.focus();
  }
  
  void focusNext() {
    _editable.blur();
    
    if (parentElement().isPresent) {
      _focusNextAfter(parentElement().get(), new Optional(this),false);
    }
  }

  static bool _focusFirstChild(TreeComponent parent) {
    print(label(parent)+"focus first");
    bool focusFound=false;
    parent.visitChildren((TreeComponent e) {
      if (!focusFound) {
        if (e is EdEdit) {
          print(label(parent,e)+"focus this");
          e.focusThis();
          focusFound=true;
        } else {
          print(label(parent,e)+"focus first child");
          focusFound=_focusFirstChild(e);
        }}
    });
    return focusFound;
  }
  
  static bool _focusNextAfter(TreeComponent parent, Optional<TreeComponent> current, bool up) {
    bool foundThis=!current.isPresent;
    bool focusFound=false;
    
    print(label(parent)+" with "+current.toString());
    
    parent.visitChildren((TreeComponent e) {
      if (!focusFound) {
        print(label(parent,e)+"visit");
        if (foundThis) {
          if (e is EdEdit) {
            print(label(parent,e)+"focus this");
            e.focusThis();
            focusFound=true;
          } else {
            print(label(parent,e)+"focus first child after thi");
            focusFound=_focusFirstChild(e);
          }
        }
        if (current.isPresent && identical(e,current.get())) {
          print(label(parent,e)+"found this");
          foundThis=true;
          if (!up) {
            print(label(parent,e)+"focus first child of this");
            focusFound=_focusFirstChild(e);
          }
        }
      }
    });
    
    if (!focusFound) {
      Optional<TreeComponent> parentOfParent = parent.parentElement();
      if ((parentOfParent.isPresent) && (parentOfParent.get() is TreeComponent)) {
        print(label(parent)+"focus first child of parent.parent");
        focusFound=_focusNextAfter(parentOfParent.get(),new Optional(parent),true);
      }
    }
    
    return focusFound;
  }
  
  static String label(TreeComponent parent, [TreeComponent e]) {
    if (e!=null) {
      return "Search["+parent.toString()+"=>"+e.toString()+"]:";
    }
    return "Search["+parent.toString()+"]:";
  }
}

@CustomTag('ed-paragraph')
class EditParagraph extends EdEdit {
  @observable EdDoc doc;
  @observable EdNode root;
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
  
  void onEditAction(String action) {
    print("Action: "+action+" on "+this.toString());
    
    if (action=='new') {
      var parentDocNode = doc.findParent(root);
      if (parentDocNode.isPresent) {
        parentDocNode.get().add(new EdHeadLine()..title='Kapitel',relativeTo:root);
      } else {
        print("Could not find this element in Doc");
      }
    }
    if (action=='newtext') {
      var parentDocNode = doc.findParent(root);
      if (parentDocNode.isPresent) {
        parentDocNode.get().add(new EdParagraph()..text='...',relativeTo:root);
      } else {
        print("Could not find this element in Doc");
      }
    }
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
  @observable EdDoc doc;
  @observable EdNodeWithChilds root;
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
  
  void onEditAction(String action) {
    print("Action: "+action+" on "+this.toString());

    if (action=='new') {
      var parentDocNode = doc.findParent(root);
      if (parentDocNode.isPresent) {
        parentDocNode.get().add(new EdHeadLine()..title='Kapitel',relativeTo:root);
      } else {
        print("Could not find this element in Doc");
      }
    }
    if (action=='newchild') {
      root.nodes.add(new EdHeadLine()..title='Unterkapitel');
    }
    if (action=='newtext') {
      root.nodes.add(new EdParagraph()..text='...');
    }
    if (action=='newtextafter') {
      var parentDocNode = doc.findParent(root);
      if (parentDocNode.isPresent) {
        parentDocNode.get().add(new EdParagraph()..text='...',relativeTo:root);
      } else {
        print("Could not find this element in Doc");
      }
    }
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
class EdRoot extends TreeComponent {
  @observable EdDoc root;
  @published String mode;
  
  EdRoot.created() : super.created();

}

@CustomTag('ed-nodes')
class EdNodes extends TreeComponent {
  @observable EdDoc doc;
  @observable EdNode root;
  @observable int level;
  
  EdNodes.created() : super.created();

}

@CustomTag('ed-view')
class EdView extends PolymerElement {
  @observable EdNode root;
  @observable int level;
  
  EdView.created() : super.created();
}

@CustomTag('ed-model')
class EdModel extends TreeComponent {
  @observable EdDoc doc;//=new EdDoc();
  
  EdModel.created() : super.created();
  
  void clicked(MouseEvent e, var data, Node parent) {
    doc.title="Clicked";
  }
  
}
