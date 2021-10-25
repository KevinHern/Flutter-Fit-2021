// Basic Imports
import 'package:flutter/material.dart';
import 'package:sp2_presentation/utils.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

// Templates
import 'package:sp2_presentation/templates/dialog_template.dart';

class ProfileSettingsFormScreen extends StatefulWidget {
  ProfileSettingsFormScreenState createState() =>
      ProfileSettingsFormScreenState();
}

class ProfileSettingsFormScreenState extends State<ProfileSettingsFormScreen> {
  final profileKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: this.profileKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Email",
                  icon: Icon(Icons.email),
                  labelText: "Email",
                ),
                style: Theme.of(context).textTheme.bodyText1,
                controller: this.emailController,
                validator: (String? value) {
                  return (value == null)
                      ? null
                      : (value.trim().isEmpty)
                          ? 'Please, provide an email'
                          : (!RegExp(".+@[a-z]+(\.[a-z]+)+").hasMatch(value))
                              ? "A valid email is required"
                              : null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Password",
                  icon: Icon(Icons.vpn_key),
                  labelText: "Password",
                ),
                style: Theme.of(context).textTheme.bodyText1,
                controller: this.passwordController,
                obscureText: true,
                textInputAction: TextInputAction.done,
                validator: (String? value) {
                  if (value == null)
                    return null;
                  else
                    return (value.trim().isEmpty)
                        ? 'Provide a password'
                        : (value.length < 6)
                            ? "The password's length must be at least 6 characters long"
                            : null;
                },
              ),
              const SizedBox(
                height: 24.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(
                      Icons.highlight_remove,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Reset",
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.bodyText1!.fontFamily,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      this.emailController.text = "";
                      this.passwordController.text = "";
                    },
                  ),
                  ElevatedButton.icon(
                    icon: Icon(
                      Icons.update,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Update",
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.bodyText1!.fontFamily,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      if (this.profileKey.currentState!.validate()) {
                        await showDialog(
                          context: context,
                          builder: (context) => FutureProgressDialog(
                            Future.delayed(const Duration(seconds: 1)),
                            message: Text(
                              'Updating your information...',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        );
                        DialogTemplate.showMessage(
                            context: context,
                            message:
                                "Your information has been updated successfully.");
                      }
                    },
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

class ProfileScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: ListView(
        padding: MyUtils.setScreenPadding(context: context),
        children: [
          Card(
            elevation: 5,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  "Account",
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyText1,
                    children: [
                      TextSpan(
                        text: "Email:\n",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      TextSpan(
                        text: "*Insert some email here*\n\n",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      TextSpan(
                        text: "Name(s):\n",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      TextSpan(
                        text: "Dummy Test\n\n",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      TextSpan(
                        text: "Last Name(s):\n",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      TextSpan(
                        text: "McLast Name\n\n",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      TextSpan(
                        text: "ID:\n",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      TextSpan(
                        text: "*Insert some ID here*\n\n",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      TextSpan(
                        text: "Field A:\n",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      TextSpan(
                        text: "*Insert some relevant info here*\n\n",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      TextSpan(
                        text: "Field B:\n",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      TextSpan(
                        text: "*Insert some relevant info here*\n\n",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      TextSpan(
                        text: "Field C:\n",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      TextSpan(
                        text: "*Insert some relevant info here*\n\n",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      TextSpan(
                        text: "Field D:\n",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      TextSpan(
                        text: "*Insert some relevant info here*",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: 24.0,
                horizontal: MediaQuery.of(context).size.width * 0.05),
            child: Divider(
              color: Colors.black54,
              thickness: 1.5,
            ),
          ),
          Card(
            elevation: 5,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  "Configure",
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          ProfileSettingsFormScreen(),
        ],
      ),
    );
  }
}
