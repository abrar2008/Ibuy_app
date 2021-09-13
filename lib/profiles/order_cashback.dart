import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderCashback extends StatelessWidget {
  final double accountBalance = 10;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final String user = FirebaseAuth.instance.currentUser.uid;
    return Scaffold(
        body: StreamBuilder<Object>(
            stream: FirebaseFirestore.instance
                .collection('CashbackRequests')
                .doc(user)
                .snapshots(),
            builder: (context, snapshot) {
              dynamic document = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(size.width * 0.15, 0, 0, 0),
                    child: Text(
                      'Cashback Summary',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 19),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: size.width * 0.8,
                      child: Table(
                        border: TableBorder.all(width: 1.0, color: Colors.grey),
                        children: [
                          TableRow(children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Account Balance',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                        '\$${document.data()['accountBalance'].toInt().toString()}'),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Cashback issued till date'),
                                    Text(
                                        '\$${document.data()['cashBackEarnedTillDate'].toInt().toString()}'),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Cashback issued till date'),
                                    Text(
                                        '\$${document.data()['pending'].toInt().toString()}'),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Cashback earned till date'),
                                    Text(
                                      '\$5',
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  if (document.data()['accountBalance'] < 10)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Wrap(alignment: WrapAlignment.center, children: [
                          Text(
                            'You may request Cashback once your ',
                          ),
                          Text(
                            'Account ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Balance ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('is \$10 or more')
                        ]),
                      ),
                    )
                  else
                    Column(children: [
                      Text(
                        'Congractulations!',
                        style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 21),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'You are eligible for a free delivery of your Cashback Check',
                            textAlign: TextAlign.center,
                            style: TextStyle(),
                          ),
                        ),
                      ),
                      StreamBuilder<Object>(
                          stream: FirebaseFirestore.instance
                              .collection('userData')
                              .doc(user)
                              .snapshots(),
                          builder: (context, snapshot) {
                            return ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.amber),
                                ),
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('CashbackRequests')
                                      .doc(user)
                                      .collection('requests')
                                      .add({
                                    'customerID': user,
                                  });
                                  await FirebaseFirestore.instance
                                      .collection('CashbackRequests')
                                      .doc(user)
                                      .set({
                                    'cashbackRequest': 'YES',
                                    'accountBalance': 0,
                                    'pending':
                                        document.data()['accountBalance'],
                                    'requestProcessed': 'NO',
                                    'cashBackEarnedTillDate': document
                                        .data()['cashBackEarnedTillDate'],
                                    'customerID': user,
                                  });
                                },
                                child: Text(
                                  'Request Cashback!',
                                  style: TextStyle(color: Colors.black),
                                ));
                          }),
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Text('Certain restrictions may apply. Please check '),
                          InkWell(
                              onTap: () {},
                              child: Text(
                                'terms and conditions',
                                style: TextStyle(color: Colors.blue),
                              ))
                        ],
                      )
                    ]),
                  Padding(
                    padding: EdgeInsets.all(23),
                    child: Text(
                      'Hot Tips!!',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.label_important_sharp,
                          size: 20,
                          color: Colors.blue,
                        ),
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text('Invite others ',
                                style: TextStyle(color: Colors.blue)),
                            InkWell(
                                onTap: () {},
                                child: Text(
                                  'and get free cashback!',
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        children: [
                          Icon(
                            Icons.label_important_sharp,
                            size: 20,
                          ),
                          Text(
                            'Don\'t miss anything. Scan everything you shop at ',
                          ),
                          InkWell(
                              onTap: () {},
                              child: Text(
                                'Food Basics',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))
                        ],
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Icon(
                            Icons.label_important_sharp,
                            size: 20,
                          ),
                          Text(
                            'Check additional ',
                          ),
                          InkWell(
                              onTap: () {},
                              child: Text(
                                'Tips ',
                              )),
                          Text('to save even more!')
                        ],
                      ))
                ],
              );
            }));
  }
}
