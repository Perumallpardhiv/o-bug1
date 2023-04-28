class Responce {
  String? date;
  String? doctorName;
  String? description;

  Responce({this.date, this.doctorName, this.description});

  // Responce.fromJson(Map<String, dynamic> json) {
  //   date = json['date'];
  //   doctorName = json['doctorName'];
  //   description = json['description'];
  // }

  factory Responce.fromJson(Map<String, dynamic> json) => Responce(
        date: json["date"],
        doctorName: json["doctorName"],
        description: json["kids"],
      );
}
