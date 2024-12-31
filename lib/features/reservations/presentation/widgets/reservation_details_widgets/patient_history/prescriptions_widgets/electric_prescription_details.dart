import 'dart:io';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/one_reservation.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/elec_prescription_cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/elec_prescription_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';

class ElectricPrescriptionDetails extends StatefulWidget {
  final String electronicPrescriptionId;

  const ElectricPrescriptionDetails(
      {super.key, required this.electronicPrescriptionId});

  @override
  State<ElectricPrescriptionDetails> createState() =>
      _ElectricPrescriptionDetailsState();
}

class _ElectricPrescriptionDetailsState
    extends State<ElectricPrescriptionDetails> {
  @override
  Widget build(BuildContext context) {
    String prescriptionId = widget.electronicPrescriptionId;

    if (prescriptionId.isEmpty || prescriptionId.length <= 1) {
      return const Text('Invalid prescription ID');
    }

    String subId = prescriptionId.substring(1);

    context
        .read<ElectronicPrescriptionCubit>()
        .getElectronicPrescriptionById(widget.electronicPrescriptionId);

    final OneReservation? oneReservation =
        ReservationCubit.get(context).oneReservations;
    String patientName = oneReservation?.user?.fullName ?? "";
    String patientNum = oneReservation?.user?.phone ?? "";

    String patientPhoneNum =
        patientNum.length > 1 ? patientNum.substring(1) : '';
    return BlocBuilder<ElectronicPrescriptionCubit,
        ElectronicPrescriptionStates>(
      builder: (context, state) {
        if (state is ElectronicPrescriptionLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColor.primaryBlue,
            ),
          ); // Show loading indicator
        } else if (state is ElectronicPrescriptionError) {
          return const Center(
            child: Text('Failed to load prescription'),
          ); // Show error
        } else if (state is ElectronicPrescriptionSuccess) {
          final prescription = ElectronicPrescriptionCubit.get(context)
              .getUserElectronicPrescription;
          DateTime dateTime = DateTime.parse(prescription?.createdAt ?? "");
          DateFormat arabicFormat = DateFormat.yMd('ar_SA');
          String formattedDate = arabicFormat.format(dateTime);
          if (prescription == null) {
            return const Center(
                child: Text('Prescription data not available.'));
          }

          final medicineList = prescription.roshta;

          return Scaffold(
            body: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * .05),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsetsDirectional.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0x14008E0E),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "Electric Reservation\n       Prescription",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .08,
                        child: Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                side: const BorderSide(color: Colors.white),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () async {
                                await isStoragePermission();
                                final pdf = await generateInvoice(
                                    context, widget.electronicPrescriptionId);
                                await savePdfToDevice(pdf, context);
                              },
                              child: const Text(
                                "Download",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                side: const BorderSide(color: Colors.white),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () async {
                                BluetoothPrint bluetoothPrint =
                                    BluetoothPrint.instance;

                                bluetoothPrint.startScan(
                                    timeout: const Duration(seconds: 2));
                                List<BluetoothDevice> devices = [];

                                bluetoothPrint.scanResults.listen((scanResult) {
                                  devices = scanResult;
                                });

                                if (devices.isNotEmpty) {
                                  BluetoothDevice selectedPrinter =
                                      devices.firstWhere(
                                    (device) =>
                                        device.name == "Your_Printer_Name",
                                    orElse: () => devices.first,
                                  );

                                  await bluetoothPrint.connect(selectedPrinter);

                                  final pdf = await generateInvoice(
                                      context, widget.electronicPrescriptionId);
                                  final pdfBytes = await pdf.save();
                                  Printer? pri = await Printing.pickPrinter(
                                      context: context);
                                  await Printing.directPrintPdf(
                                      printer: pri!,
                                      onLayout: (PdfPageFormat format) async =>
                                          pdfBytes);

                                  await bluetoothPrint.disconnect();
                                } else {
                                  print("No Bluetooth printers found.");
                                }
                              },
                              child: const Text(
                                "Print",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .80,
                  margin: const EdgeInsetsDirectional.all(12),
                  padding: const EdgeInsetsDirectional.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsetsDirectional.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8ECF1),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        height: MediaQuery.of(context).size.height * .13,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text("د. يحيي عبدالعزيز إسماعيل",
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 8,
                                          color: Colors.black,
                                        )),
                                  ),
                                  SizedBox(height: 4),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text("بكالريوس طب وجراحة",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 8,
                                          color: Colors.black,
                                        )),
                                  ),
                                  SizedBox(height: 4),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text("قاي - إهناسيا - بني سويف",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 8,
                                          color: Colors.black,
                                        )),
                                  ),
                                  SizedBox(height: 4),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text("01019970489-01205505662",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 7,
                                          color: Colors.black,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Center(
                                child: Container(
                                  margin: const EdgeInsetsDirectional.all(4),
                                  height: 80,
                                  width: 80,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    "assets/images/medical_image.jpg",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text("إسم المريض /  $patientName",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 8,
                                          color: Colors.black,
                                        )),
                                  ),
                                  const SizedBox(height: 4),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child:
                                        Text("رقم الهاتف /  $patientPhoneNum",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 8,
                                              color: Colors.black,
                                            )),
                                  ),
                                  const SizedBox(height: 4),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child:
                                        Text(" تاريخ الكشف /  $formattedDate",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 8,
                                              color: Colors.black,
                                            )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: Colors.orange, thickness: 2),
                      const SizedBox(height: 6),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(" : Total Doses",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.black,
                            )),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: medicineList.length,
                          itemBuilder: (context, index) {
                            final medicine = medicineList[index];

                            String? medicineTime;
                            if (medicine.food == "before") {
                              medicineTime = "قبل";
                            } else if (medicine.food == "after") {
                              medicineTime = "بعد";
                            }

                            return Container(
                              margin:
                                  const EdgeInsetsDirectional.only(bottom: 10),
                              child: Card(
                                child: ListTile(
                                  title: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      medicine.medicin.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('  عدد المرات : ${medicine.dosage}'),
                                      medicineTime != null
                                          ? Text(
                                              "  الموعد : $medicineTime الطعام ")
                                          : Container(),
                                      Text("  ملاحظات : ${medicine.details} ")
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  Future<pw.Document> generateInvoice(
      BuildContext context, String electronicPrescriptionId) async {
    final pdf = pw.Document();
    final image = pw.MemoryImage(
      (await rootBundle.load('assets/images/medical_image.jpg'))
          .buffer
          .asUint8List(),
    );
    final fontData = await rootBundle.load('assets/fonts/Cairo.ttf');
    final ttf = pw.Font.ttf(fontData);
    final prescription = await context
        .read<ElectronicPrescriptionCubit>()
        .getElectronicPrescriptionById(electronicPrescriptionId);

    if (prescription == null) {
      throw Exception('Prescription data not available.');
    }
    final OneReservation? oneReservation =
        ReservationCubit.get(context).oneReservations;
    final patientName = oneReservation?.user?.fullName ?? "";
    final patientPhone = oneReservation?.user?.phone?.substring(1) ?? "";
    DateTime dateTime = DateTime.parse(prescription.createdAt ?? "");
    DateFormat arabicFormat = DateFormat.yMd('ar_SA');
    String formattedDate = arabicFormat.format(dateTime);

    final medicineList = prescription.roshta;

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            height: 800,
            margin: const pw.EdgeInsets.all(10),
            padding: const pw.EdgeInsets.all(4),
            decoration: pw.BoxDecoration(
              borderRadius: pw.BorderRadius.circular(12),
              border: pw.Border.all(color: PdfColors.black, width: 2),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('E8ECF1'),
                    borderRadius: const pw.BorderRadius.only(
                      topLeft: pw.Radius.circular(12),
                      topRight: pw.Radius.circular(12),
                    ),
                  ),
                  padding: const pw.EdgeInsets.all(16),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        flex: 5,
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                          children: [
                            pw.Text("إسم المريض: $patientName",
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                  font: ttf,
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 12,
                                )),
                            pw.Text("رقم الهاتف: $patientPhone",
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                  font: ttf,
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 12,
                                )),
                            pw.Text(
                              "تاريخ الكشف: $formattedDate",
                              textDirection: pw.TextDirection.rtl,
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ),
                      pw.Expanded(
                        flex: 3,
                        child: pw.Center(
                          child: pw.Container(
                            margin: const pw.EdgeInsetsDirectional.all(4),
                            height: 80,
                            width: 80,
                            decoration: const pw.BoxDecoration(
                              shape: pw.BoxShape.circle,
                            ),
                            child: pw.ClipOval(
                              child: pw.Image(
                                image,
                                fit: pw.BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 4,
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                          children: [
                            pw.Text("د. يحيي عبدالعزيز إسماعيل",
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                  fontStyle: pw.FontStyle.italic,
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 12,
                                  font: ttf,
                                )),
                            pw.Text("بكالريوس طب وجراحة",
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 12,
                                  font: ttf,
                                )),
                            pw.Text("قاي - إهناسيا - بني سويف",
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 12,
                                  font: ttf,
                                )),
                            pw.Text("01019970489-01205505662",
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.normal,
                                  fontSize: 10,
                                  font: ttf,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Divider(color: PdfColors.orange, thickness: 2),
                pw.SizedBox(height: 6),
                pw.Text('Total Doses:',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 20,
                    )),
                pw.SizedBox(height: 6),
                pw.Column(
                  children:
                      List<pw.Widget>.generate(medicineList.length, (index) {
                    final prescription = medicineList[index];
                    return pw.Container(
                      margin: const pw.EdgeInsets.only(
                          bottom: 10, right: 4, left: 4),
                      padding: const pw.EdgeInsets.all(8),
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex('F0F0F0'),
                        borderRadius: pw.BorderRadius.circular(8),
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          // First text aligned to the left
                          pw.Text(
                            prescription.medicin.title,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          // Column containing other texts aligned to the right
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              pw.Text(
                                'عدد المرات: ${prescription.dosage}',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                  font: ttf,
                                  fontSize: 14,
                                ),
                              ),
                              pw.Text(
                                'موعد: ${prescription.food == "before" ? "قبل" : "بعد"}',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                  font: ttf,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf;
  }

  Future<void> savePdfToDevice(pw.Document pdf, BuildContext context) async {
    try {
      final directory = await getExternalStorageDirectory();
      final filePath = "${directory?.path}/elec_roshta.pdf";
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
      try {
        await OpenFile.open(file.path);
      } catch (e) {
        debugPrint(e.toString());
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF Saved Successfully $filePath')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Saving PDF: $e')),
      );
    }
  }

  @override
  Future<bool> isStoragePermission() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo android = await plugin.androidInfo;
    bool permissionGranted = false; // Initialize permission status

    if (android.version.sdkInt < 33) {
      if (await Permission.storage.isGranted) {
        permissionGranted = true;
      } else if (await Permission.storage.isDenied) {
        if (await Permission.storage.request().isGranted) {
          permissionGranted = true;
        }
      } else if (await Permission.storage.isPermanentlyDenied) {
        await openAppSettings();
      }
      // Request camera permission
      if (await Permission.camera.isDenied) {
        await Permission.camera.request();
      }
    } else {
      // Check and request photos permission
      if (await Permission.photos.isGranted) {
        permissionGranted = true;
      } else if (await Permission.photos.isDenied) {
        if (await Permission.photos.request().isGranted) {
          permissionGranted = true;
        }
      } else if (await Permission.photos.isPermanentlyDenied) {
        await openAppSettings();
      }

      // Request camera permission
      if (await Permission.camera.isDenied) {
        await Permission.camera.request();
      }
    }

    return permissionGranted; // Return permission status
  }
}
