// Basic Imports
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sp2_presentation/utils.dart' as utils;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:future_progress_dialog/future_progress_dialog.dart';

// Templates
import 'package:sp2_presentation/templates/common_assets_template.dart';
import 'package:sp2_presentation/templates/dialog_template.dart';

// Models
import 'package:sp2_presentation/models/ai_art_model.dart';

class AINumberForm extends StatefulWidget {
  final int batch;
  AINumberForm({required this.batch});
  AINumberFormState createState() => AINumberFormState(batch: this.batch);
}

class AINumberFormState extends State<AINumberForm> {
  final aiFormKey = GlobalKey<FormState>();
  final serverLinkController = TextEditingController();
  final int batch;
  AINumberFormState({required this.batch});

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
                  "Fetch Numbers",
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
                    try {
                      http.Response response = await showDialog(
                        context: context,
                        builder: (context) => FutureProgressDialog(
                          Future(
                            () async {
                              return await http.post(
                                Uri.parse(
                                  this.serverLinkController.text.trim() +
                                      "/number",
                                ),
                                body: {
                                  "batch": this.batch.toString(),
                                },
                              );
                            },
                          ),
                          message: Text(
                            'Fetching number image...',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      );
                      // Check Status
                      if (response.statusCode == 200) {
                        // Parsear body
                        Map<String, dynamic> recvJson =
                            JsonDecoder().convert(response.body);

                        // Clearing previous images
                        Provider.of<AIArtModel>(context, listen: false)
                            .encodedImages
                            .clear();

                        for (int i = 0; i < this.batch; i++) {
                          Provider.of<AIArtModel>(context, listen: false)
                              .addImage(
                                  encodedImage: recvJson[i.toString()],
                                  update: false);
                        }

                        Provider.of<AIArtModel>(context, listen: false)
                            .update();
                      } else {
                        // Reportar error
                        DialogTemplate.showMessage(
                            context: context,
                            message: "An error occurred, try again.");
                      }
                    } catch (error) {
                      print(error.toString());
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

class AINumberScreen extends StatelessWidget {
  final int batch = 10;
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
                          "AI Number Generator",
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
                AINumberForm(
                  batch: this.batch,
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
                              child: Image.memory(
                                base64.decode(
                                  aiArtModel.encodedImages[index],
                                ),
                                width: 128,
                                height: 128,
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
