class ImageItem {
  final String link;

  ImageItem(
    this.link,
  );

  ImageItem.fromJson(Map<String, dynamic> json)
      : link = json["link"];
}
