import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:daily_info/core/extensions/ex_expanded.dart';
import 'package:daily_info/core/services/navigation_service.dart';
import 'package:daily_info/core/widgets/w_dialog.dart';
import '/core/extensions/ex_keyboards.dart';
import '/core/extensions/ex_strings.dart';
import 'package:flutter/material.dart';
import 'package:power_state/power_state.dart';
import '/core/constants/dimension_theme.dart';
import '/core/extensions/ex_padding.dart';
import '/core/widgets/load_and_error/models/view_state_model.dart';
import '/core/widgets/w_button.dart';
import '/core/widgets/w_text_field.dart';
import '../controller/c_auth.dart';
import '../data/data_source/auth_data_source_impl.dart';
import '../data/repository/auth_repository_impl.dart';

class SForgetPass extends StatefulWidget {
  const SForgetPass({super.key});

  @override
  State<SForgetPass> createState() => _SSignInState();
}

class _SSignInState extends State<SForgetPass> {
  final CAuth _cAuth = PowerVault.put(
    CAuth(AuthRepositoryImpl(AuthDataSourceImpl())),
  );

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> isRemember = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isAgree = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isSignUp = ValueNotifier<bool>(false);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    isRemember.dispose();
    isSignUp.dispose();
    isAgree.dispose();
    PowerVault.delete<CAuth>();
    super.dispose();
  }

  void _onSubmit() {
    context.unFocus();
    if (_formKey.currentState?.validate() ?? false) {
      CAuth cAuth = PowerVault.put(
        CAuth(AuthRepositoryImpl(AuthDataSourceImpl())),
      );
      cAuth.sendForgetMail(emailController.text);
      emailController.text = "";
      Navigation.pop();
      WDialog.show(
        context: context,
        content:
            "Please check your gmail \"inbox\". \nif you can't see in inbox please check spam folder",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forget Password", style: context.textTheme?.titleSmall),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: PTheme.paddingX,
            vertical: PTheme.paddingY,
          ),
          child: Column(
            children: [
              _Header(isSignUp: true),
              gapY(32),
              ValueListenableBuilder<bool>(
                valueListenable: isSignUp,
                builder: (context, signUp, _) => _AuthForm(
                  formKey: _formKey,
                  emailController: emailController,
                ),
              ),
              gapY(24),
              ValueListenableBuilder<bool>(
                valueListenable: isAgree,
                builder: (context, agree, _) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: isSignUp,
                    builder: (context, signUp, _) {
                      return PowerBuilder<CAuth>(
                        builder: (controller) {
                          final isLoading =
                              controller.viewState == ViewState.loading;
                          return WPrimaryButton(
                            text: "Submit",
                            isLoading: isLoading,
                            isDisabled: signUp && !agree,
                            onTap: _onSubmit,
                          );
                        },
                      );
                    },
                  );
                },
              ).pB(value: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------- HEADER -----------------
class _Header extends StatelessWidget {
  final bool isSignUp;
  const _Header({required this.isSignUp});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Note: \n1. after submit your confirm rest password request, you will get a email on your email addess if the email is exist on our system. \n\n2. if you can't see the mail in inbox, please check in \"SPAM\" folder.",
          style: context.textTheme?.bodySmall,
        ).pB(),
      ],
    );
  }
}

// ----------------- AUTH FORM -----------------
class _AuthForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  const _AuthForm({required this.formKey, required this.emailController});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          WTextField.requiredField(
            controller: emailController,
            label: "Email Address",
            validator: (value) {
              if (value == null) return "Enter Email!";
              if (!value.isValidEmail) return "Invalid Email!";
              return null;
            },
          ).pB(value: 12).withKey(ValueKey("email")),
        ],
      ),
    );
  }
}
