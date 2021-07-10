import 'package:flutter_zalo_bloc/profile/models/image.dart';

class ImageResponse {
  final List<ImageItem> images;
  final String error;

  ImageResponse(this.images, this.error);

  ImageResponse.fromJson(Map<String, dynamic> json)
      : images = (json["data"]["images"] as List)
            .map((i) => new ImageItem.fromJson(i))
            .toList(),
        error = "";

  ImageResponse.withError(String errorValue)
      : images = [],
        error = errorValue;
}
