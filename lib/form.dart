import 'package:flutter/material.dart';
import 'package:flutter_application_1/ProfileClass.dart';
import 'package:flutter_application_1/riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

class FormPage extends ConsumerStatefulWidget {
  const FormPage({super.key});

  @override
  ConsumerState<FormPage> createState() => _FormPageState();
}

class _FormPageState extends ConsumerState<FormPage> {
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    ref.watch(get1stFormInfoProvider);
    ref.watch(get2ndFormInfoProvider);

    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller,
            children: [
              // Container(
              //   child: Text("hed"),
              // ),
              FormFirstPage(
                nextPage: () {
                  controller.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                },
                prevPage: () {
                  controller.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                },
              ),
              FormSecondPage(
                nextPage: () {
                  controller.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                },
                prevPage: () {
                  controller.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                },
              ),
              const FinishedPage()
            ],
          ),
        ),
      ),
    );
  }
}

//1st Page
class FormFirstPage extends ConsumerStatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback prevPage;
  const FormFirstPage(
      {super.key, required this.nextPage, required this.prevPage});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FormFirstPageState();
}

class _FormFirstPageState extends ConsumerState<FormFirstPage> {
  GlobalKey<FormBuilderState> formKey = GlobalKey();

  List<String> genderList = ["Male", "Female", "Do not wish to say"];

  late Get1stFormInfo map;

  @override
  Widget build(BuildContext context) {
    map = ref.watch(get1stFormInfoProvider.notifier);

    return FormBuilder(
      key: formKey,
      initialValue: map.getState(),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'name',
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text("Name")),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              const SizedBox(
                height: 50,
              ),
              FormBuilderTextField(
                name: 'age',
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text("Age")),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              const SizedBox(
                height: 50,
              ),
              FormBuilderRadioGroup(
                name: 'gender',
                wrapDirection: Axis.vertical,
                orientation: OptionsOrientation.vertical,
                decoration: const InputDecoration(border: InputBorder.none),
                options: genderList
                    .map((lang) => FormBuilderFieldOption(
                          value: lang,
                          child: Text(
                            lang,
                          ),
                        ))
                    .toList(growable: false),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              const SizedBox(height: 100),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        widget.prevPage();
                      },
                      child: Text("Back")),
                  ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!
                            .isValid) //Check if it means the validation
                        {
                          formKey.currentState?.saveAndValidate();
                          ref //Set the Provider the state
                              .read(get1stFormInfoProvider.notifier)
                              .setInfo(formKey.currentState!.value);
                          widget.nextPage();
                        } else {
                          formKey.currentState?.validate();
                          //If got error, it will show what is the error
                        }
                      },
                      child: const Text('Next Page')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

//2nd Page
class FormSecondPage extends ConsumerStatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback prevPage;
  const FormSecondPage(
      {super.key, required this.nextPage, required this.prevPage});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FormSecondPageState();
}

class _FormSecondPageState extends ConsumerState<FormSecondPage> {
  GlobalKey<FormBuilderState> formKey = GlobalKey();

  List<String> occupationList = [
    'Delivery Drivers',
    'Rideshare or Uber Drivers',
    'Commercial Drivers',
    'Emergency Services Personnel',
    'Medical Professionals',
    'Teachers and Educators',
    'Military Personnel',
    'Engineers and Scientists',
    'Lawyers and Accountants',
    'Agricultural Workers',
    'Entertainment Industry Professionals',
    'Sales Representatives',
    'Construction Workers',
    'Public Service Employees',
    'Athletes',
    'Others',
  ];
  bool occupationOthers = false;

  late Get2ndFormInfo map;

  @override
  Widget build(BuildContext context) {
    map = ref.watch(get2ndFormInfoProvider.notifier);

    return FormBuilder(
      key: formKey,
      initialValue: map.getState(),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              FormBuilderDropdown(
                name: 'occupation',
                onChanged: (value) {
                  if (value == "Others") {
                    setState(() {
                      occupationOthers = true;
                    });
                  } else {
                    setState(() {
                      occupationOthers = false;
                    });
                  }
                },
                items: occupationList
                    .map((use) => DropdownMenuItem(
                          alignment: AlignmentDirectional.center,
                          value: use,
                          child: Text(
                            use,
                          ),
                        ))
                    .toList(),
                decoration: InputDecoration(
                    border: OutlineInputBorder(), label: Text("Occupation")),
              ),
              const SizedBox(
                height: 50,
              ),
              Visibility(
                visible: occupationOthers == true ? true : false,
                child: FormBuilderTextField(
                  name: 'occupationOthers',
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), label: Text("Others")),
                  validator: FormBuilderValidators.compose(dropDownValidator()),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              FormBuilderTextField(
                name: 'height',
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text("Height")),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              const SizedBox(
                height: 50,
              ),
              FormBuilderTextField(
                name: 'weight',
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text("Weight")),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              const SizedBox(height: 100),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        widget.prevPage();
                      },
                      child: Text("Back")),
                  ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!
                            .isValid) //Check if it means the validation
                        {
                          formKey.currentState!.saveAndValidate();
                          ref //Set the Provider the state
                              .read(get2ndFormInfoProvider.notifier)
                              .setInfo(formKey.currentState!.value);
                          // ref
                          //     .read(getProfileListProvider.notifier)
                          //     .addPersons()

                          widget.nextPage();
                        } else {
                          formKey.currentState!.validate();
                          //If got error, it will show what is the error
                        }
                      },
                      child: const Text('Submit')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  List<String? Function(String?)> dropDownValidator() {
    if (occupationOthers) {
      return [
        FormBuilderValidators.required(),
      ];
    } else {
      return [];
    }
  }
}

class FinishedPage extends ConsumerStatefulWidget {
  const FinishedPage({super.key});

  @override
  ConsumerState<FinishedPage> createState() => _FinishedPageState();
}

class _FinishedPageState extends ConsumerState<FinishedPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text("ERROR");
        } else {
          return Center(
              child: Column(
            children: [
              Text("Added"),
              ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).goNamed('home');
                  },
                  child: Text("Go back"))
            ],
          ));
        }
      },
      future: ref.read(getProfileListProvider.notifier).addPersons(),
    );
  }
}
