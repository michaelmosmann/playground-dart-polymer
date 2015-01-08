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

@CustomTag('ed-render-node')
class RenderNode extends PolymerElement {
  @observable EdNode root;
  @observable int level;
  
  RenderNode.created() : super.created();
}

@CustomTag('ed-render-root')
class RenderRoot extends PolymerElement {
  @observable EdDoc root;
  @observable int level;
  
  RenderRoot.created() : super.created();
}

@CustomTag('ed-render')
class Render extends PolymerElement {
  @observable EdDoc doc;//=new EdDoc();
  
  Render.created() : super.created();
  
}
