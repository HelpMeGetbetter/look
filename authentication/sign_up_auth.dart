import 'package:flutter/material.dart';
import 'package:groceryapp/api_service.dart';
import 'package:groceryapp/models/customer.dart';
import 'package:groceryapp/utils/form_helper.dart';
import 'package:groceryapp/utils/progress_hud.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:groceryapp/utils/validator_service.dart';

class SignUpAuth extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpAuth> {
  ApiService apiService;
  CustomerModel model;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool hidePassword = true;
  bool isApiCallProcess = false;

  @override
  void initState() {
    apiService = new ApiService();
    model = CustomerModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Sign Up"),
      ),
      body: ProgressHUD(
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
        child: new Form(
          key: globalKey,
          child: _formUI(),
        ),
      ),
    ));
  }

  Widget _formUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormHelper.fieldLabel("First Name"),
                FormHelper.textInput(
                  context,
                  model.firstName,
                      (value) => {
                    this.model.firstName = value,
                  },
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return 'Please enter First Name.';
                    }
                    return null;
                  },
                ),
                FormHelper.fieldLabel("Last Name"),
                FormHelper.textInput(
                  context,
                  model.lastName,
                      (value) => {
                    this.model.lastName = value,
                  },
                  onValidate: (value) {
                    return null;
                  },
                ),
                FormHelper.fieldLabel("Email Id"),
                FormHelper.textInput(
                  context,
                 model.email,
                      (value) => {
                    this.model.email = value,
                  },
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return 'Please enter Email Id.';
                    }

                    if (value.isNotEmpty && !value.toString().isValidEmail()) {
                      return 'Please enter valid email id';
                    }

                    return null;
                  },
                ),
                FormHelper.fieldLabel("Password"),
                FormHelper.textInput(
                  context,
                  model.password,
                      (value) => {
                    this.model.password = value,
                  },
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return 'Please enter Password.';
                    }

                    return null;
                  },
                  obscureText: hidePassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    color: Theme.of(context).accentColor.withOpacity(0.4),
                    icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                new Center(
                  child: FormHelper.saveButton(
                    "Register",
                        () {
                      if (validateAndSave()) {
                        print(model.toJson());
                        setState(() {
                          isApiCallProcess = true;
                        });

                        apiService.createCustomer(model).then(
                              (ret) {
                            setState(() {
                              isApiCallProcess = false;
                            });

                            if (ret) {
                              FormHelper.showMessage(
                                context,
                                "WooCommerce App",
                                "Registration Successfull",
                                "Ok",
                                    () {
                                  Navigator.of(context).pop();
                                },
                              );
                            } else {
                              FormHelper.showMessage(
                                context,
                                "WooCommerce App",
                                "Email Id already registered.",
                                "Ok",
                                    () {
                                  Navigator.of(context).pop();
                                },
                              );
                            }
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
