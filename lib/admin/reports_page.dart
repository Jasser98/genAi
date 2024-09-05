import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportsPage extends StatefulWidget {
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  late final Stream<QuerySnapshot> usersStream;
  late final Stream<QuerySnapshot> equipmentsStream;

  @override
  void initState() {
    super.initState();
    usersStream = FirebaseFirestore.instance.collection('users').snapshots();
    equipmentsStream = FirebaseFirestore.instance.collection('equipments').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Equipment vs Owners', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 20),
            StreamBuilder<QuerySnapshot>(
              stream: usersStream,
              builder: (context, usersSnapshot) {
                if (!usersSnapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var userDocs = usersSnapshot.data?.docs ?? [];
                int totalUsers = userDocs.length;
                int totalOwners = userDocs.where((doc) => doc['role'] == 'owner').length;
                int totalAdmins = userDocs.where((doc) => doc['role'] == 'admin').length;

                return StreamBuilder<QuerySnapshot>(
                  stream: equipmentsStream,
                  builder: (context, equipmentsSnapshot) {
                    if (!equipmentsSnapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    int totalEquipments = equipmentsSnapshot.data?.size ?? 0;

                    double ownerPercentage = totalEquipments > 0 ? (totalOwners / totalEquipments) * 100 : 0;
                    double remainingPercentage = 100 - ownerPercentage;

                    double userRolePercentage = totalUsers > 0 ? (totalUsers - totalOwners - totalAdmins) / totalUsers * 100 : 0;
                    double ownerRolePercentage = totalUsers > 0 ? totalOwners / totalUsers * 100 : 0;
                    double adminRolePercentage = totalUsers > 0 ? totalAdmins / totalUsers * 100 : 0;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 300,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 8, offset: Offset(0, 4)),
                            ],
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: PieChart(
                                  PieChartData(
                                    sections: [
                                      PieChartSectionData(
                                        color: Colors.blue,
                                        value: ownerPercentage,
                                        title: '${ownerPercentage.toStringAsFixed(1)}%',
                                        radius: 80,
                                        titleStyle: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      PieChartSectionData(
                                        color: Colors.orange,
                                        value: remainingPercentage,
                                        title: '${remainingPercentage.toStringAsFixed(1)}%',
                                        radius: 80,
                                        titleStyle: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text('Equipment vs Owners', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                            ],
                          ),
                        ),
                        SizedBox(height: 40),
                        Text('User Roles Distribution', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                        SizedBox(height: 20),
                        Container(
                          height: 300,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 8, offset: Offset(0, 4)),
                            ],
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: PieChart(
                                  PieChartData(
                                    sections: [
                                      PieChartSectionData(
                                        color: Colors.blue,
                                        value: ownerRolePercentage,
                                        title: '${ownerRolePercentage.toStringAsFixed(1)}%',
                                        radius: 80,
                                        titleStyle: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      PieChartSectionData(
                                        color: Colors.green,
                                        value: userRolePercentage,
                                        title: '${userRolePercentage.toStringAsFixed(1)}%',
                                        radius: 80,
                                        titleStyle: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      PieChartSectionData(
                                        color: Colors.red,
                                        value: adminRolePercentage,
                                        title: '${adminRolePercentage.toStringAsFixed(1)}%',
                                        radius: 80,
                                        titleStyle: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text('User Roles Distribution', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                            ],
                          ),
                        ),
                        SizedBox(height: 40),
                        Text('Summary', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 8),
                            Text('Total Owners: $totalOwners', style: TextStyle(fontSize: 18, color: Colors.black)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              color: Colors.green,
                            ),
                            SizedBox(width: 8),
                            Text('Total Users: ${totalUsers - totalOwners - totalAdmins}', style: TextStyle(fontSize: 18, color: Colors.black)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              color: Colors.red,
                            ),
                            SizedBox(width: 8),
                            Text('Total Admins: $totalAdmins', style: TextStyle(fontSize: 18, color: Colors.black)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              color: Colors.orange,
                            ),
                            SizedBox(width: 8),
                            Text('Total Equipments: $totalEquipments', style: TextStyle(fontSize: 18, color: Colors.black)),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
