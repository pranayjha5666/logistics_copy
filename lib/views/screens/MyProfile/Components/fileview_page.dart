import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:logistics/views/base/custom_image.dart';
import '../../../../controllers/auth_controller.dart';

class FileViewerScreen extends StatefulWidget {
  final String fileUrl;

  const FileViewerScreen({super.key, required this.fileUrl});

  @override
  State<FileViewerScreen> createState() => _FileViewerScreenState();
}

class _FileViewerScreenState extends State<FileViewerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AuthController>().prepareFile(widget.fileUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'View File',
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(fontSize: 17),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              size: 20,
              color: Colors.black,
            ),
            padding: EdgeInsets.zero,
          ),
          backgroundColor: Colors.white,
        ),
        body: GetBuilder<AuthController>(
          builder: (controller) {
            return controller.isLoading
                ? Center(child: CircularProgressIndicator())
                : controller.isPdf
                    ? controller.localPath != null
                        ? PDFView(
                            filePath: controller.localPath!,
                            enableSwipe: true,
                            swipeHorizontal: false,
                            autoSpacing: true,
                            pageFling: true,
                          )
                        : Center(child: Text("Failed to load PDF."))
                    : Center(
                        child: CustomImage(
                          path: widget.fileUrl,
                        ),
                      );
          },
        ));
  }
}
