class VetRequest {
  String id;
  String requesertUid;
  String vetUid;
  String reason;
  String status;
  String createAt;

  VetRequest(
    this.id,
    this.requesertUid,
    this.vetUid,
    this.reason,
    this.status,
    this.createAt,
  );

  VetRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    requesertUid = json['requesertUid'];
    vetUid = json['vetUid'];
    reason = json['reason'];
    status = json['status'];
    createAt = json['createAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['requesertUid'] = this.requesertUid;
    data['vetUid'] = this.vetUid;
    data['reason'] = this.reason;
    data['status'] = this.status;
    data['createAt'] = this.createAt;
    return data;
  }
}
