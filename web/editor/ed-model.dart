import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_slider.dart';
import 'package:paper_elements/paper_button.dart';
//import 'package:paper_elements/paper_fab.dart';
import 'package:core_elements/core_toolbar.dart';

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
          ..text='Some Text'
          ..nodes.add(
              new EdHeadLine()
              ..title='Sub'
              )
          )]);
}







@CustomTag('ed-headline')
class EdHeadline extends PolymerElement {
  @observable String xtitle;
  @observable int level;
  
  EdHeadline.created() : super.created();
  
  HtmlElement headline;
  void attached() {
    headline=$["h"];
    headline.contentEditable="true";
    headline.onBlur.listen(updateData);
  }
  
  void updateData(Event event) {
    xtitle=headline.innerHtml;
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
