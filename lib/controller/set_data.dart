import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MetadataController extends GetxController {
  RxMap metadata = {}.obs;

  void setMetadata({
    String? title,
 
    String? imageUrl,
    String? url,
  }) {
    metadata.value = {
      'title': title,

      'imageUrl': imageUrl,
      'url': url,
    };

    // Save metadata to local storage
    GetStorage().write('mapList', metadata.value);
  }

  @override
  void onInit() {
    // Read metadata from local storage on initialization
    metadata.value = GetStorage().read('mapList') ?? {};
    super.onInit();
  }
}