// ignore_for_file: unnecessary_this, unnecessary_new, prefer_collection_literals

class Poll {
  String email = '';
  String theBest = '';
  String theWorst = '';
  String remarks = '';
  int qualification = 0;

  Poll({
    required this.email,
    required this.theBest,
    required this.theWorst,
    required this.remarks,
    required this.qualification,
  });

  Poll.fromJson(Map<String, dynamic> json) {
    if (json['email'] != null) {
      email = json['email'];
    }
    if (json['theBest'] != null) {
      theBest = json['theBest'];
    }
    if (json['theWorst'] != null) {
      theWorst = json['theWorst'];
    }
    if (json['remarks'] != null) {
      remarks = json['remarks'];
    }
    qualification = json['qualification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['theBest'] = this.theBest;
    data['theWorst'] = this.theWorst;
    data['remarks'] = this.remarks;
    data['qualification'] = this.qualification;
    return data;
  }
}
