import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logistics/services/extensions.dart';
import 'package:logistics/services/theme.dart';
import 'package:logistics/views/base/common_button.dart';
import 'package:open_file/open_file.dart';
import '../../../controllers/auth_controller.dart';
import '../../../generated/assets.dart';
import '../../../services/constants.dart';
import '../../../services/input_decoration.dart';
import '../../../services/route_helper.dart';
import 'Components/fileview_page.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Future<void> _openFile(File file) async {
    try {
      await OpenFile.open(file.path);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Unable to open file.');
    }
  }

  @override
  void initState() {
    super.initState();

    final user = Get.find<AuthController>().userModel;
    if (user != null) {
      nameController.text = user.name ?? '';
      emailController.text = user.email ?? '';
      companyNameController.text = user.companyName ?? '';
      gstinNumberController.text = user.gstNumber ?? '';
      phoneController.text = user.phone ?? '';

      if ((user.gstCertificate ?? '').isNotEmpty) {
        final ext = user.gstCertificate!.split('.').last;
        gstcertificatenamecontroller.text = "gstcertificate.$ext";
      }

      if ((user.msmeCertificate ?? '').isNotEmpty) {
        final ext = user.msmeCertificate!.split('.').last;
        msmecertificatenamecontroller.text = "msmecertificate.$ext";
      }

      _isExpanded = (user.companyName?.isNotEmpty ?? false) ||
          (user.gstNumber?.isNotEmpty ?? false);
    }
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController gstinNumberController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController gstcertificatenamecontroller =
      TextEditingController();
  final TextEditingController msmecertificatenamecontroller =
      TextEditingController();

  File? gstinCertificate;
  File? msmeCertificate;
  bool _isExpanded = false;

  Widget _buildFilePicker({
    required TextEditingController controller,
    required File? file,
    required String label,
    required Function(File) onPick,
    required String? existingFileUrl,
  }) {
    bool isFileUploaded = (existingFileUrl ?? '').isNotEmpty;

    return TextFormField(
      maxLines: null,
      controller: controller,
      readOnly: true,
      onTap: () async {
        if (isFileUploaded) {
          Navigator.push(
            context,
            getCustomRoute(
              child: FileViewerScreen(
                fileUrl: AppConstants.baseUrl + existingFileUrl!,
              ),
            ),
          );
        } else {
          if (file != null) {
            await _openFile(file);
          } else {
            _showFilePickerDialog(onPicked: onPick);
          }
        }
      },
      style: Theme.of(context)
          .textTheme
          .labelLarge
          ?.copyWith(color: isFileUploaded ? Colors.grey[500] : Colors.black),
      decoration: CustomDecoration.inputDecoration(
        floating: true,
        label: label,
        icon: Icon(Icons.file_copy_outlined, size: 20, color: Colors.grey[700]),
        hint: isFileUploaded ? 'View ' : 'Choose File',
        suffix: file != null && !isFileUploaded
            ? IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => setState(() {
                  if (label == 'GSTIN Certificate') {
                    gstinCertificate = null;
                    controller.clear();
                  } else if (label == 'MSME Certificate') {
                    msmeCertificate = null;
                    controller.clear();
                  }
                }),
              )
            : Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0, top: 12.0),
                  child: Text(
                    isFileUploaded ? "View" : "Select File",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
        labelStyle: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(color: Colors.grey[500]),
        hintStyle: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(color: Colors.grey[500]),
      ),
    );
  }

  Future<void> _showFilePickerDialog({required Function(File) onPicked}) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.grey[700]),
                title: Text('Take a photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final picked =
                      await ImagePicker().pickImage(source: ImageSource.camera);
                  if (picked != null) onPicked(File(picked.path));
                },
              ),
              ListTile(
                leading: Icon(Icons.attach_file),
                title: Text('Choose file (PDF/Image)'),
                onTap: () async {
                  Navigator.pop(context);
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
                  );
                  if (result != null && result.files.single.path != null) {
                    onPicked(File(result.files.single.path!));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void onUpdateProfile() {
    if (_formKey.currentState!.validate()) {
      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final company = companyNameController.text.trim();
      final gstno = gstinNumberController.text.trim();

      final user = Get.find<AuthController>().userModel;

      final data = <String, dynamic>{
        "name": name,
        "email": email,
      };

      if (user?.companyName == null && company.isNotEmpty) {
        data["company_name"] = company;
      }

      if (user?.gstNumber == null && gstno.isNotEmpty) {
        data["gst_number"] = gstno;
      }

      if (user?.gstCertificate == null && gstinCertificate != null) {
        data["gst_certificate"] = MultipartFile(
          gstinCertificate!,
          filename: gstinCertificate!.path.fileName,
        );
      }

      if (user?.msmeCertificate == null && msmeCertificate != null) {
        data["msme_certificate"] = MultipartFile(
          msmeCertificate!,
          filename: msmeCertificate!.path.fileName,
        );
      }

      log('Update Payload => $data');
      Get.find<AuthController>().editprofile(FormData(data)).then(
        (value) {
          if (value.isSuccess) {
            Get.find<AuthController>().getUserProfileData();
            Navigator.pop(context);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, size: 25),
            color: Colors.black,
          ),
          title: Text(
            "Edit Profile",
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(fontSize: 17),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                        child: SvgPicture.asset(Assets.imagesRegisterusersvg)),
                    SizedBox(height: 25),
                    Text(
                      "Edit Your Profile",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: 25,
                          ),
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      controller: nameController,
                      label: 'Name',
                      icon: Icons.person_outline,
                      hint: 'Enter your name',
                      validator: (v) => v!.isEmpty ? 'Name is required' : null,
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      controller: emailController,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      hint: 'Enter your email',
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
                        icon: Icon(Icons.phone,
                            size: 20, color: Colors.grey[500]),
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Update Additional Information',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            Spacer(),
                            Icon(
                              _isExpanded
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_isExpanded) ...[
                      SizedBox(height: 20),
                      _buildTextField(
                        controller: companyNameController,
                        label: 'Company Name',
                        icon: Icons.business,
                        hint: 'Enter company name',
                        enabled: (Get.find<AuthController>()
                                    .userModel
                                    ?.companyName ??
                                '')
                            .isEmpty,
                      ),
                      SizedBox(height: 20),
                      _buildTextField(
                        controller: gstinNumberController,
                        label: 'GSTIN Number',
                        icon: Icons.numbers,
                        hint: 'Enter GST number',
                        enabled:
                            (Get.find<AuthController>().userModel?.gstNumber ??
                                    '')
                                .isEmpty,
                      ),
                      SizedBox(height: 20),
                      _buildFilePicker(
                        existingFileUrl: Get.find<AuthController>()
                            .userModel
                            ?.gstCertificate,
                        controller: gstcertificatenamecontroller,
                        file: gstinCertificate,
                        label: 'GSTIN Certificate',
                        onPick: (file) {
                          setState(() {
                            gstinCertificate = file;
                            gstcertificatenamecontroller.text = file.path
                                .split('/')
                                .last; // <-- Update filename
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      _buildFilePicker(
                        existingFileUrl: Get.find<AuthController>()
                            .userModel
                            ?.msmeCertificate,
                        controller: msmecertificatenamecontroller,
                        file: msmeCertificate,
                        label: 'MSME Certificate',
                        onPick: (file) {
                          setState(() {
                            msmeCertificate = file;
                            msmecertificatenamecontroller.text = file.path
                                .split('/')
                                .last; // <-- Update filename
                          });
                        },
                      ),
                    ],
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GetBuilder<AuthController>(builder: (controller) {
                return CustomButton(
                  title: 'Update Profile',
                  onTap: onUpdateProfile,
                  isLoading: controller.isLoading,
                );
              },)


            ],
          ),
        ));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    FormFieldValidator<String>? validator,
    bool enabled = true,
  }) {
    return TextFormField(
      style: Theme.of(context)
          .textTheme
          .labelLarge
          ?.copyWith(color: !enabled ? Colors.grey[500] : Colors.black),
      controller: controller,
      validator: validator,
      enabled: enabled,
      decoration: CustomDecoration.inputDecoration(
        floating: true,
        label: label,
        icon: Icon(icon, size: 20, color: Colors.grey[700]),
        hint: hint,
        labelStyle: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(color: Colors.grey[500]),
        hintStyle: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(color: Colors.grey[500]),
      ),
    );
  }
}
