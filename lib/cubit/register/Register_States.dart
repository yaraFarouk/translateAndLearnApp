class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class UpdatePassVisibility extends RegisterStates {}

class RegisterNewUserLoadingState extends RegisterStates {}

class RegisterNewUserSuccessState extends RegisterStates {}

class RegisterNewUserErrorState extends RegisterStates
{
  final String errorMessage;
  RegisterNewUserErrorState(this.errorMessage);
}

class LoginLoadingState extends RegisterStates {}

class LoginSuccessState extends RegisterStates {}

class LoginErrorState extends RegisterStates
{
  final String errorMessage;
  LoginErrorState(this.errorMessage);
}


class SaveDataSuccessState extends RegisterStates {}

class SaveDataErrorState extends RegisterStates {}