import 'package:byebye_flutter_app/app/sign_in/email_password/email_password_sign_in_model.dart';
import 'package:byebye_flutter_app/common_widgets/form_submit_button.dart';
import 'package:byebye_flutter_app/common_widgets/platform_alert_dialog.dart';
import 'package:byebye_flutter_app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:byebye_flutter_app/constants/strings.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:byebye_flutter_app/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../my_constants/design_system.dart';

class EmailPasswordSignInPage extends StatefulWidget {
  const EmailPasswordSignInPage._(
      {Key key, @required this.model, this.onSignedIn})
      : super(key: key);
  final EmailPasswordSignInModel model;
  final VoidCallback onSignedIn;

  static Future<void> show(BuildContext context,
      {VoidCallback onSignedIn}) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) =>
            EmailPasswordSignInPage.create(context, onSignedIn: onSignedIn),
      ),
    );
  }

  static Widget create(BuildContext context, {VoidCallback onSignedIn}) {
    final AuthService auth = Provider.of<AuthService>(context, listen: false);
    return ChangeNotifierProvider<EmailPasswordSignInModel>(
      create: (_) => EmailPasswordSignInModel(auth: auth),
      child: Consumer<EmailPasswordSignInModel>(
        builder: (_, EmailPasswordSignInModel model, __) =>
            EmailPasswordSignInPage._(model: model, onSignedIn: onSignedIn),
      ),
    );
  }

  @override
  _EmailPasswordSignInPageState createState() =>
      _EmailPasswordSignInPageState();
}

class _EmailPasswordSignInPageState extends State<EmailPasswordSignInPage> {
  final FocusScopeNode _node = FocusScopeNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  EmailPasswordSignInModel get model => widget.model;
  String selectedButtonOption;

  @override
  void dispose() {
    _node.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSignInError(
      EmailPasswordSignInModel model, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: model.errorAlertTitle,
      exception: exception,
    ).show(context);
  }

  Future<void> _submit() async {
    try {
      selectedButtonOption = await AlertBoxDialog().showCustomAlertDialog(
          context,
          Strings.userConvenience,
          Strings.userConvenienceWarning,
          [Strings.ok]);
      if (selectedButtonOption == Strings.ok) {
        final bool success = await model.submit();
        if (success) {
          if (model.formType == EmailPasswordSignInFormType.forgotPassword) {
            await PlatformAlertDialog(
              title: Strings.resetLinkSentTitle,
              content: Strings.resetLinkSentMessage,
              defaultActionText: Strings.ok,
            ).show(context);
          } else {
            if (widget.onSignedIn != null) {
              widget.onSignedIn();
            }
          }
        }
      }
    } on PlatformException catch (e) {
      _showSignInError(model, e);
    }
  }

  void _emailEditingComplete() {
    if (model.canSubmitEmail) {
      _node.nextFocus();
    }
  }

  void _passwordEditingComplete() {
    if (!model.canSubmitEmail) {
      _node.previousFocus();
      return;
    }
    _submit();
  }

  void _updateFormType(EmailPasswordSignInFormType formType) {
    model.updateFormType(formType);
    _emailController.clear();
    _passwordController.clear();
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          Strings.emailLabel,
          style: Theme.of(context)
              .textTheme
              .caption
              .copyWith(color: myOnBackgroundColor),
        ),
        TextField(
          key: Key('email'),
          autofocus: true,
          controller: _emailController,
          cursorColor: myAccentColor,
          decoration: InputDecoration(
            //labelText: Strings.emailLabel,
            hintText: Strings.emailHint,
            hintStyle: Theme.of(context)
                .textTheme
                .button
                .copyWith(color: myAccentColor, fontWeight: FontWeight.w700),

            errorText: model.emailErrorText,
            enabled: !model.isLoading,
          ),
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(color: myPrimaryColor),
          autocorrect: false,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          keyboardAppearance: Brightness.light,
          onChanged: model.updateEmail,
          onEditingComplete: _emailEditingComplete,
          inputFormatters: <TextInputFormatter>[
            model.emailInputFormatter,
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          model.passwordLabelText,
          style: Theme.of(context)
              .textTheme
              .caption
              .copyWith(color: myOnBackgroundColor),
        ),
        TextField(
          key: Key('password'),
          cursorColor: myAccentColor,
          controller: _passwordController,
          decoration: InputDecoration(
            //labelText: model.passwordLabelText,
            errorText: model.passwordErrorText,
            enabled: !model.isLoading,
          ),
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(color: myPrimaryColor),
          obscureText: true,
          autocorrect: false,
          textInputAction: TextInputAction.done,
          keyboardAppearance: Brightness.light,
          onChanged: model.updatePassword,
          onEditingComplete: _passwordEditingComplete,
        ),
      ],
    );
  }

  Widget _buildContent() {
    return FocusScope(
      node: _node,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 8.0),
          _buildEmailField(),
          if (model.formType !=
              EmailPasswordSignInFormType.forgotPassword) ...<Widget>[
            SizedBox(height: 24.0),
            _buildPasswordField(),
          ],
          SizedBox(height: 36.0),
          FormSubmitButton(
            key: Key('primary-button'),
            text: model.primaryButtonText,
            loading: model.isLoading,
            onPressed: model.isLoading ? null : _submit,
          ),
          SizedBox(height: 32.0),
          FlatButton(
            key: Key('secondary-button'),
            child: Text(
              model.secondaryButtonText,
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: myAccentColor, fontWeight: FontWeight.w700),
            ),
            onPressed: model.isLoading
                ? null
                : () => _updateFormType(model.secondaryActionFormType),
          ),
          SizedBox(height: 16.0),
          if (model.formType == EmailPasswordSignInFormType.signIn)
            FlatButton(
              key: Key('tertiary-button'),
              child: Text(
                Strings.forgotPasswordQuestion,
                style: Theme.of(context).textTheme.button.copyWith(
                    color: myOnBackgroundColor, fontWeight: FontWeight.w700),
              ),
              onPressed: model.isLoading
                  ? null
                  : () => _updateFormType(
                      EmailPasswordSignInFormType.forgotPassword),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myBackgroundColor,
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: myDarkOnPrimaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0.0,
        title: Text(
          model.title,
          style: Theme.of(context)
              .textTheme
              .subtitle2
              .copyWith(color: myOnPrimaryColor),
        ),
        titleSpacing: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(0.0),
          child: Card(
            color: myBackgroundColor,
            elevation: 0.0,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: _buildContent(),
            ),
          ),
        ),
      ),
    );
  }
}
