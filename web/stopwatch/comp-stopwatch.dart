import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_slider.dart';
import 'package:paper_elements/paper_button.dart';
//import 'package:paper_elements/paper_fab.dart';

@CustomTag('comp-stopwatch')
class CompStopWatch extends PolymerElement {
  @observable String counter = '00:00';
  @observable Map<String, String> data=toObservable({
    'inc':'1000'
  });
  
  CompStopWatch.created() : super.created();
  
  Stopwatch mywatch = new Stopwatch();
  Timer mytimer;
  
  PaperButton stopButton;
  PaperButton startButton;
  PaperButton resetButton;
  
  PaperSlider rangeSlider;
    
  void attached() {
    super.attached();
    startButton = $['startButton'];
    stopButton = $['stopButton'];
    resetButton = $['resetButton'];
    
    //startButton.raisedButton=true;
    
    stopButton.disabled = true;
    resetButton.disabled = true;
    
    rangeSlider = $['range'];
    rangeSlider.min=10;
    rangeSlider.max=1000;
    rangeSlider.step=5;
  }
  
  @override
  void detached() {
    super.detached();
    mytimer.cancel();
  }
  
  void start(Event e, var detail, Node target) {
    mywatch.start();
    var duration = new Duration(seconds:1);
    mytimer = new Timer.periodic(duration, updateTime);
    startButton.disabled = true;
    stopButton.disabled = false;
    resetButton.disabled = true;
  }
  
  void stop(Event e, var detail, Node target) {
    mywatch.stop();
    mytimer.cancel();
    startButton.disabled = false;
    resetButton.disabled = false;
    stopButton.disabled = true;
  }
  
  void reset(Event e, var detail, Node target) {
    mywatch.reset();
    counter = '00:00';
    resetButton.disabled = true;
  }
  
  void updateTime(Timer _) {
    var s = mywatch.elapsedMilliseconds~/1000;
    var m = 0;
    
    // The operator ~/ divides and returns an integer.
    if (s >= 60) { m = s ~/ 60; s = s % 60; }
      
    String minute = (m <= 9) ? '0$m' : '$m';
    String second = (s <= 9) ? '0$s' : '$s';
    counter = '$minute:$second';
  }
}