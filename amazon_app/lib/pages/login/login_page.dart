import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'login_controller.dart';
import 'parts/progress_indicator.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _login() async {
    await loginController(
      context,
      ref,
      emailController,
      passwordController,
      () => mounted,
    );
  }

  @override
  Widget build(BuildContext context) {
    isLoading = ref.watch(loadingJudgeProvider);
    return CupertinoApp(
      home: CupertinoPageScaffold(
        child: Container(
          padding: const EdgeInsets.all(24),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                Color.fromRGBO(116, 85, 255, 0.56),
                Color.fromRGBO(43, 0, 234, 0.18),
              ],
            ),
          ),
          child: Stack(
            children: [
              const LoginProgressIndicator(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //アイコン
                  Container(
                    margin: const EdgeInsets.all(23),
                    child: const Column(
                      children: <Widget>[
                        Icon(
                          CupertinoIcons.calendar_today,
                          color: Colors.white,
                          size: 103,
                        ),

                        //文字
                        Text(
                          'Amazon',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 346,
                    margin: const EdgeInsets.all(13.5),
                    child: const Text(
                      'メールアドレス',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  //Email form
                  SizedBox(
                    width: 346,
                    height: 46,
                    child: CupertinoTextField(
                      controller: emailController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(9),
                          topRight: Radius.circular(9),
                          bottomLeft: Radius.circular(9),
                          bottomRight: Radius.circular(9),
                        ),
                        color: Colors.transparent,
                        border: Border(
                          left: BorderSide(
                            color: Color.fromRGBO(123, 97, 255, 1),
                          ),
                          top: BorderSide(
                            color: Color.fromRGBO(123, 97, 255, 1),
                          ),
                          right: BorderSide(
                            color: Color.fromRGBO(123, 97, 255, 1),
                          ),
                          bottom: BorderSide(
                            color: Color.fromRGBO(123, 97, 255, 1),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Container(
                    width: 346,
                    margin: const EdgeInsets.all(13.5),
                    child: const Text(
                      'パスワード',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  //Password form
                  SizedBox(
                    width: 346,
                    height: 46,
                    child: CupertinoTextField(
                      controller: passwordController,
                      obscureText: true,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(9),
                          topRight: Radius.circular(9),
                          bottomLeft: Radius.circular(9),
                          bottomRight: Radius.circular(9),
                        ),
                        color: Colors.transparent,
                        border: Border(
                          left: BorderSide(
                            color: Color.fromRGBO(123, 97, 255, 1),
                          ),
                          top: BorderSide(
                            color: Color.fromRGBO(123, 97, 255, 1),
                          ),
                          right: BorderSide(
                            color: Color.fromRGBO(123, 97, 255, 1),
                          ),
                          bottom: BorderSide(
                            color: Color.fromRGBO(123, 97, 255, 1),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Container(
                    height: 47,
                    width: 195,
                    margin: const EdgeInsets.all(23),
                    child: CupertinoButton(
                      color: const Color.fromRGBO(80, 49, 238, 0.9),
                      borderRadius: BorderRadius.circular(30),
                      onPressed: isLoading
                          ? null
                          : () async {
                              await _login();
                            },
                      child: const Text('login'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
