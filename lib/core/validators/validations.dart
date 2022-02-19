import 'validator.dart';

class Validations {
  static CustomValidator isEmpty(String fieldName, [String? customMessage]) =>
      CustomValidator(
        errorText: customMessage ?? 'O $fieldName não pode ser vazio',
        showTextError: (value) {
          if (value.isEmpty) {
            return true;
          }
          return false;
        },
      );
}
