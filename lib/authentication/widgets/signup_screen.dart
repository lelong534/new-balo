import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class SignupScreen extends StatefulWidget {
  static String routeName = 'signup';
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isHidePassword = true;
  final _phonenumberController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final phoneValidator = MultiValidator([
    RequiredValidator(errorText: "Bạn quên nhập ô này"),
    MinLengthValidator(10, errorText: 'Điện thoại dài ít nhất 10 kí tự'),
    MaxLengthValidator(10, errorText: 'Điện thoại dài nhiều nhất 10 kí tự'),
  ]);

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Bạn quên nhập ô này'),
    MinLengthValidator(8, errorText: 'Mật khẩu dài ít nhất 8 kí tự')
  ]);

  void _onSignupButtonPressed() {}

  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng ký'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onSignupButtonPressed,
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.east,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Text(
                'Vui lòng điền thông tin đăng ký của bạn',
                style: TextStyle(fontSize: 13),
              ),
              color: Colors.black12,
              padding: EdgeInsets.fromLTRB(12, 6, 12, 6),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _phonenumberController,
                      style: TextStyle(
                        fontSize: 13,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Số điện thoại',
                      ),
                      keyboardType: TextInputType.number,
                      validator: phoneValidator,
                    ),
                    TextFormField(
                        controller: _passwordController,
                        obscureText: isHidePassword,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                        onChanged: (value) => password = value,
                        decoration: InputDecoration(
                          labelText: 'Mật khẩu',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isHidePassword = !isHidePassword;
                              });
                            },
                            icon: isHidePassword
                                ? Icon(EvaIcons.eyeOutline)
                                : Icon(EvaIcons.eyeOffOutline),
                          ),
                        ),
                        validator: passwordValidator),
                    TextFormField(
                      obscureText: isHidePassword,
                      style: TextStyle(
                        fontSize: 13,
                      ),
                      decoration: InputDecoration(
                          labelText: 'Nhập lại mật khẩu',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isHidePassword = !isHidePassword;
                              });
                            },
                            icon: isHidePassword
                                ? Icon(EvaIcons.eyeOutline)
                                : Icon(EvaIcons.eyeOffOutline),
                          )),
                      validator: (val) =>
                          MatchValidator(errorText: 'Mật khẩu không khớp')
                              .validateMatch(val!, password),
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
            )
          ],
        ),
      ),
    );
  }
}
