// Basic Imports
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sp2_presentation/utils.dart' as utils;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:future_progress_dialog/future_progress_dialog.dart';

// Templates
import 'package:sp2_presentation/templates/common_assets_template.dart';
import 'package:sp2_presentation/templates/dialog_template.dart';

// Models
import 'package:sp2_presentation/models/ai_art_model.dart';

class AIArtForm extends StatefulWidget {
  final List<String> weights;
  AIArtForm({required this.weights});

  AIArtFormState createState() => AIArtFormState(weights: this.weights);
}

class AIArtFormState extends State<AIArtForm> {
  final aiFormKey = GlobalKey<FormState>();
  final activationFunctionController = TextEditingController();
  final serverLinkController = TextEditingController();
  final List<String> weights;

  AIArtFormState({required this.weights});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: this.aiFormKey,
      child: Card(
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: "AI Server Link",
                  icon: Icon(Icons.wifi),
                  labelText: "AI Server Link",
                ),
                style: Theme.of(context).textTheme.bodyText1,
                controller: this.serverLinkController,
                validator: (String? value) {
                  if (value == null)
                    return null;
                  else
                    return (value.trim().isEmpty) ? 'Select an option' : null;
                },
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(
                height: 4.0,
              ),
              ListTile(
                contentPadding: const EdgeInsets.all(0.0),
                title: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Activation Function",
                    icon: Icon(Icons.multiline_chart),
                    labelText: "Activation Function",
                  ),
                  style: Theme.of(context).textTheme.bodyText1,
                  controller: this.activationFunctionController,
                  readOnly: true,
                  validator: (String? value) {
                    if (value == null)
                      return null;
                    else
                      return (value.trim().isEmpty) ? 'Select an option' : null;
                  },
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).accentColor,
                    shadowColor: Colors.black26,
                  ),
                  child: Icon(Icons.edit),
                  onPressed: () => DialogTemplate.showSelectOptions(
                    context: context,
                    title: 'Options',
                    options: const [0, 1, 2],
                    captions: const ['tanh', 'relu', 'sigmoid'],
                    aftermath: (index) => this
                        .activationFunctionController
                        .text = (const ['tanh', 'relu', 'sigmoid'])[index],
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).accentColor,
                  shadowColor: Colors.black26,
                ),
                icon: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                label: Text(
                  "Fetch Images",
                  style: TextStyle(
                    fontFamily:
                        Theme.of(context).textTheme.bodyText1!.fontFamily,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  if (this.aiFormKey.currentState!.validate()) {
                    // Sending POST request
                    http.Response response = await showDialog(
                      context: context,
                      builder: (context) => FutureProgressDialog(
                        Future(
                          () async {
                            return await http.post(
                              Uri.parse(
                                this.serverLinkController.text + "/art",
                              ),
                              body: {
                                "actfunc":
                                    this.activationFunctionController.text,
                              },
                            );
                          },
                        ),
                        message: Text(
                          'Fetching images...',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    );

                    // Check Status
                    if (response.statusCode == 200) {
                      // Parsear body
                      Map<String, dynamic> recvJson =
                          JsonDecoder().convert(response.body);

                      // const weights = ["0.1", "0.25", "0.5", "0.75", "1.0",
                      //   "5.0", "10.0", "20.0", "50.0", "100.0"];

                      // Clearing previous images
                      Provider.of<AIArtModel>(context, listen: false)
                          .encodedImages
                          .clear();

                      for (String weight in this.weights) {
                        Provider.of<AIArtModel>(context, listen: false)
                            .addImage(
                                encodedImage: recvJson["w" + weight],
                                update: false);
                      }
                      Provider.of<AIArtModel>(context, listen: false).update();
                    } else {
                      // Reportar error
                      DialogTemplate.showMessage(
                          context: context,
                          message: "An error occurred, try again.");
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AIArtScreen extends StatelessWidget {
  final List<String> weights = const [
    "0.1",
    "0.25",
    "0.5",
    "0.75",
    "1.0",
    "5.0",
    "10.0",
    "20.0",
    "50.0",
    "100.0"
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Padding(
        padding: utils.MyUtils.setScreenPadding(context: context),
        child: ChangeNotifierProvider<AIArtModel>(
          create: (context) => AIArtModel(),
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.025,
                  ),
                  child: Card(
                    elevation: 5,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: AutoSizeText(
                          "AI Generative Art",
                          style: TextStyle(
                            fontFamily: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .fontFamily,
                            fontSize: 30,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                AIArtForm(
                  weights: this.weights,
                ),
                ResponsiveDivider(),
                Container(
                  height: MediaQuery.of(context).size.height * 0.39,
                  child: Consumer<AIArtModel>(
                    builder: (_, aiArtModel, __) {
                      return ListView.builder(
                        itemCount: aiArtModel.encodedImages.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 5.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  AutoSizeText(
                                    "Weights: ±" + this.weights[index],
                                    style: TextStyle(
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .fontFamily,
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    maxLines: 1,
                                  ),
                                  const SizedBox(
                                    height: 16.0,
                                  ),
                                  Image.memory(
                                    base64.decode(
                                      aiArtModel.encodedImages[index],
                                    ),
                                    width: 128,
                                    height: 128,
                                    colorBlendMode: BlendMode.color,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
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
}
