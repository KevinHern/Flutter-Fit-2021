// Basic Imports
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sp2_presentation/utils.dart' as utils;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:file_picker/file_picker.dart';

// Templates
import 'package:sp2_presentation/templates/common_assets_template.dart';
import 'package:sp2_presentation/templates/dialog_template.dart';

// Models
import 'package:sp2_presentation/models/ai_transform_model.dart';

class AIDay2NightForm extends StatefulWidget {
  final int batch;
  AIDay2NightForm({required this.batch});
  AIDay2NightFormState createState() => AIDay2NightFormState(batch: this.batch);
}

class AIDay2NightFormState extends State<AIDay2NightForm> {
  final aiFormKey = GlobalKey<FormState>();
  final serverLinkController = TextEditingController();
  final int batch;
  AIDay2NightFormState({required this.batch});

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
                  "Pick and Transform",
                  style: TextStyle(
                    fontFamily:
                        Theme.of(context).textTheme.bodyText1!.fontFamily,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  if (this.aiFormKey.currentState!.validate()) {
                    // Selecting File
                    var picked = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['jpg', 'jpeg'],
                      withReadStream: true,
                      allowMultiple: false,
                      withData: true,
                    );

                    if (picked != null) {
                      Provider.of<AITransformModel>(context, listen: false)
                          .clear();

                      // Creating request
                      final request = http.MultipartRequest(
                        "POST",
                        Uri.parse(
                            this.serverLinkController.text.trim() + "/d2n"),
                      );

                      // Adding selected file
                      request.files.add(
                        http.MultipartFile(
                          "filebytes",
                          picked.files.first.readStream!,
                          picked.files.first.size,
                          filename: picked.files.first.name,
                        ),
                      );

                      http.Response response = await showDialog(
                        context: context,
                        builder: (context) => FutureProgressDialog(
                          Future(
                            () async {
                              try {
                                // Send request
                                http.StreamedResponse response =
                                    await request.send();

                                return await http.Response.fromStream(response);
                              } catch (error) {
                                print(error.toString());
                                return null;
                              }
                            },
                          ),
                          message: Text(
                            'Transforming landscape image...',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      );

                      if (response.statusCode == 200) {
                        // Parsear body
                        Map<String, dynamic> recvJson =
                            JsonDecoder().convert(response.body);

                        // Clearing previous images
                        Provider.of<AITransformModel>(context, listen: false)
                            .encodedNew = base64.decode(
                          recvJson["file64"],
                        );

                        Provider.of<AITransformModel>(context, listen: false)
                            .update();
                      } else {
                        // Reportar error
                        DialogTemplate.showMessage(
                            context: context,
                            message: "An error occurred, try again.");
                      }
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

class AIDay2NightScreen extends StatelessWidget {
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
        child: ChangeNotifierProvider<AITransformModel>(
          create: (context) => AITransformModel(),
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
                          "AI Transformer",
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
                AIDay2NightForm(
                  batch: this.batch,
                ),
                ResponsiveDivider(),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Consumer<AITransformModel>(
                    builder: (_, aiTransformModel, __) {
                      return ListView(
                        padding: const EdgeInsets.all(8.0),
                        children: [
                          Card(
                            elevation: 5.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  AutoSizeText(
                                    "Transformed",
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
                                  (aiTransformModel.encodedNew == null)
                                      ? Container()
                                      : Image.memory(
                                          aiTransformModel.encodedNew!,
                                          width: 256,
                                          height: 256,
                                          colorBlendMode: BlendMode.color,
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
