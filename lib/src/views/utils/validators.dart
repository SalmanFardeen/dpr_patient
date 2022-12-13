final validator = _Validators();

class _Validators {

  String? nameValidator(val) {
    return val.isEmpty ? 'The field is required' : null;
  }

  String? dobValidator(val) {
    return val.isEmpty ? 'The field is required' : null;
  }

  String? relationValidator(val) {
    return val.isEmpty ? 'The field is required' : null;
  }

  String? uploadFileValidator(val) {
    return val.isEmpty ? 'The field is required' : null;
  }

  String? passwordValidator(val) {
    return val.length < 6 ? "Your password must contain at least 6 characters" : null;
  }

  String? phoneNoValidator(val) {
    return val.isEmpty ? 'The field is required' : RegExp(r"(01[3-9][0-9]{8})$").hasMatch(val) ? null : "Please enter a valid number";
  }

  String? emailValidator(val) {
    return val == "" ? null : RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : "Please enter a valid email";
  }

  String? ftValidator(val) {
    return val!.isEmpty
        ? null
        : (int.parse(
        val) > 10)
        ? 'ft <= 10'
        : null;
  }

  String? inchValidator(val) {
    return val!.isEmpty
        ? null
        : (int.parse(
        val) > 12)
        ? 'inch <= 12'
        : null;
  }

  String? weightValidator(val) {
    return val.isEmpty
        ? 'The field is empty'
        : (int.parse(val) > 500)
        ? 'W <= 500'
        : null;
  }
}