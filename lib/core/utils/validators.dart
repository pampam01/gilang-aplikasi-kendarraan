class Validators {
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Input'} tidak boleh kosong';
    }
    return null;
  }

  static String? number(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Input'} tidak boleh kosong';
    }
    if (num.tryParse(value) == null) {
      return '${fieldName ?? 'Input'} harus berupa angka';
    }
    return null;
  }
}
