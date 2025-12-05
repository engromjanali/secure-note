import 'package:daily_info/core/extensions/ex_build_context.dart';
import 'package:daily_info/core/extensions/ex_expanded.dart';
import 'package:daily_info/core/services/navigation_service.dart';
import 'package:daily_info/core/widgets/w_app_bar.dart';
import 'package:daily_info/features/authentication/views/s_forget_pass.dart';
import '/core/constants/default_values.dart';
import '/core/functions/f_url_launcher.dart';
import 'package:flutter/gestures.dart';
import '/core/functions/f_snackbar.dart';
import '/core/extensions/ex_keyboards.dart';
import '/core/extensions/ex_strings.dart';
import '/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:power_state/power_state.dart';
import '/core/constants/dimension_theme.dart';
import '/core/extensions/ex_padding.dart';
import '/core/widgets/load_and_error/models/view_state_model.dart';
import '/core/widgets/w_button.dart';
import '/core/widgets/w_text_field.dart';
import '../controller/c_auth.dart';
import '../data/data_source/auth_data_source_impl.dart';
import '../data/model/m_auth.dart';
import '../data/model/m_social_auth_model.dart';
import '../data/repository/auth_repository_impl.dart';
import '../widgets/w_have_account.dart';

class SSignIn extends StatefulWidget {
  final bool keepTheBackButton;
  final bool isSignIn;
  const SSignIn({
    super.key,
    this.keepTheBackButton = false,
    this.isSignIn = true,
  });

  @override
  State<SSignIn> createState() => _SSignInState();
}

class _SSignInState extends State<SSignIn> {
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
    isSignUp.value = !widget.isSignIn;
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
      final payload = MAuth(
        name: isSignUp.value ? nameController.text : null,
        email: emailController.text,
        password: passController.text,
      );

      if (isSignUp.value) {
        _cAuth.signUp(payload: payload);
      } else {
        _cAuth.signIn(payload: payload);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.keepTheBackButton == true ? WAppBar(text: "") : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: PTheme.paddingX,
            vertical: PTheme.paddingY,
          ),
          child: Column(
            children: [
              gapY(widget.keepTheBackButton == true ? 0 : 30),
              ValueListenableBuilder<bool>(
                valueListenable: isSignUp,
                builder: (context, signUp, _) => _Header(isSignUp: signUp),
              ),
              gapY(32),
              ValueListenableBuilder<bool>(
                valueListenable: isSignUp,
                builder: (context, signUp, _) => _AuthForm(
                  formKey: _formKey,
                  isSignUp: signUp,
                  nameController: nameController,
                  emailController: emailController,
                  passController: passController,
                  isAgree: isAgree,
                  isRemember: isRemember,
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
                            text: signUp ? "Sign Up" : "Sign In",
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
              Row(
                children: [
                  Expanded(child: SizedBox.shrink().pDivider()),
                  InkWell(
                    onTap: () {
                      // SRoot().push();
                    },
                    child: Text(
                      " Or continue with ",
                      style: context.textTheme?.bodyMedium,
                    ),
                  ),
                  Expanded(child: SizedBox.shrink().pDivider()),
                ],
              ).pB(value: 40),
              _SocialButtons(
                cAuth: _cAuth,
                isAgree: isAgree,
                isSignUp: isSignUp,
              ),
              ValueListenableBuilder<bool>(
                valueListenable: isSignUp,
                builder: (context, signUp, child) => gapY(signUp ? 10 : 50),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: isSignUp,
                builder: (context, signUp, child) {
                  return _Footer(
                    isSignUp: signUp,
                    onToggleSignUp: () {
                      isSignUp.value = !isSignUp.value;
                      isAgree.value = false;
                      isRemember.value = false;
                    },
                  );
                },
              ),
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
        Text("Secure Note", style: context.textTheme?.titleSmall).pB(),
        Text(
          "${isSignUp ? "Sign up" : "Log in"} to your account",
          style: context.textTheme?.titleSmall,
        ),
      ],
    );
  }
}

// ----------------- AUTH FORM -----------------
class _AuthForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool isSignUp;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passController;
  final ValueNotifier<bool> isAgree;
  final ValueNotifier<bool> isRemember;

  const _AuthForm({
    required this.formKey,
    required this.isSignUp,
    required this.nameController,
    required this.emailController,
    required this.passController,
    required this.isAgree,
    required this.isRemember,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          if (isSignUp)
            WTextField.requiredField(
              controller: nameController,
              label: "Full Name",
            ).pB(value: 12).withKey(ValueKey("name")),
          WTextField.requiredField(
            controller: emailController,
            label: "Email Address",
            validator: (value) {
              if (value == null) return "Enter Email!";
              if (!value.isValidEmail) return "Invalid Email!";
              return null;
            },
          ).pB(value: 12).withKey(ValueKey("email")),
          WTextField.obsecureText(
            controller: passController,
            label: "Password",
            validator: (value) {
              if (value == null) return "Enter Password!";
              if (value.contains(" ")) return "Spaces not allowed!";
              if (value.trim().length < 6) return "Use minimum of six letters!";
              return null;
            },
          ).pB().withKey(ValueKey("pass")),
          if (isSignUp)
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: isAgree,
                    builder: (_, agree, __) => Checkbox.adaptive(
                      value: agree,
                      onChanged: (val) => isAgree.value = val ?? false,
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'By continuing, I agree with',
                        style: context.textTheme?.bodySmall,
                        children: <TextSpan>[
                          TextSpan(
                            text: ' Terms of Service',
                            style: context.textTheme?.bodySmall?.copyWith(
                              color: context.button?.primary,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                OpenURLs.open(
                                  type: OpenType.url,
                                  value: PDefaultValues.termsConditionUrl,
                                );
                              },
                          ),
                          TextSpan(
                            text: ' and ',
                            style: context.textTheme?.bodySmall,
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Privacy Policy',
                                style: context.textTheme?.bodySmall?.copyWith(
                                  color: context.button?.primary,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    OpenURLs.open(
                                      type: OpenType.url,
                                      value: PDefaultValues.privacyUrlLink,
                                    );
                                  },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: isRemember,
                      builder: (_, rem, __) => Checkbox.adaptive(
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: rem,
                        onChanged: (val) => isRemember.value = val ?? false,
                      ),
                    ),
                    Text("Remember", style: context.textTheme?.bodyMedium),
                  ],
                ),
                TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                  onPressed: () {
                    SForgetPass().push();
                  },
                  child: Text("Forget?", style: context.textTheme?.titleSmall),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// ----------------- SOCIAL BUTTONS -----------------
class _SocialButtons extends StatelessWidget {
  final CAuth cAuth;
  final ValueNotifier<bool> isAgree;
  final ValueNotifier<bool> isSignUp;
  const _SocialButtons({
    required this.cAuth,
    required this.isAgree,
    required this.isSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: PTheme.spaceX,
      children: [
        Expanded(
          child: WPrimaryButton.icon(
            color: Colors.amber,
            onTap: () {
              if (isAgree.value == false && isSignUp.value == true) {
                showSnackBar(
                  "You must agree to continue",
                  snackBarType: SnackBarType.warning,
                );
              } else {
                cAuth.signInWithSocial(SocialMediaType.google);
              }
            },
            gradientColors: [Colors.grey.shade300, Colors.grey.shade300],
            iconSVG: Assets.logo.google,
          ),
        ),
        Expanded(
          child: WPrimaryButton.icon(
            gradientColors: [Colors.grey.shade300, Colors.grey.shade300],
            iconSVG: Assets.logo.apple,
          ),
        ),
      ],
    );
  }
}

// ----------------- FOOTER -----------------
class _Footer extends StatelessWidget {
  final bool isSignUp;
  final VoidCallback onToggleSignUp;

  const _Footer({required this.isSignUp, required this.onToggleSignUp});

  @override
  Widget build(BuildContext context) {
    return WHaveAccount(
      label: isSignUp ? "Already have an account" : "Don't have Account?",
      actionText: isSignUp ? "Sign In" : "Sign Up",
      onTap: onToggleSignUp,
    ).pV(value: 30);
  }
}
