import 'dart:io';
import 'package:jara_market/widgets/custom_button.dart';
import 'package:jara_market/widgets/custom_image_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:jara_market/screens/cart_screen/models/models.dart';
// lib/screens/egusi_soup_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:jara_market/models/cart_item.dart';
import 'package:jara_market/screens/cart_screen/cart_screen.dart';
import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
import 'package:jara_market/screens/egusi_soup_detail_screen/controller/egusi_soup_detail_controller.dart';
// import 'package:jara_market/screens/home_screen/models/food_model.dart';
import 'package:jara_market/screens/home_screen/models/models.dart' as cart;
import '../../widgets/custom_app_bar.dart';
import '../../widgets/rating_display.dart';

FoodDetailController controller = Get.put(FoodDetailController());
CartController cartController = Get.find<CartController>();

class FoodDetailScreen extends StatefulWidget {
  //final Map<String, dynamic> item;
  final cart.Products item;
  const FoodDetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  _FoodDetailScreenState createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int currentImageIndex = 0;

  final List<bool> ingredientSelected = List<bool>.filled(16, false);
  final TextEditingController ingredientController = TextEditingController();

  void addIngredient() {
    if (ingredientController.text.isNotEmpty) {
      setState(() {
        ingredientSelected.add(false);
        ingredientController.clear();
      });
    }
  }

  List<String> imageList = [
    'assets/images/soup1.png',
    'assets/images/soup2.png',
    'assets/images/soup3.png',
    'assets/images/soup4.png',
    'assets/images/soup3.png',
  ];
  List<String> ingredient = [
    'ingredient 1',
    'ingredient 2',
    'ingredient 3',
    'ingredient 4',
    'ingredient 5',
    'ingredient 6',
    'ingredient 7',
    'ingredient 8',
    'ingredient 9',
    'ingredient 10',
  ];

  Future<void> generatePdf(List<String> items) async {
    final pdf = pw.Document();
    Get.snackbar('Dowloading', 'Loading...');
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: items.map((item) => pw.Text(item)).toList(),
          );
        },
      ),
    );

    final outputDir = await getApplicationDocumentsDirectory();
    final file = File("${outputDir.path}/my_list.pdf");

    await file.writeAsBytes(await pdf.save());

    // Optional: Open the file (on Android/iOS)
    await OpenFile.open(file.path);
    Get.snackbar('Dowloading', 'Done!!!!');
  }

  @override
  Widget build(BuildContext context) {
    // int selectedCount = ingredientSelected.where((selected) => selected).length;

    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 30,
          ),
          SizedBox(
            height: 52,
            width: 162.5,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement video playback
              },
              icon: SvgPicture.asset('assets/images/camera.svg'),
              label: const Text(
                'Watch Video',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff666666)),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(width: 1, color: Color(0xff9F9F9F))),
                foregroundColor: Colors.black,
                backgroundColor: Colors.grey[300],
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(width: 15),
          SizedBox(
            height: 52,
            width: 162.5,
            child: ElevatedButton(
              onPressed: () {
                //selectedCount >= 5

                //?
                cartController.addToCart(CartItem(
                  id: widget.item.id!,
                  name: widget.item.name!,
                  description: widget.item.description ?? 'N/A',
                  price: double.tryParse(widget.item.price!.toString()) ?? 0.0,
                  originalPrice:
                      double.tryParse(widget.item.price!.toString()) ?? 0.0,
                  ingredients: widget.item.ingredients!
                      .map((ingredient) => Ingredients(
                            basePrice:
                                double.tryParse(ingredient.price.toString()) ??
                                    0.0,
                            id: ingredient.id!,
                            name: ingredient.name,
                            description: ingredient.description,
                            price:
                                double.tryParse(ingredient.price.toString()) ??
                                    0.0,
                          ))
                      .toList(),
                ));

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
              //   : null,
              child: const Text(
                'Buy Ingredients',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff090909)),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: widget.item.name.toString(),
        titleColor: Colors.orange,
        onBackPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 24,
            ),
            // Image carousel
            SizedBox(
              height: 200,
              width: double.infinity,
              child: CustomImageView(
                fit: BoxFit.cover,
                width: double.infinity,
                imagePath: widget.item.imageUrl.toString(),
              ),
              // Image.network(
              //   widget.item.imageUrl.toString(),
              //   fit: BoxFit.cover,
              // ),
              // PageView.builder(
              //   itemCount: widget.item.imageUrl!.length,
              //   onPageChanged: (index) {
              //     setState(() {
              //       currentImageIndex = index;
              //     });
              //   },
              //   itemBuilder: (context, index) {
              //     return Image.asset(
              //       //widget.item.imageUrl,
              //       widget.item.imageUrl![index],
              //       fit: BoxFit.cover,
              //     );
              //   },
              // ),
            ),
            SizedBox(
              height: 14,
            ),
            // Carousel indicators
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: List.generate(
            //    // imageList.length,
            //    widget.item.imageUrl!.length,
            //     (index) => Container(
            //       margin: const EdgeInsets.all(4),
            //       width: 8,
            //       height: 8,
            //       decoration: BoxDecoration(
            //         shape: BoxShape.circle,
            //         color: currentImageIndex == index
            //             ? Colors.blue
            //             : Colors.grey[300],
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: context.width * 0.65,
                        child: Text(
                          maxLines: 2,
                          widget.item.name.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      RatingDisplay(
                          rating:
                              double.parse(widget.item.rating ?? '0.0') ?? 2.0,
                          reviews: 10),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Ingredients',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff838383)),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 5.2,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 0,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.item.ingredients?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${index + 1}. ${widget.item.ingredients![index].name}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          // Checkbox(
                          //   value: ingredientSelected[index],
                          //   onChanged: (bool? value) {
                          //     setState(() {
                          //       ingredientSelected[index] = value ?? false;
                          //     });
                          //   },
                          // ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Divider(
                    thickness: 1,
                    color: Color(0xffECECEC),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Steps',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        color: Color(0xff838383)),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                      text: 'Download Recipe Steps',
                      onPressed: () async {
                        await generatePdf(widget.item.preparationSteps!);
                      }),
                  // ListView.separated(
                  //   itemCount: 4,// widget.item.preparationSteps!.length,
                  //   shrinkWrap: true,
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   itemBuilder: (context, index) {

                  //     if(index == 3){
                  //       return CustomButton(text: 'Download Steps', onPressed: () async {
                  //         await generatePdf(widget.item.preparationSteps!);
                  //       });
                  //     }
                  //     return Text(
                  //       textAlign: TextAlign.justify,
                  //       '${index + 1}. ${widget.item.preparationSteps![index]}' +
                  //           '${(widget.item.preparationSteps!.length - 1 == index ? '.' : ',')}',
                  //       style: TextStyle(
                  //         height: 2,
                  //       ),
                  //     );
                  //   },
                  //   separatorBuilder: (context, index) {
                  //     return const SizedBox(
                  //       height: 20,
                  //     );
                  //   },
                  // ),
                  //  Text(widget.item.preparationSteps.toString()),
                  const SizedBox(height: 50),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: TextField(
                  //         controller: ingredientController,
                  //         decoration: const InputDecoration(
                  //           hintText: 'Add new ingredient',
                  //           border: OutlineInputBorder(),
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 8),
                  //     ElevatedButton(
                  //       onPressed: addIngredient,
                  //       child: const Text('Add'),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 24),

                  // Row(
                  //   children: [
                  //     SizedBox(
                  //       height: 52,
                  //       width: 162.5,
                  //       child: ElevatedButton.icon(
                  //         onPressed: () {
                  //           // TODO: Implement video playback
                  //         },
                  //         icon: SvgPicture.asset('assets/images/camera.svg'),
                  //         label: const Text('Watch Video',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xff666666)),),
                  //         style: ElevatedButton.styleFrom(
                  //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: BorderSide(width: 1,color: Color(0xff9F9F9F))),
                  //           foregroundColor: Colors.black,
                  //           backgroundColor: Colors.grey[300],
                  //           padding: const EdgeInsets.symmetric(vertical: 16),
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 15),
                  //     SizedBox(
                  //        height: 52,
                  //       width: 162.5,
                  //       child: ElevatedButton(
                  //         onPressed:
                  //         //selectedCount >= 5
                  //             //?
                  //              () {
                  //                 Navigator.push(
                  //                   context,
                  //                   MaterialPageRoute(
                  //                       builder: (context) =>
                  //                           const CartScreen()),
                  //                 );
                  //               },
                  //          //   : null,
                  //         child: const Text('Buy Ingredients',style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,color: Color(0xff090909)),),
                  //         style: ElevatedButton.styleFrom(
                  //            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  //           backgroundColor: Colors.orange,
                  //           padding: const EdgeInsets.symmetric(vertical: 16),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
