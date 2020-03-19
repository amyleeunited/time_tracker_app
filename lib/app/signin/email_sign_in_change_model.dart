import 'package:flutter/cupertino.dart';
import 'package:time_tracker_app/app/signin/email_sign_in_model.dart';
import 'package:time_tracker_app/app/signin/validator.dart';
import 'package:time_tracker_app/services/auth.dart';
import 'package:flutter/foundation.dart';

class EmailSignInChangeModel with ChangeNotifier, EmailPasswordStringValidator{
  EmailSignInChangeModel(
      {@required this.auth,
      this.email = '',
      this.password = '',
      this.formType = EmailSignInFormType.signIn,
      this.isLoading = false,
      this.submitted = false});

  final AuthBase auth;
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;

  Future<void> submit() async {
    updateWith(isLoading: true, submitted: true);
    try {
      if (formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmail(email, password);
      } else {
        await auth.createUserWithEmail(email, password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void toggleFormType() {
    final formType = this.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      submitted: false,
      isLoading: false,
      formType: formType,
    );
  }

  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
  }

  bool get canSubmit {
    bool submitEnabled = emailStringValidator.isValid(email) &&
        passwordStringValidator.isValid(password) &&
        !isLoading;
    return submitEnabled;
  }

  String get passwordErrorText {
    bool showTextError =
        submitted && !passwordStringValidator.isValid(password);
    return showTextError ? invalidPasswordErrorText : null;
  }

  String get emailErrorText {
    bool showTextError = submitted && !emailStringValidator.isValid(email);
    return showTextError ? invalidEmailErrorText : null;
  }
}
