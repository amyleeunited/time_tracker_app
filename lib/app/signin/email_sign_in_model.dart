
import 'package:time_tracker_app/app/signin/validator.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModel with EmailPasswordStringValidator{
  EmailSignInModel(
      {this.email = '',
      this.password = '',
      this.formType = EmailSignInFormType.signIn,
      this.isLoading = false,
      this.submitted = false});

  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool isLoading;
  final bool submitted;

  EmailSignInModel copyWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }){
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );

  }

  String get primaryButtonText{
    return formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
  }

  String get secondaryButtonText{
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

  String get passwordErrorText{
    bool showTextError = submitted && !passwordStringValidator.isValid(password);
    return showTextError ? invalidPasswordErrorText : null;
  }

  String get emailErrorText{
    bool showTextError = submitted && !emailStringValidator.isValid(email);
    return showTextError ? invalidEmailErrorText : null;
  }
}
