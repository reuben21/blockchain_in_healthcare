import 'package:bic_android_web_support/providers/ipfs.dart';
import 'package:bic_android_web_support/screens/screens_auth/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class HospitalDetailScreen extends StatefulWidget {
  static const routeName = '/hospital-detail-screen';

  const HospitalDetailScreen({Key? key}) : super(key: key);

  @override
  _HospitalDetailScreenState createState() => _HospitalDetailScreenState();
}

class _HospitalDetailScreenState extends State<HospitalDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  Widget formBuilderTextFieldWidget(
      TextInputType inputTextType,
      String initialValue,
      String fieldName,
      String labelText,
      Image icon,
      bool obscure,
      List<FormFieldValidator> validators) {
    return FormBuilderTextField(
      keyboardType: inputTextType,
      initialValue: initialValue,
      obscureText: obscure,
      maxLines: 1,
      name: fieldName,
      // allowClear:
      // color:Colors.grey,

      decoration: InputDecoration(
        // helperText: 'hello',
        labelText: labelText,
        prefixIcon: icon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        labelStyle: const TextStyle(
          color: Color(0xFF6200EE),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF6200EE)),
          borderRadius: BorderRadius.circular(25.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF6200EE)),
          borderRadius: BorderRadius.circular(25.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF6200EE)),
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),

      // valueTransformer: (text) => num.tryParse(text),
      validator: FormBuilderValidators.compose(validators),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      // ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              SingleChildScrollView(
                child: Background(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Doctors Detail',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        // SizedBox(height: size.height * 0.03),
                        FormBuilder(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(
                                    height: 35,
                                  ),
                                  // Center(
                                  //     child: kIsWeb
                                  //         ? Image.asset(
                                  //             "assets/icons/signup.svg",
                                  //             width: 500,
                                  //             height: 500,
                                  //           )
                                  //         : Image.asset("assets/images/sign_up.png")),
                                  const SizedBox(
                                    height: 10,
                                  ),

                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: formBuilderTextFieldWidget(
                                          TextInputType.text,
                                          'Ankita Tripathi',
                                          'name',
                                          'Full Name',
                                          Image.asset(
                                              "assets/icons/name-100.png",
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              scale: 4,
                                              width: 15,
                                              height: 15),
                                          false,
                                          [
                                            FormBuilderValidators.required(
                                                context),
                                          ])),
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: formBuilderTextFieldWidget(
                                          TextInputType.number,
                                          '40',
                                          'age',
                                          'Age',
                                          Image.asset(
                                              "assets/icons/at-sign-100.png",
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              scale: 4,
                                              width: 15,
                                              height: 15),
                                          false,
                                          [
                                            FormBuilderValidators.required(
                                                context),
                                          ])),
                                  Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: formBuilderTextFieldWidget(
                                          TextInputType.streetAddress,
                                          'skldfjf',
                                          'address',
                                          'Address',
                                          Image.asset(
                                              "assets/icons/key-100.png",
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              scale: 4,
                                              width: 15,
                                              height: 15),
                                          false,
                                          [
                                            FormBuilderValidators.required(
                                                context),
                                          ])),
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: FormBuilderDropdown(
                                      initialValue: 'Female',
                                      name: 'gender',
                                      decoration: InputDecoration(
                                        labelText: "Gender",
                                        prefixIcon: Image.asset(
                                            "assets/icons/user-100.png",
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            scale: 4,
                                            width: 15,
                                            height: 15),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                        ),
                                        labelStyle: const TextStyle(
                                          color: Color(0xFF6200EE),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFF6200EE)),
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFF6200EE)),
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFF6200EE)),
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                        ),
                                      ),
                                      // initialValue: 'Male',

                                      allowClear: true,

                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(context)
                                      ]),
                                      items: [
                                        'Male',
                                        'Female',
                                      ]
                                          .map((gender) => DropdownMenuItem(
                                                value: gender,
                                                child: Text('$gender'),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: size.width * 0.8,
                          child: FloatingActionButton.extended(
                            heroTag: "StoreHospitalDetailScreen",
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.secondary,
                            onPressed: () async {
                              _formKey.currentState?.save();
                              if (_formKey.currentState?.validate() != null) {
                                // _formKey.currentState?.value["name"];
                                // _formKey.currentState?.value["age"];
                                // _formKey.currentState?.value["address"];
                                // _formKey.currentState?.value["gender"];

                                Map<String, dynamic> objText = {
                                  "firstName":
                                      _formKey.currentState?.value["name"],
                                  "age": _formKey.currentState?.value["age"],
                                  "address":
                                      _formKey.currentState?.value["address"],
                                  "gender":
                                      _formKey.currentState?.value["gender"],
                                  // "lastName4": ["Coutinho", "Coutinho", "Coutinho"],
                                  // "age": 30
                                };
                                var hashReceived = await Provider.of<IPFSModel>(
                                        context,
                                        listen: false)
                                    .sendData(objText);
                                print("hashReceived ------" +
                                    hashReceived.toString());
                              } else {
                                print("validation failed");
                              }
                            },
                            icon: Image.asset("assets/icons/sign_in.png",
                                color: Theme.of(context).colorScheme.secondary,
                                width: 25,
                                fit: BoxFit.fill,
                                height: 25),
                            label: const Text('Store Details'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
