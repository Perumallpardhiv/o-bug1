import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:o_health/constants/constants.dart';

class ResponcesFromDoctor extends StatefulWidget {
  const ResponcesFromDoctor({super.key});

  @override
  State<ResponcesFromDoctor> createState() => _ResponcesFromDoctorState();
}

class _ResponcesFromDoctorState extends State<ResponcesFromDoctor> {
  Future<void> getResponcesFromDoctor() async {
    var res = await rootBundle.loadString('assets/json/json.json');
    var resJsons = await json.decode(res);
    responces = resJsons["responces"];
    for (var i in responces) {
      print(i['doctorName']);
    }
    print("1111111");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getResponcesFromDoctor();
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
        child: responces.isEmpty
            ? const Center(
                child: Text("No Doctor Responded"),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      "Responces From Doctor",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: true,
                      itemCount: responces.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 2),
                          child: Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    responces[index]['date'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Doctor Name: ${responces[index]['doctorName']}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14),
                                  ),
                                ],
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
