/// Form validation helpers
/// Centralized validation rules for email, password, etc.
library;

/// Validation result - null means valid, string is error message
typedef ValidatorResult = String? Function(String?);

/// Email validation using regex
ValidatorResult emailValidator() {
  const pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  final regex = RegExp(pattern);
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập email';
    }
    if (!regex.hasMatch(value.trim())) {
      return 'Vui lòng nhập đúng định dạng email';
    }
    return null;
  };
}

/// Password validation - min length, optional requirements
ValidatorResult passwordValidator({int minLength = 6}) {
  return (value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length < minLength) {
      return 'Mật khẩu phải có ít nhất $minLength ký tự';
    }
    return null;
  };
}

/// Confirm password - must match
ValidatorResult confirmPasswordValidator(String Function() getPassword) {
  return (value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng xác nhận mật khẩu';
    }
    if (value != getPassword()) {
      return 'Mật khẩu không khớp';
    }
    return null;
  };
}

/// Full name validation
ValidatorResult fullNameValidator() {
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập họ tên';
    }
    if (value.trim().length < 2) {
      return 'Tên phải có ít nhất 2 ký tự';
    }
    return null;
  };
}

/// First name validation
ValidatorResult firstNameValidator() {
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập tên';
    }
    return null;
  };
}

/// Last name validation
ValidatorResult lastNameValidator() {
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập họ';
    }
    return null;
  };
}

/// Country validation
ValidatorResult countryValidator() {
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng chọn quốc gia';
    }
    return null;
  };
}
