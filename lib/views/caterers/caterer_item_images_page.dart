import 'package:feastly_dashboard/controller/caterer/caterer_item_controller.dart';
import 'package:feastly_dashboard/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CatererItemImagesPage extends StatelessWidget {
  final String itemCode;
  final String itemName;
  final String catererCode;
  CatererItemImagesPage({super.key,required this.itemCode,required this.itemName,required this.catererCode});

  final CatererItemController imc = Get.put(CatererItemController());
  @override
  Widget build(BuildContext context) {
    imc.getItemImages(itemCode: itemCode,catererCode: catererCode);
    return Container(
      height: context.height * 0.6,
      width: context.width * 0.4,
      child: Column(
        children: [
          HeaderWidget(title: '$itemName Images', onTap: () {
            Get.back();
          },),
          Expanded(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton.icon(onPressed: (){
                      imc.pickItemImages(itemCode,catererCode);
                    }, label: const Text('Upload Image'),icon: const Icon(Icons.upload_file),),
                  ],
                ),
                const SizedBox(height: 10,),
                Expanded(
                  child: GetBuilder<CatererItemController>(
                      id: 'item_images',
                      builder: (logic) {
                        if(logic.loadingImages){
                          return const Center(child: CircularProgressIndicator());
                        }
                        else {
                          if (logic.itemImages.isEmpty) {
                            return const Center(child: Text('No Images Found'));
                          }
                          else {
                            return GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 10.0
                                ),
                                itemCount: logic.itemImages.length,
                                itemBuilder: (context, index) {
                                  var imageData = logic.itemImages[index];
                                  return Card(
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage('${imageData.image}'),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: IconButton.filledTonal(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              logic.confirmImageDeletion(itemCode: itemCode, imageCode: imageData.code,catererCode: catererCode);
                                            },
                                            splashRadius: 20,
                                            style: ButtonStyle(
                                              backgroundColor: WidgetStatePropertyAll(Colors.grey.shade400),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  );
                                });
                          }
                        }
                      }),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
