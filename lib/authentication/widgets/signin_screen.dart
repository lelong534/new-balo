import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zalo_bloc/authentication/blocs/blocs.dart';
import 'package:flutter_zalo_bloc/authentication/widgets/signup_screen.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class SigninScreen extends StatefulWidget {
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _formKey = GlobalKey<FormState>();

  final _phonenumberController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isHidePassword = true;

  final phoneValidator = MultiValidator([
    RequiredValidator(errorText: "Bạn quên nhập ô này"),
    MinLengthValidator(10, errorText: 'Điện thoại dài ít nhất 10 kí tự'),
    MaxLengthValidator(10, errorText: 'Điện thoại dài nhiều nhất 10 kí tự'),
  ]);

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Bạn quên nhập ô này'),
    MinLengthValidator(8, errorText: 'Mật khẩu dài ít nhất 8 kí tự'),
    // PatternValidator(r'(?=.*?[#?!@$%^&*-])',
    //     errorText: 'Cần nhập thêm kí tự đặc biệt')
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng nhập'),
      ),
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationRequestFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is Authenticated) {
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (_, state) {
            return LoadingOverlay(
              isLoading: state is AuthenticationRequestLoading,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      child: Text(
                        'Vui lòng nhập số điện thoại và mật khẩu',
                        style: TextStyle(fontSize: 13),
                      ),
                      color: Colors.black12,
                      padding: EdgeInsets.fromLTRB(12, 6, 12, 6),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _phonenumberController,
                            validator: phoneValidator,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Số điện thoại',
                            ),
                          ),
                          TextFormField(
                            controller: _passwordController,
                            validator: passwordValidator,
                            obscureText: isHidePassword,
                            decoration: InputDecoration(
                              labelText: 'Mật khẩu',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isHidePassword = !isHidePassword;
                                  });
                                },
                                icon: Icon(EvaIcons.eyeOutline),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Text(
                              "Lưu ý: Số điện thoại là dãy số có 10 chữ số. Mật khẩu chứa ít nhất 8 kí tự.",
                              style: TextStyle(
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => SignupScreen()),
                          );
                        },
                        child: Text(
                          "Chưa có tài khoản?",
                          textAlign: TextAlign.right,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            FocusScope.of(context).unfocus();

            String phonenumber = _phonenumberController.text;
            String password = _passwordController.text;

            context
                .read<AuthenticationBloc>()
                .add(SignIn(phonenumber: phonenumber, password: password));
          }
        },
        child: Icon(Icons.arrow_forward),
      ),
    );
  }

  @override
  void dispose() {
    _phonenumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
