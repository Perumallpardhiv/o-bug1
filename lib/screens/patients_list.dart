import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:o_health/constants/constants.dart';
import 'package:o_health/screens/patients_files.dart';

class patients_list extends StatefulWidget {
  const patients_list({super.key});

  @override
  State<patients_list> createState() => _patients_listState();
}

class _patients_listState extends State<patients_list> {
  @override
  void initState() {
    super.initState();
    reloadDetails();
  }

  reloadDetails() async {
    await patientsDetails();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: patien.isEmpty
            ? const Center(
                child: Text("No Patients"),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      "Patients Details",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: true,
                      itemCount: patien.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 2,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => patientFiles(index),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      patien[index]['date'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Patient Name: ${patien[index]['patientName']}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
