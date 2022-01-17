class CountryCodes {
  String? entity;
  String? gec;
  String? isoCode1;
  String? isoCode2;
  String? isoCode3;
  String? stanagCode;
  String? internetCode;

  CountryCodes(
      {this.entity,
      this.gec,
      this.isoCode1,
      this.isoCode2,
      this.isoCode3,
      this.stanagCode,
      this.internetCode});

  CountryCodes.fromJson(Map<String, dynamic> json) {
    entity = json["entity"];
    gec = json["gec"];
    isoCode1 = json["iso_code_1"];
    isoCode2 = json["iso_code_2"];
    isoCode3 = json["iso_code_3"];
    stanagCode = json["stanag_code"];
    internetCode = json["internet_code"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["entity"] = entity;
    data["gec"] = gec;
    data["iso_code_1"] = isoCode1;
    data["iso_code_2"] = isoCode2;
    data["iso_code_3"] = isoCode3;
    data["stanag_code"] = stanagCode;
    data["internet_code"] = internetCode;
    return data;
  }
}
