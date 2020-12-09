import 'package:comat_apps/services/auth.dart';
import 'package:comat_apps/ui/custom_widget/my_input.dart';
import 'package:comat_apps/ui/custom_widget/my_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final AuthService _authService = AuthService();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  bool loading = false;
  String error = '';

  TextEditingController _emailCL = TextEditingController(text: "");
  TextEditingController _passwordCL = TextEditingController(text: "");
  TextEditingController _emailCR = TextEditingController(text: "");
  TextEditingController _passwordCR = TextEditingController(text: "");

  int _pageState = 1;

  var _backgroundColor = Colors.white;
  var _headingColor = Color(0xFFB40284A);

  double _headingTop = 100;

  double _loginWidth = 0;
  double _loginHeight = 0;
  double _loginOpacity = 1;

  double _loginYOffset = 0;
  double _loginXOffset = 0;
  double _registerYOffset = 0;
  double _registerHeight = 0;

  double windowWidth = 0;
  double windowHeight = 0;

  bool _keyboardVisible = false;

  @override
  void initState() {
    super.initState();

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardVisible = visible;
          print("Keyboard State Changed : $visible");
        });
      },
    );
  }

  _showToast(String text, Color bgcolor) {
    return Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: bgcolor,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  @override
  Widget build(BuildContext context) {

    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    _loginHeight = windowHeight - 270;
    _registerHeight = windowHeight - 270;

    switch(_pageState) {
      case 0:
        _backgroundColor = Colors.white;
        _headingColor = Color(0xFFB40284A);

        _headingTop = 100;

        _loginWidth = windowWidth;
        _loginOpacity = 1;

        _loginYOffset = windowHeight;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 270;

        _loginXOffset = 0;
        _registerYOffset = windowHeight;
        break;
      case 1:
        _backgroundColor = Color(0xFFBD34C59);
        _headingColor = Colors.white;

        _headingTop = 0;

        _loginWidth = windowWidth;
        _loginOpacity = 1;

        _loginYOffset = _keyboardVisible ? 40 : 270;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 270;

        _loginXOffset = 0;
        _registerYOffset = windowHeight;
        break;
      case 2:
        _backgroundColor = Color(0xFFBD34C59);
        _headingColor = Colors.white;

        _headingTop = 0;

        _loginWidth = windowWidth - 40;
        _loginOpacity = 0.7;

        _loginYOffset = _keyboardVisible ? 30 : 240;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 240;

        _loginXOffset = 20;
        _registerYOffset = _keyboardVisible ? 55 : 270;
        _registerHeight = _keyboardVisible ? windowHeight : windowHeight - 270;
        break;
    }

    return loading ? Loading() : Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Stack(
          children: <Widget>[
            AnimatedContainer(
              curve: Curves.fastLinearToSlowEaseIn,
              duration: Duration(
                milliseconds: 1000
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF3383CD),
                    Color(0xFF11249F)
                  ]
                ),
                image: DecorationImage(
                  image: AssetImage("assets/images/bg_transparent.png")
                ) 
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 45, left: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Material(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.transparent,
                          child: IconButton(
                            splashRadius: 50,
                            icon: Icon(Icons.keyboard_backspace, color: Colors.white,),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _pageState = 0;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 15),
                      child: Column(
                        children: <Widget>[
                          AnimatedContainer(
                            curve: Curves.fastLinearToSlowEaseIn,
                            duration: Duration(
                              milliseconds: 1000
                            ),
                            margin: EdgeInsets.only(
                              top: _headingTop,
                            ),
                            child: Text(
                              "Get Started",
                              style: TextStyle(
                                color: _headingColor,
                                fontSize: 28
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(20),
                            padding: EdgeInsets.symmetric(
                              horizontal: 32
                            ),
                            child: Text(
                              "We make it very easy for you to know event information. Join us today!.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _headingColor,
                                fontSize: 16
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 32
                    ),
                    child: Center(
                      child: Image.asset("assets/images/bg_user.png"),
                    ),
                  ),
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if(_pageState != 0){
                            _pageState = 0;
                          } else {
                            _pageState = 1;
                          }
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(32),
                        padding: EdgeInsets.all(20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xFFB40284A),
                          borderRadius: BorderRadius.circular(50)
                        ),
                        child: Center(
                          child: Text("Next", 
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ),
            AnimatedContainer(
              padding: EdgeInsets.all(32),
              width: _loginWidth,
              height: _loginHeight,
              curve: Curves.fastLinearToSlowEaseIn,
              duration: Duration(
                milliseconds: 1000
              ),
              transform: Matrix4.translationValues(_loginXOffset, _loginYOffset, 1),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(_loginOpacity),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25)
                )
              ),
              child: Form(
                key: _formKey1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Text(
                            "Login To Continue",
                            style: TextStyle(
                                fontSize: 20
                            ),
                          ),
                        ),
                        NormalInput(isPassword: false, label: "Email", hint: "Email", inputType: TextInputType.emailAddress, controller: _emailCL,),
                        SizedBox(height: 20,),
                        NormalInput(isPassword: true, label: "Password", inputType: TextInputType.visiblePassword, controller: _passwordCL,),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RaisedButton(
                              onPressed: () async {
                                // dynamic result = await _authService.signInAnon();
                                if(_formKey1.currentState.validate()) {
                                  setState(() => loading = true);
                                  dynamic result = await _authService.signInWithEmailAndPassword(_emailCL.text, _passwordCL.text);
                                  if(result == null) {
                                    _showToast("Check you're credential or Verify your email !", Colors.red);
                                    setState(() {
                                      loading = false;
                                    });
                                  } else {
                                    _showToast("Login successfully !", Colors.green);
                                    setState(() => loading = false);
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              color: Colors.blue[400],
                              padding: EdgeInsets.symmetric(horizontal: 44),
                              child: Text(
                                "Sign in",
                                style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.white
                                ),
                              ),
                            ),
                            OutlineButton(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              onPressed: () {
                                setState(() {
                                  _pageState = 2;
                                });
                              },
                              child: Text(
                                "Sign up",
                                style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.black
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        SignInButton(
                          Buttons.Google,
                          padding: EdgeInsets.only(left: 25.0),
                          onPressed: () async{
                            setState(() => loading = true);
                            dynamic result = await _authService.signInWithGoogle();
                            if(result == null) {
                              _showToast("Check you're credential or Verify your email !", Colors.red);
                              // _showToast("Check you're credential or Verify your email !", Icons.close, Colors.red, 3);
                              setState(() {
                                loading = false;
                              });
                            } else {
                              _showToast("Login succesfully !", Colors.green);
                              // _showToast(" !", Icons.check, Colors.green, 3);
                              setState(() => loading = false);
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            AnimatedContainer(
              height: _registerHeight,
              padding: EdgeInsets.all(32),
              curve: Curves.fastLinearToSlowEaseIn,
              duration: Duration(
                  milliseconds: 1000
              ),
              transform: Matrix4.translationValues(0, _registerYOffset, 1),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)
                  )
              ),
              child: Form(
                key: _formKey2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Text(
                            "Create a New Account",
                            style: TextStyle(
                              fontSize: 20
                            ),
                          ),
                        ),
                        NormalInput(isPassword: false, label: "Email", hint: "Email", inputType: TextInputType.emailAddress, controller: _emailCR,),
                        SizedBox(height: 20,),
                        NormalInput(isPassword: true, label: "Password", inputType: TextInputType.visiblePassword, controller: _passwordCR,),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RaisedButton(
                              onPressed: () async {
                                // dynamic result = await _authService.signInAnon();
                                if(_formKey2.currentState.validate()) {
                                  setState(() => loading = true);
                                  dynamic result = await _authService.registerWithEmailAndPassword(_emailCR.text, _passwordCR.text);
                                  if(result == null) {
                                    _showToast("Please using other email !", Colors.red);
                                    setState(() {
                                      loading = false;
                                    });
                                  } else {
                                    _showToast("Please verify your email !", Colors.green);
                                    setState(() => loading = false);
                                  }
                                }
                              },
                              color: Colors.blue[400],
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                "Sign up",
                                style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.white
                                ),
                              ),
                            ),
                            OutlineButton(
                              padding: EdgeInsets.symmetric(horizontal: 44),
                              onPressed: () {
                                setState(() {
                                  _pageState = 1;
                                });
                              },
                              child: Text(
                                "Sign in",
                                style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.black
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}