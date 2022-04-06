class HospitalHit {
  final String userName;
  final String userEmail;
  final String registerOnce;
  final String walletAddress;


  HospitalHit({
    required this.userName,required this.userEmail,required this.registerOnce, required this.walletAddress});

  static HospitalHit fromJson(Map json) {
    print(json);
    return HospitalHit(userName:json['userName'].toString(),userEmail: json['userEmail'].toString(),registerOnce: json['registerOnce'].toString(),walletAddress: json['walletAddress'].toString());
  }

  static List<HospitalHit>? fromJsonList(List list) {
    if (list.isEmpty == true) return null;
    return list.map((item) => HospitalHit.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${userName} ${walletAddress}';
  }

  // ///this method will prevent the override of toString
  // bool userFilterByCreationDate(String filter) {
  //   return this?.createdAt?.toString()?.contains(filter);
  // }

  // ///custom comparing function to check if two users are equal
  // bool isEqual(HospitalHit model) {
  //   return this?.walletAddress == model?.walletAddress;
  // }

  @override
  String toString() => walletAddress;
}