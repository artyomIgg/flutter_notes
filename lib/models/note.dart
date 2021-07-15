class Note{
  String? title;
  String? content;
  String? date;

  Note(this.title, this.content);
  Note.withDate(this.title, this.content, this.date);
  Note._({this.title, this.content, this.date});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map["title"] = title;
    map["content"] = content;
    map["date"] = date;

    return map;
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return new Note._(
      title: json['title'],
      content: json['content'],
      date: json['date'],
    );
  }

  Note.fromObject(dynamic o){
    this.title = o["title"];
    this.content = o["content"];
    this.date = o["date"];
  }

  Map toJson() => {
        'title': title,
        'content': content,
        'date': date,
      };
}