import 'dart:io';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_diagnosis_system/services/api.dart';
import 'package:medical_diagnosis_system/widgets/custom_button.dart';
import 'package:medical_diagnosis_system/widgets/custom_text_field.dart';
import '../constants.dart';
import '../helper/helper_functions.dart';

class AIPage extends StatefulWidget {
  const AIPage({super.key});

  @override
  State<AIPage> createState() => _AIPageState();
}

class _AIPageState extends State<AIPage> {
  File? img;
  dynamic pickedFile;

  String? predictionImage;
  String? diseaseStatusImage;
  double accuracyImage = 0;

  String? text;
  String? predictionText;
  String? diseaseStatusText;
  double accuracyText = 0;

  bool _isLoading1 = false;
  bool _isLoading2 = false;

  int _page = 0;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        unFocus(context);
        controllerNLP.clear();
        return true;
      },
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0 && _page == 1) {
            Feedback.forTap(context);
            setState(() {
              _page = 0;
              unFocus(context);
            });
          } else if (details.primaryVelocity! < 0 && _page == 0) {
            Feedback.forTap(context);
            setState(() {
              _page = 1;
              unFocus(context);
            });
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Column(
                  children: [
                    SizedBox(
                      height: 35,
                      width: 50,
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.screenshot_outlined)),
                    ),
                    const Text(
                      'Save Results',
                      style: TextStyle(fontSize: 12, fontFamily: 'Pacifico'),
                    )
                  ],
                ),
              ),
            ],
            backgroundColor: kPrimaryColor,
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                unFocus(context);
                controllerNLP.clear();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            title: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'A',
                  style: TextStyle(fontSize: 32, color: kSecondaryColor),
                ),
                Text(
                  'I Page',
                  style: TextStyle(
                      fontSize: 27,
                      color: kSecondaryColor,
                      fontFamily: 'Pacifico'),
                ),
              ],
            ),
          ),
          bottomNavigationBar: CurvedNavigationBar(
            index: _page,
            height: 55,
            letIndexChange: (index) => true,
            animationDuration: const Duration(milliseconds: 300),
            color: kPrimaryColor,
            backgroundColor: Colors.white,
            items: const <Widget>[
              Icon(FontAwesomeIcons.brain, color: Colors.white),
              Icon(Icons.text_fields, color: Colors.white),
            ],
            onTap: (value) {
              Feedback.forTap(context);
              setState(() {
                _page = value;
                unFocus(context);
              });
            },
          ),
          floatingActionButton: _isLoading1 || _page == 1
              ? const SizedBox()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton(
                      backgroundColor: kPrimaryColor,
                      tooltip: 'Gallery',
                      onPressed: () async {
                        // img is changed because the setState
                        img = await pickImage(
                            imageSource: ImageSource.gallery,
                            pickedFile: pickedFile);

                        setState(() {
                          _isLoading1 = true;
                        });

                        // await Future.delayed(const Duration(seconds: 1));
                        if (img != null) {
                          await API.predictImage(img: img!);
                        }

                        setState(() {
                          predictionImage = API.predictionImage;
                          diseaseStatusImage = API.diseaseStatusImage;
                          accuracyImage =
                              (API.accuracyImage * 1000).round() / 1000;
                          _isLoading1 = false;
                        });
                      },
                      child: const Icon(Icons.image),
                    ),
                    const SizedBox(height: 7),
                    FloatingActionButton(
                      backgroundColor: kPrimaryColor,
                      tooltip: 'Camera',
                      onPressed: () async {
                        img = await pickImage(
                            imageSource: ImageSource.camera,
                            pickedFile: ImageSource.camera);

                        setState(() {
                          _isLoading1 = true;
                        });

                        // await Future.delayed(const Duration(seconds: 1));
                        if (img != null) {
                          await API.predictImage(img: img!);
                        }

                        setState(() {
                          predictionImage = API.predictionImage;
                          diseaseStatusImage = API.diseaseStatusImage;
                          accuracyImage =
                              (API.accuracyImage * 1000).round() / 1000;
                          _isLoading1 = false;
                        });
                      },
                      child: const Icon(Icons.camera_alt),
                    ),
                  ],
                ),
          body: _page == 0
              ? _isLoading1 == true
                  ? const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Processing... ',
                            style: TextStyle(
                                fontSize: 30,
                                color: kPrimaryColor,
                                fontFamily: 'Pacifico'),
                          ),
                          CircularProgressIndicator(
                            color: kPrimaryColor,
                            backgroundColor: Colors.grey,
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        const Text(
                          'Predict Image',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 30,
                              color: kPrimaryColor,
                              fontFamily: 'Pacifico'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 25, right: 50, left: 50),
                          child: SizedBox(
                            height: 300,
                            child: Card(
                              elevation: 10,
                              child: img == null
                                  ? Image.asset(kDefaultImage, cacheHeight: 300)
                                  : Image.file(img!, cacheHeight: 300),
                            ),
                          ),
                        ),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Patient Status :   ',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: kPrimaryColor,
                                    fontFamily: 'Pacifico'),
                              ),
                              Text(
                                diseaseStatusImage ?? 'Status',
                                style: diseaseStatusImage == null
                                    ? const TextStyle(
                                        fontSize: 20,
                                        color: kPrimaryColor,
                                        fontFamily: 'Pacifico',
                                      )
                                    : diseaseStatusImage == 'Healthy'
                                        ? const TextStyle(
                                            fontSize: 20,
                                            color: Colors.green,
                                            fontWeight: FontWeight.w900,
                                          )
                                        : const TextStyle(
                                            fontSize: 20,
                                            color: Colors.red,
                                            fontWeight: FontWeight.w900,
                                          ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Brain Cancer type :   ',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: kPrimaryColor,
                                    fontFamily: 'Pacifico'),
                              ),
                              Text(
                                predictionImage ?? 'Type',
                                style: predictionImage == null
                                    ? const TextStyle(
                                        fontSize: 20,
                                        color: kPrimaryColor,
                                        fontFamily: 'Pacifico',
                                      )
                                    : predictionImage == 'no_tumor'
                                        ? const TextStyle(
                                            fontSize: 20,
                                            color: Colors.green,
                                            fontWeight: FontWeight.w900,
                                          )
                                        : const TextStyle(
                                            fontSize: 20,
                                            color: Colors.red,
                                            fontWeight: FontWeight.w900,
                                          ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Text(
                            'Acuuracy :   $accuracyImage%',
                            style: const TextStyle(
                              fontSize: 20,
                              color: kPrimaryColor,
                              fontFamily: 'Pacifico',
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        // CustomButton2(
                        //   buttonText: 'About Diseases',
                        //   onPressed: () {},
                        // ),
                        const SizedBox(height: 50),
                      ],
                    )
              : _isLoading2 == true
                  ? const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Processing... ',
                            style: TextStyle(
                                fontSize: 30,
                                color: kPrimaryColor,
                                fontFamily: 'Pacifico'),
                          ),
                          CircularProgressIndicator(
                            color: kPrimaryColor,
                            backgroundColor: Colors.grey,
                          ),
                        ],
                      ),
                    )
                  : Form(
                      key: formKey,
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          const Text(
                            'Predict Text',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30,
                                color: kPrimaryColor,
                                fontFamily: 'Pacifico'),
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: controllerNLP,
                            maxLines: 12,
                            maxLength: 50000,
                            isNLPText: true,
                            icon: Icons.text_fields,
                            onChanged: (data) {
                              text = data;
                            },
                          ),
                          const SizedBox(height: 25),
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Patient Status :   ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: kPrimaryColor,
                                      fontFamily: 'Pacifico'),
                                ),
                                Text(
                                  diseaseStatusText ?? 'Status',
                                  style: diseaseStatusText == null
                                      ? const TextStyle(
                                          fontSize: 20,
                                          color: kPrimaryColor,
                                          fontFamily: 'Pacifico',
                                        )
                                      : diseaseStatusText == 'Healthy'
                                          ? const TextStyle(
                                              fontSize: 20,
                                              color: Colors.green,
                                              fontWeight: FontWeight.w900,
                                            )
                                          : const TextStyle(
                                              fontSize: 20,
                                              color: Colors.red,
                                              fontWeight: FontWeight.w900,
                                            ),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Cancer type :   ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: kPrimaryColor,
                                      fontFamily: 'Pacifico'),
                                ),
                                Text(
                                  predictionText ?? 'Type',
                                  style: predictionText == null
                                      ? const TextStyle(
                                          fontSize: 20,
                                          color: kPrimaryColor,
                                          fontFamily: 'Pacifico',
                                        )
                                      : predictionText == 'no_tumor'
                                          ? const TextStyle(
                                              fontSize: 20,
                                              color: Colors.green,
                                              fontWeight: FontWeight.w900,
                                            )
                                          : const TextStyle(
                                              fontSize: 20,
                                              color: Colors.red,
                                              fontWeight: FontWeight.w900,
                                            ),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Text(
                              'Acuuracy :   $accuracyText%',
                              style: const TextStyle(
                                fontSize: 20,
                                color: kPrimaryColor,
                                fontFamily: 'Pacifico',
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          CustomButton2(
                            buttonText: 'Predict',
                            isEnabled: false,
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading2 = true;
                                });

                                // await Future.delayed(const Duration(seconds: 1));
                                if (text != null) {
                                  await API.predictText(text: text!);
                                }

                                setState(() {
                                  predictionText = API.predictionText;
                                  diseaseStatusText = API.diseaseStatusText;
                                  accuracyText =
                                      (API.accuracyText * 1000).round() / 1000;
                                  _isLoading2 = false;
                                });
                              } else {
                                showSnackBar(
                                  context,
                                  message: 'Text field is Empty!',
                                );
                              }
                            },
                          ),
                          // const SizedBox(height: 10),
                          // CustomButton2(
                          //   buttonText: 'About Diseases',
                          //   onPressed: () {},
                          // ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
