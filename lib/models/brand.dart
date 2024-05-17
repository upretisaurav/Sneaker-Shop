class Brand {
  // final String id;
  final int itemCount;
  final String logoGreyUrl;
  final String logoUrl;
  final String name;

  Brand({
    // required this.id,
    required this.itemCount,
    required this.logoGreyUrl,
    required this.logoUrl,
    required this.name,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      // id: json['id'],
      itemCount: json['item_count'],
      logoGreyUrl: json['logo_grey_url'],
      logoUrl: json['logo_url'],
      name: json['name'],
    );
  }
}
