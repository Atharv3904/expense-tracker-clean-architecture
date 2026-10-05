import 'package:file_picker/file_picker.dart';

class UpdateProfileParams {
  final String name;
  final PlatformFile? avatar;

  const UpdateProfileParams({required this.name, this.avatar});
}
