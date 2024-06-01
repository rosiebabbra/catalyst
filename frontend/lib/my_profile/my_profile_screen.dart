import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  getCurrentUserName(String userId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users') // Replace with your collection name
        .where('user_id', isEqualTo: userId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Iterate through the documents (there may be multiple matching records)
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        var recordData = document.data() as Map<String, dynamic>;
        return recordData['first_name'];
      }
    } else {
      return 'Error rendering user name';
    }
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final currentUserId = user?.uid;

    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 20, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.settings, size: 30, color: Colors.transparent),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Stack(children: [
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      color: const Color(0xff7c94b6),
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://firebasestorage.googleapis.com/v0/b/dating-appp-2d438.appspot.com/o/user_images%2F$currentUserId?alt=media&token=93205064-c7ab-4b20-8750-9821c2bd97d0'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(50.0)),
                    ),
                  ),
                ]),
              ),
            ),
            FutureBuilder(
              future: getCurrentUserName(currentUserId ?? ''),
              builder: (BuildContext context, snapshot) {
                return Flexible(
                  child: (snapshot.data != null)
                      ? Text(snapshot.data.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w700))
                      : const CircularProgressIndicator(),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      Color.fromARGB(255, 154, 231, 176),
                      Color(0xff33D15F),
                      Color(0xff09CBC8)
                    ]),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(width: 0.5, color: Colors.grey[300]!),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Premium',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                'Unlock all of our features and get more matches',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        // SizedBox(
                        //   height: 100,
                        //   child: Expanded(
                        //     child: ListView.builder(
                        //       itemCount: _nonConsumableProducts.length,
                        //       itemBuilder: (context, index) {
                        //         final product = _nonConsumableProducts[index];
                        //         return ListTile(
                        //           title: Text(product.title),
                        //           trailing: TextButton(
                        //             child: Text(product.price),
                        //             onPressed: () {
                        //               final PurchaseParam purchaseParam =
                        //                   PurchaseParam(productDetails: product);
                        //               _iap.buyNonConsumable(
                        //                   purchaseParam: purchaseParam);
                        //             },
                        //           ),
                        //         );
                        //       },
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: 35,
                          width: 185,
                          child: TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(45),
                                  ))),
                              child: Text("Coming soon",
                                  style: TextStyle(
                                      fontSize: 16,
                                      height: 0.5,
                                      color: Colors.grey[800]))),
                        ),
                      ],
                    ),
                  )),
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 35.0, 15.0, 15.0),
                  child: GridView.count(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(0),
                      crossAxisCount: 3,
                      childAspectRatio: 5,
                      mainAxisSpacing: 10,
                      children: [
                        const Text('What you get:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const Text('Premium',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const Text('Standard',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                        const Text('Unlimited swipes',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        const Icon(Icons.check, color: Color(0xff33D15F)),
                        const Icon(Icons.check, color: Color(0xff33D15F)),
                        const Text('Advanced filters',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        const Icon(Icons.check, color: Color(0xff33D15F)),
                        Icon(Icons.clear, color: Colors.grey[400]),
                        const Text('Incognito mode',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        const Icon(Icons.check, color: Color(0xff33D15F)),
                        Icon(Icons.clear, color: Colors.grey[400]),
                        const Text('Travel mode',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        const Icon(Icons.check, color: Color(0xff33D15F)),
                        Icon(Icons.clear, color: Colors.grey[400]),
                      ]),
                )),
          ],
        ));
  }
}
