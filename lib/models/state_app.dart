class StateApp{
  bool? stateApp;

  StateApp(this.stateApp);
  StateApp._({this.stateApp});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map["stateApp"] = stateApp;

    return map;
  }

  factory StateApp.fromJson(Map<String, dynamic> json) {
    return new StateApp._(
      stateApp: json['stateApp'],
    );
  }

  StateApp.fromObject(dynamic o){
    this.stateApp = o["stateApp"];
  }

  Map toJson() => {
        'stateApp': stateApp,
      };
}