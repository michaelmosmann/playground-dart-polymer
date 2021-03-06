library ed_docs;

import 'package:polymer/polymer.dart';
import 'optionals.dart';

abstract class WithChilds {
  
  List<EdNode> nodes;
  
  Optional<WithChilds> findParent(EdNode node) {
    for (EdNode n in nodes) {
      if (identical(n, node)) {
        return new Optional<WithChilds>(this);
      } else {
        var findInChilds = (n as WithChilds).findParent(node);
        if (findInChilds.isPresent) {
          return findInChilds;
        }
      }
    }
    return new Optional();
  }
  
  void add(EdNode node,{ EdNode relativeTo, bool before: false}) {
    assert(node!=null);
    
    if (relativeTo!=null) {
      int idx=nodes.indexOf(relativeTo);
      assert(idx!=-1);
      nodes.insert(before? idx : idx+1, node);
    } else {
      nodes.add(node);
    }
  }
}

abstract class EdNode extends Observable {
  @observable String type;
  
  EdNode(String type) {
    this.type=type;
  }
}

abstract class EdNodeWithChilds extends EdNode with WithChilds {
  @observable List<EdNode> nodes=toObservable([]);

  EdNodeWithChilds(String type) : super(type);  
  
  String toString() {
    return "EdNodeWithChilds(${nodes.toString()})";
  }
}

class EdHeadLine extends EdNodeWithChilds {
  @observable String title="Headline";

  EdHeadLine() : super("headline");
  
  String toString() {
    return "EdHeadLine(${title})";
  }

}

class EdParagraph extends EdNodeWithChilds {
  @observable String text="Text";

  EdParagraph() : super("paragraph");
}

class EdDoc extends Observable with WithChilds {
  @observable String title="Title";
  
  @observable List<EdNode> nodes=toObservable([
    new EdHeadLine()
      ..title='Start', 
    new EdHeadLine()
      ..title='Hilfe'
      ..nodes.add(
          new EdParagraph()
          ..text='Etwas Text mit Zeilenumbruch.\nUnd einer zweiten Zeile.')
      ..nodes.add(
            new EdHeadLine()
            ..title='Beispiel'
            )
      ]);
}


