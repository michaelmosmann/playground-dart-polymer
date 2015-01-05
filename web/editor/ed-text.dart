import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_slider.dart';
import 'package:paper_elements/paper_button.dart';
//import 'package:paper_elements/paper_fab.dart';
import 'package:core_elements/core_toolbar.dart';

@CustomTag('ed-text')
class EditorText extends PolymerElement {
  @observable String text="Fuuu";
  
  EditorText.created() : super.created() {
  }
  
  HtmlElement textElem;
  
  void attached() {
    textElem = $['text'];
    //textElem.onKeyDown.listen(keyHandler);
    //textElem.onKeyUp.forEach(listener);
  }
  
  void keyHandler(KeyboardEvent e) {
    text=text+":Key";
  }
  
  void edit(KeyboardEvent ke,var data, Node parent) {
    String append=new String.fromCharCodes([ke.keyCode]);
    text=text+":"+append;
  }  

  void clicked(MouseEvent e) {
    text="Maus";
  }  
  
  void onKeyUpX(ElementStream<KeyboardEvent> events) {
    
  }
}
