import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sevenclass/bloc/auth/bloc.dart';
import 'package:sevenclass/helpers/app_color.dart';
import 'package:sevenclass/helpers/constant_helper.dart';
import 'package:sevenclass/widgets/base/app_alert_dialog.dart';
import 'package:sevenclass/widgets/base/button.dart';
import 'package:sevenclass/widgets/base/toast.dart';

class RegisterModule extends StatefulWidget {
  Function onLoginClick;

  RegisterModule({this.onLoginClick});

  @override
  _RegisterModuleState createState() => _RegisterModuleState();
}

class _RegisterModuleState extends State<RegisterModule> {
  AuthBloc _authBloc;

  GlobalKey<FormState> _registerFormState = GlobalKey();
  TextEditingController _nameTEC = new TextEditingController();
  TextEditingController _emailTEC = new TextEditingController();
  TextEditingController _passwordTEC = new TextEditingController();

  _doRegister() {
    _registerFormState.currentState.save();
    bool valid = _registerFormState.currentState.validate();
    _authBloc.add(AutoValidateOnEvent());

    if (!valid) {
      return false;
    }

    String email = _emailTEC.text;
    String password = _passwordTEC.text;
    String fullName = _nameTEC.text;

    _authBloc.add(DoRegisterEvent(
        email: email,
        password: password,
        fullName: fullName
    ));
  }

  @override
  Widget build(BuildContext context) {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    double _screenHeight = MediaQuery.of(context).size.height;

    return BlocListener(
      bloc: _authBloc,
      listener: (context, state) {
        if (state is RegisterResultState) {
          AppAlertDialog(
            title: 'Register',
            message: 'Registration successful',
            rightButtonText: 'Login',
            onRightButtonClick: () => Navigator.of(context).pop(),
          ).show(context);
        } else if (state is RegisterFailedState) {
          showToast(state.message);
        }
      },
      child: BlocBuilder(
        bloc: _authBloc,
        builder: (context, state) => _registerWidget()
      ),
    );
  }

  Widget _registerWidget() {
    return Container(
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Selamat Datang,',
            style: TextStyle(
              fontFamily: ConstantHelper.PRIMARY_FONT,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryColor,
              fontSize: 24,
            ),
          ),
          Text(
            'Buat akunmu sekarang!',
            style: TextStyle(
              fontFamily: ConstantHelper.SECONDARY_FONT,
              fontWeight: FontWeight.w500,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 24),
          Form(
            key: _registerFormState,
            child: Column(children: <Widget>[
              TextFormField(
                controller: _nameTEC,
                autovalidate: _authBloc.isRegisterAutoValidateOn,
                enabled: !_authBloc.isLoginLoading,
                decoration: InputDecoration(
                  labelText: "Nama Lengkap"
                ),
                validator: (value) {
                  if (value == "") {
                    return 'Masukkan nama lengkap';
                  }

                  return null;
                }
              ),
              SizedBox(height: 18),
              TextFormField(
                controller: _emailTEC,
                autovalidate: _authBloc.isRegisterAutoValidateOn,
                enabled: !_authBloc.isLoginLoading,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  suffix: _authBloc.isEmailAlreadyRegistered ?
                  Icon(Icons.close, color: Colors.red) : null
                ),
                onChanged: (value) {
                  if (_authBloc.isEmailAlreadyRegistered) {
                    _authBloc.add(ToggleEmailRegisteredEvent());
                  }
                },
                validator: validateEmail,
              ),
              SizedBox(height: 18),
              TextFormField(
                controller: _passwordTEC,
                autovalidate: _authBloc.isRegisterAutoValidateOn,
                keyboardType: TextInputType.text,
                obscureText: _authBloc.registerPasswordObscure,
                enabled: !_authBloc.isLoginLoading,
                decoration: InputDecoration(
                  labelText: "Kata Sandi",
                  suffixIcon: IconButton(
                      icon: Icon(!_authBloc.registerPasswordObscure
                          ? Icons.visibility
                          : Icons.visibility_off
                      ),
                      onPressed: () {
                        _authBloc.add(RegisterPasswordObscureEvent());
                      }
                  ),
                ),
                validator: (value) {
                  if (value == "") {
                    return 'Masukkan kata sandi';
                  } else if (value.length < 8) {
                    return "Kata sandi kurang dari 8 karakter";
                  }

                  return null;
                }
              ),
              SizedBox(height: 32),
              Container(
                width: double.infinity,
                child: Button(
                  style: ButtonStyle.PRIMARY,
                  text: _authBloc.isRegisterLoading ? 'Please wait...' : 'Daftar',
                  onTap: !_authBloc.isRegisterLoading ? () => _doRegister() : null,
                )
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Email anda sudah terdaftar ?',
                      style: TextStyle(
                        fontFamily: ConstantHelper.SECONDARY_FONT,
                        fontSize: 15
                      ),
                    ),
                    InkWell(
                      onTap: widget.onLoginClick,
                      child: Text(
                        ' Masuk disini',
                        style: TextStyle(
                          fontFamily: ConstantHelper.SECONDARY_FONT,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                        ),
                      ),
                    )
                  ],
                ))
            ]),
          ),
        ],
      ),
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty)
      return 'Email Tidak Boleh Kosong';
    else if (!regex.hasMatch(value))
      return 'Masukkan Email yang valid';
    else if (_authBloc.isEmailAlreadyRegistered)
      return "Email already registered";
    else if (value == _authBloc.previousRegisteredEmail)
      return "Email already registered";
    else
      return null;
  }
}
