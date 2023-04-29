import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:o_health/constants/constants.dart';

class patientFiles extends StatefulWidget {
  int index;
  patientFiles(this.index, {super.key});

  @override
  State<patientFiles> createState() => _patientFilesState();
}

class _patientFilesState extends State<patientFiles> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'o-health'.tr(),
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        flexibleSpace: Container(
          alignment: Alignment.bottomRight,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(223, 227, 58, 58),
                Color.fromARGB(224, 238, 90, 102)
              ],
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.only(bottom: 6, right: 12),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                direction: Axis.vertical,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 3),
                    child: Text(
                      "Patient Name: ${patien[widget.index]['patientName']}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 3),
                    child: Text(
                      patien[widget.index]['date'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: size * 0.05),
                child: Column(
                  children: [
                    Text(
                      "Description",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            patien[widget.index]['patientProblem'],
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: patien[widget.index]['documentsCount'],
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "File.png",
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            Icon(Icons.download_rounded,
                                color: Colors.grey.shade700)
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
