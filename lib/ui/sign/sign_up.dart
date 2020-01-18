import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:vf_girls/common/index.dart';
import 'package:vf_girls/ui/sign/sign_widget.dart';
import 'package:vf_girls/ui/widget/toast.dart';
import 'package:vf_girls/view_model/sign_model.dart';
import 'package:vf_plugin/vf_plugin.dart';

class SignUpPage extends StatefulWidget {
  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _pwdFocus = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SignModel model = Provider.of<SignModel>(context);
    return Scaffold(
      appBar: VFTopBar(
        top: MediaQuery.of(context).padding.top,
        title: FlutterI18n.translate(context, 'sign_up'),
        titleColor: VFColors.white,
        leftIcon: VFIcons.ic_arrow_left,
      ),
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Stack(
              children: <Widget>[
                SignTopPanel(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SignLogo(),
                      SignFormContainer(
                        child: Form(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              SignInput(
                                label: FlutterI18n.translate(
                                    context, 'sign_username'),
                                icon: Icons.perm_identity,
                                controller: _nameController,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (text) {
                                  FocusScope.of(context)
                                      .requestFocus(_pwdFocus);
                                },
                              ),
                              SignInput(
                                controller: _passwordController,
                                label: FlutterI18n.translate(
                                    context, 'sign_password'),
                                icon: Icons.lock_outline,
                                obscureText: true,
                                focusNode: _pwdFocus,
                                textInputAction: TextInputAction.done,
                              ),
                              SignUpButton(
                                _nameController,
                                _passwordController,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // ThirdSign(),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SignUpButton extends StatelessWidget {
  final nameController;
  final passwordController;

  SignUpButton(this.nameController, this.passwordController);

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<SignModel>(context);
    return Padding(
      padding: EdgeInsets.only(top: VFDimens.d_24),
      child: SignButton(
        child: model.isBusy
            ? VFLoading()
            : Text(
                FlutterI18n.translate(context, 'sign_up'),
                style: Theme.of(context).accentTextTheme.title.copyWith(
                      wordSpacing: 6,
                      fontSize: VFSizes.s_18,
                    ),
              ),
        onPressed: model.isBusy
            ? null
            : () {
                if (Form.of(context).validate()) {
                  model
                      .signUp(nameController.text, passwordController.text)
                      .then((value) {
                    if (value) {
                      Navigator.of(context).pop(true);
                    } else {
                      VFToast.error('注册失败');
                    }
                  });
                }
              },
      ),
    );
  }
}
