library ed_docs;

import 'package:polymer/polymer.dart';

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
