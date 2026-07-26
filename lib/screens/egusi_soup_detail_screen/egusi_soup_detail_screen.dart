import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
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

  static const _brandColor = PdfColor.fromInt(0xFF2E7D32);
  static const _accentColor = PdfColor.fromInt(0xFFFF9800);

  Future<void> generatePdf(String steps, String foodName) async {
    final pdf = pw.Document();
    Get.snackbar('Downloading', 'Preparing your recipe...');

    final logoBytes = await rootBundle.load('assets/images/jara_market_logo.png');
    final logo = pw.MemoryImage(logoBytes.buffer.asUint8List());

    final lines = steps
        .split(RegExp(r'\r?\n'))
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.fromLTRB(32, 28, 32, 28),
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Image(logo, height: 48),
            pw.SizedBox(height: 12),
            pw.Container(height: 2, width: 60, color: _accentColor),
          ],
        ),
        footer: (context) => pw.Column(
          children: [
            pw.Divider(color: PdfColors.grey300),
            pw.SizedBox(height: 6),
            pw.Text(
              'Order fresh ingredients for this recipe on the Jaramarket app.',
              style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
            ),
          ],
        ),
        build: (context) => [
          pw.SizedBox(height: 16),
          pw.Text(
            foodName,
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey900,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Recipe Steps',
            style: pw.TextStyle(
              fontSize: 13,
              color: _brandColor,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 20),
          ...lines.asMap().entries.map(
                (entry) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 14),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 24,
                        height: 24,
                        alignment: pw.Alignment.center,
                        decoration: pw.BoxDecoration(
                          color: _brandColor,
                          shape: pw.BoxShape.circle,
                        ),
                        child: pw.Text(
                          '${entry.key + 1}',
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.SizedBox(width: 12),
                      pw.Expanded(
                        child: pw.Text(
                          entry.value,
                          style: const pw.TextStyle(fontSize: 12, lineSpacing: 2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );

    final outputDir = await getApplicationDocumentsDirectory();
    final safeName = foodName.replaceAll(RegExp(r'[^a-zA-Z0-9]+'), '_');
    final file = File("${outputDir.path}/${safeName}_recipe.pdf");

    await file.writeAsBytes(await pdf.save());

    await OpenFile.open(file.path);
    Get.snackbar('Downloaded', 'Your recipe steps are ready!');
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
                        final steps = widget.item.preparationSteps;
                        if (steps == null || steps.trim().isEmpty) {
                          Get.snackbar('No Recipe Steps',
                              'This item doesn\'t have recipe steps yet.');
                          return;
                        }
                        await generatePdf(steps, widget.item.name ?? 'Recipe');
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
