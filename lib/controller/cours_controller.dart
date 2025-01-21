import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_storage/get_storage.dart';

class CoursController extends GetxController {
  RxString professorName = "".obs;
  final GetStorage storage = GetStorage();

  Rx<XFile?> image = Rx<XFile?>(null);
  Rx<String?> imagePath = Rx<String?>(null);
  final imagePicker = ImagePicker();
  @override
  void onInit() {
    super.onInit();
    // Load the image path from storage when the controller is initialized
    imagePath.value = storage.read('imagePath');
  }

  uploadImage() async {
    var pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      imagePath.value = pickedImage.path;
      storage.write('imagePath', pickedImage.path);
    } else {}
  }
}
