import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pedometer/03_FireBase/03_01_TextDaialog.dart';
import 'package:pedometer/03_FireBase/03_02_WillPopScope.dart';
import 'package:pedometer/03_FireBase/03_05_PasswordForgetModel.dart';
import '01_01_SigninPage.dart';

class ForgetPasswordPage extends StatelessWidget {
  final mailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPopCallback,
      child: ChangeNotifierProvider<ForgetPasswordModel>(
        create: (_) => ForgetPasswordModel(),
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: AppBar(
              backgroundColor: Colors.green,
            ),
          ),
          body: Consumer<ForgetPasswordModel>(
            builder: (context, model, child) {
              return Stack(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            controller: mailController,
                            onChanged: (text) {
                              model.changeMail(text);
                            },
                            maxLines: 1,
                            decoration: InputDecoration(
                              errorText: model.errorMail == ''
                                  ? null
                                  : model.errorMail,
                              labelText: 'メールアドレス',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: RaisedButton(
                              child: Text('再設定する'),
                              color: Color(0xFF4CAF50),
                              textColor: Colors.white,
                              onPressed: model.isMailValid
                                  ? () async {
                                model.startLoading();
                                try {
                                  await model.sendResetEmail();
                                  await showTextDialog(context,
                                      'パスワードの再設定用のメールを送信しました。メールボックスをご確認下さい。');
                                  await Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignInPage(),
                                    ),
                                  );
                                } catch (e) {
                                  showTextDialog(context, e);
                                  model.endLoading();
                                }
                              }
                                  : null,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          FlatButton(
                            child: Text(
                              'ログイン画面に戻る',
                            ),
                            textColor: Color(0xFF4CAF50),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  model.isLoading
                      ? Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                      : SizedBox()
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}