import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logistics/data/models/response/user_model.dart';
import 'package:logistics/services/extensions.dart';
import 'package:logistics/services/route_helper.dart';
import 'package:logistics/services/theme.dart';
import 'package:logistics/views/base/common_button.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../controllers/auth_controller.dart';
import '../../../generated/assets.dart';
import '../../../services/input_decoration.dart';
import '../DashBoard/dashboard.dart';
import 'package:open_file/open_file.dart';

class RegisterUserPage extends StatefulWidget {
  final UserModel? user;

  const RegisterUserPage({super.key, this.user});

  @override
  State<RegisterUserPage> createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  @override
  void initState() {
    super.initState();
    final user = widget.user;

    if (user != null) {
      nameController.text = user.name ?? '';
      emailController.text = user.email ?? '';
      companyNameController.text = user.companyName ?? '';
      gstinNumberController.text = user.gstNumber ?? '';
      phoneController.text = user.phone ?? '';
      _isExpanded = (user.companyName?.isNotEmpty ?? false) ||
          (user.gstNumber?.isNotEmpty ?? false);
    } else {
      phoneController.text = Get.find<AuthController>().numberController.text;
    }
  }

  final _formKey = GlobalKey<FormState>();
  bool _isExpanded = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController gstinNumberController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  File? gstinCertificate;
  File? msmeCertificate;

  Future<void> _openFile(File file) async {
    try {
      await OpenFile.open(file.path);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Unable to open file.');
    }
  }

  Future<void> _showFilePickerDialog({required Function(File) onPicked}) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: Colors.grey[700],
                ),
                title: Text('Take a photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final image = await _pickFromCamera();
                  if (image != null && mounted) {
                    onPicked(image);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.attach_file),
                title: Text('Choose file (PDF/Image)'),
                onTap: () async {
                  Navigator.pop(context);
                  final file = await _pickFile();
                  if (file != null) onPicked(file);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<File?> _pickFromCamera() async {
    try {
      var status = await Permission.camera.status;
      if (!status.isGranted) {
        status = await Permission.camera.request();
        if (!status.isGranted) {
          Fluttertoast.showToast(msg: 'Camera permission is required.');
          return null;
        }
      }

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile == null) {
        Fluttertoast.showToast(msg: 'No image selected.');
        return null;
      }

      log(pickedFile.path);
      return File(pickedFile.path);
    } catch (e) {
      log('Error picking image from camera: $e');
      Fluttertoast.showToast(msg: 'Failed to capture image.');
      return null;
    }
  }

  Future<File?> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    return result != null && result.files.single.path != null
        ? File(result.files.single.path!)
        : null;
  }

  void onContinue() async {
    if (_formKey.currentState!.validate()) {
      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final company = companyNameController.text.trim();
      final gstno = gstinNumberController.text.trim();

      dynamic data = {
        "name": name,
        "email": email,
        "company_name": company,
        "gst_number": gstno,
        "gst_certificate": gstinCertificate != null
            ? MultipartFile(gstinCertificate,
                filename: gstinCertificate!.path.fileName)
            : null,
        'msme_certificate': msmeCertificate != null
            ? MultipartFile(msmeCertificate,
                filename: msmeCertificate!.path.fileName)
            : null,
      };
      log('$data');

      Get.find<AuthController>()
          .registerUser(FormData(data))
          .then((value) async {
        if (value.isSuccess) {
          Get.find<AuthController>().getStates();
          await Get.find<AuthController>().getUserProfileData().then((value) {
            Navigator.pushAndRemoveUntil(
              context,
              getCustomRoute(child: Dashboard()),
              (route) => false,
            );
          });
        } else {
          Fluttertoast.showToast(msg: value.message);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Center(child: SvgPicture.asset(Assets.imagesRegisterusersvg)),
                  SizedBox(height: 25),
                  Text(
                    "Let's Get to Know\n You Better",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(fontWeight: FontWeight.normal, fontSize: 25),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Share your preferences, and we’ll ensure quick and easy deliveries.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                  SizedBox(height: 25),
                  TextFormField(
                    style: Theme.of(context).textTheme.labelLarge,
                    controller: nameController,
                    validator: (value) =>
                        value!.isEmpty ? 'Name is required' : null,
                    decoration: CustomDecoration.inputDecoration(
                      borderRadius: 8,
                      floating: true,
                      label: 'Name',
                      icon: Icon(Icons.person_outline,
                          size: 20, color: Colors.grey[700]),
                      hint: 'Enter Your Name',
                      labelStyle: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: Colors.grey[500]),
                      hintStyle: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: Colors.grey[500]),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    style: Theme.of(context).textTheme.labelLarge,
                    controller: emailController,
                    decoration: CustomDecoration.inputDecoration(
                      floating: true,
                      label: 'Email (Optional)',
                      icon: Icon(Icons.email_outlined,
                          size: 20, color: Colors.grey[700]),
                      hint: 'Enter Your Email',
                      labelStyle: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: Colors.grey[500]),
                      hintStyle: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: Colors.grey[500]),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: Colors.grey[500]),
                    controller: phoneController,
                    enabled: false,
                    decoration: CustomDecoration.inputDecoration(
                      floating: true,
                      label: 'Mobile Number',
                      icon:
                          Icon(Icons.phone, size: 20, color: Colors.grey[700]),
                      hint: '+91 25652 232262',
                      labelStyle: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: Colors.grey[500]),
                      hintStyle: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: Colors.grey[500]),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Container(
                      color: primaryColor,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Row(
                        children: [
                          Icon(Icons.add, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Complete your additional information.',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "poppins",
                                fontSize: 12),
                          ),
                          Spacer(),
                          Icon(
                              _isExpanded
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  if (_isExpanded) ...[
                    SizedBox(height: 20),
                    TextFormField(
                      style: Theme.of(context).textTheme.labelLarge,
                      controller: companyNameController,
                      decoration: CustomDecoration.inputDecoration(
                        floating: true,
                        label: 'Company Name',
                        icon: Icon(Icons.business,
                            size: 20, color: Colors.grey[700]),
                        hint: 'Company Name',
                        labelStyle: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: Colors.grey[500]),
                        hintStyle: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: Colors.grey[500]),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      style: Theme.of(context).textTheme.labelLarge,
                      controller: gstinNumberController,
                      decoration: CustomDecoration.inputDecoration(
                        floating: true,
                        label: 'GSTIN Number',
                        icon: Icon(Icons.numbers,
                            size: 20, color: Colors.grey[700]),
                        hint: '0000000000000000',
                        labelStyle: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: Colors.grey[500]),
                        hintStyle: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: Colors.grey[500]),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      readOnly: true,
                      onTap: () async {
                        if (gstinCertificate != null) {
                          await _openFile(gstinCertificate!);
                        } else {
                          _showFilePickerDialog(
                            onPicked: (file) =>
                                setState(() => gstinCertificate = file),
                          );
                        }
                      },
                      style: Theme.of(context).textTheme.labelLarge,
                      decoration: CustomDecoration.inputDecoration(
                        floating: true,
                        label: 'GSTIN Certificate',
                        icon: Icon(Icons.file_copy_outlined,
                            size: 20, color: Colors.grey[700]),
                        hint: gstinCertificate != null
                            ? gstinCertificate!.path.split('/').last
                            : 'Choose File',
                        suffix: gstinCertificate != null
                            ? IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    setState(() => gstinCertificate = null),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                    right: 15.0, top: 12.0),
                                child: Text("Select File",
                                    style: TextStyle(color: Colors.blue)),
                              ),
                        labelStyle: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: Colors.grey[500]),
                        hintStyle:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: gstinCertificate == null
                                      ? Colors.grey[500]
                                      : Colors.black,
                                ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      readOnly: true,
                      onTap: () async {
                        if (msmeCertificate != null) {
                          await _openFile(msmeCertificate!);
                        } else {
                          _showFilePickerDialog(
                            onPicked: (file) =>
                                setState(() => msmeCertificate = file),
                          );
                        }
                      },
                      style: Theme.of(context).textTheme.labelLarge,
                      decoration: CustomDecoration.inputDecoration(
                        floating: true,
                        label: 'MSME Certificate',
                        icon: Icon(Icons.file_copy_outlined,
                            size: 20, color: Colors.grey[700]),
                        hint: msmeCertificate != null
                            ? msmeCertificate!.path.split('/').last
                            : 'Choose File',
                        suffix: msmeCertificate != null
                            ? IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    setState(() => msmeCertificate = null),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                    right: 15.0, top: 12.0),
                                child: Text("Select File",
                                    style: TextStyle(color: Colors.blue)),
                              ),
                        labelStyle: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: Colors.grey[500]),
                        hintStyle: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                color: msmeCertificate == null
                                    ? Colors.grey[500]
                                    : Colors.black),
                      ),
                    ),
                  ],
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomButton(
                      isLoading: Get.find<AuthController>().isLoading,
                      onTap: onContinue,
                      title: "Continue",
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

