class Detail {
  final String detail;
  final String reference;

  Detail(this.detail, this.reference);
  factory Detail.fromMap(Map<String, dynamic> map) {
    return Detail(
      map['detail'] ?? '',
      map['reference'] ?? '',
    );
  }
}
