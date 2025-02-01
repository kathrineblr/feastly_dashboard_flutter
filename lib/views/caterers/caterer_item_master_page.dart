import 'package:data_table_2/data_table_2.dart';
import 'package:feastly_dashboard/controller/caterer/caterer_item_controller.dart';
import 'package:feastly_dashboard/models/caterer_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../constants/constants.dart';
import '../../models/caterer_model.dart';
import '../../widgets/header_widget.dart';
import '../../widgets/side_menu_items.dart';


class CatererItemMasterPage extends StatelessWidget {
   CatererItemMasterPage({super.key});

   final CatererItemController cic = Get.put(CatererItemController());
  @override
  Widget build(BuildContext context) {
    cic.initiateLists();
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: SideMenuItems()),
          Expanded(
            flex: flexValue,
            child: Column(
              children: [
                const HeaderWidget(title: 'Caterer Item Master'),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 300,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Caterer', style: Get.textTheme.titleMedium),
                                  Autocomplete(
                                    optionsBuilder: (TextEditingValue textEditingValue) {
                                      return cic.getAllCaterers(textEditingValue.text);
                                    },
                                    onSelected: (value) {
                                      cic.selectedCaterer.value = value;
                                      cic.loadProject();
                                    },
                                    displayStringForOption: (option) => option.name!,
                                    fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                                      return TextField(
                                        controller: controller,
                                        focusNode: focusNode,
                                        onEditingComplete: onEditingComplete,
                                        decoration: const InputDecoration(
                                          hintText: 'Search caterer',
                                          // border: OutlineInputBorder(),
                                          // contentPadding: const EdgeInsets.all(10.0),
                                        ),
                                      );
                                    },
                                    optionsViewBuilder: (context,
                                        Function(CatererModel) onSelected, Iterable<
                                            CatererModel> options) {
                                      return Align(
                                        alignment: Alignment.topLeft,
                                        child: Material(
                                          elevation: 4.0,
                                          child: ConstrainedBox(
                                            constraints:  const BoxConstraints(maxHeight: 400,maxWidth: 300),
                                            child: ListView.builder(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              itemCount: options.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                final CatererModel option = options.elementAt(index);
                                                return InkWell(
                                                  onTap: () {
                                                    onSelected(option);
                                                  },
                                                  child: Builder(
                                                      builder: (BuildContext context) {
                                                        final bool highlight = AutocompleteHighlightedOption.of(context) == index;
                                                        if (highlight) {
                                                          SchedulerBinding
                                                              .instance
                                                              .addPostFrameCallback((
                                                              Duration timeStamp) {
                                                            Scrollable
                                                                .ensureVisible(
                                                                context,
                                                                alignment: 0.5);
                                                          });
                                                        }
                                                        return Container(
                                                          color: highlight ? Theme.of(context).focusColor : null,
                                                          padding: const EdgeInsets.all(16.0),
                                                          child: Table(
                                                            children: [
                                                              TableRow(
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text('${option.name}')
                                                                      ],
                                                                    ),
                                                                  ]
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            FilledButton.icon(onPressed: (){
                              cic.addOpenItemDialog();
                            }, label: Text('Add Item'),icon: Icon(Icons.add),)
                          ],
                        ),
                        Expanded(
                          child: GetBuilder<CatererItemController>(
                              id: 'listOfItems',
                              builder: (logic) {
                                return Container(
                                  // decoration: BoxDecoration(
                                  //     border: Border.all(color: Colors.grey)
                                  // ),
                                  child: AsyncPaginatedDataTable2(
                                    columnSpacing: 12,
                                    horizontalMargin: 12,
                                    minWidth: 2500,
                                    headingRowHeight: 30,
                                    dataRowHeight: 30,
                                    fit: FlexFit.tight,
                                    // pageSyncApproach: PageSyncApproach.goToFirst,
                                    onRowsPerPageChanged: (r) {
                                      logic.rowChangedPerPage(r!);
                                    },
                                    isHorizontalScrollBarVisible: true,
                                    isVerticalScrollBarVisible: true,
                                    wrapInCard: true,
                                    availableRowsPerPage: const [10, 20, 30, 50, 100],
                                    // Add this
                                    dataTextStyle: Get.textTheme.bodySmall!,
                                    headingRowColor: WidgetStatePropertyAll(yellowColor),
                                    headingTextStyle: Get.textTheme.titleSmall!
                                        .copyWith(fontWeight: FontWeight.bold),
                                    empty: const Center(child: Text('No Data Found')),
                                    border: const TableBorder(verticalInside: BorderSide(
                                        color: Colors.grey, width: 0.2)),
                                    columns: cic.columList,
                                    rowsPerPage: logic.rowPerPage,
                                    source: MyAsyncDataSource(searchValue: ''),
                                    loading: const Center(
                                      child: CircularProgressIndicator(),),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),)
        ],
      ),
    );
  }
}

class MyAsyncDataSource extends AsyncDataTableSource {
  // final Future<List<CallHistoryModel>> Function(int startIndex, int pageSize) fetchData; // Replace MyData with your data type
  String searchValue = '';

  MyAsyncDataSource({required this.searchValue});

  var countData = 0;

  // @override
  // Future<DataRow> getData(int index) async {
  // //   // Fetch data based on current page and rows per page
  //   final data = await fetchData((index ~/ _rowsPerPage) * _rowsPerPage, _rowsPerPage);
  //   countData = data.length;
  //   if (index >= data.length) {
  //     return const DataRow(cells: []);
  //   }
  //   final item = data[index];
  //   return DataRow.byIndex(
  //     index: index,
  //       cells:[
  //     DataCell(Text('${index + 1}')),
  //     DataCell(Text(item.scheduledAddress ?? '')),
  //     DataCell(Text(item.scheduledState ?? '')),
  //     DataCell(Text(item.expiryOn == null ? '' : DateFormatCustom().ddMMYY(item.expiryOn!))),
  //     DataCell(Text(item.scheduledOn == null ? '' : DateFormatCustom().ddMMYY(item.scheduledOn!))),
  //     DataCell(Text(item.dialerState ?? '')),
  //     DataCell(Text(item.createdOn == null ? '' : DateFormatCustom().ddMMYY(item.createdOn!))),
  //     DataCell(Text('${item.createdBy ?? ' '}')),
  //   ]);
  // }

  @override
  bool get isRowCountApproximate => false;

  // int _rowsPerPage = 50; // Adjust rowsPerPage as needed

  @override
  int get rowCount => countData;

  @override
  int get selectedRowCount => 0; // Handle selection if needed

  // void setRowsPerPage(int rowsPerPage) {
  //   _rowsPerPage = rowsPerPage;
  // }

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    var alc = Get.find<CatererItemController>();
    var model = {"limit":count,"skip":startIndex,"caterer_code":alc.selectedCaterer.value == null ? '' : alc.selectedCaterer.value!.code};

    print('-------- $model');
    var data = await CatererItemModel().getAllCaterersItems(model);

    // var data = await CallHistoryModel().listOfAllCallsPagination(startIndex, count, searchValue,alc.fromDateTxtController.text.trim().isEmpty ? '' : convertFromToDate(DateTime.parse(alc.fromDateTxtController.text.trim()), 'from'),alc.toDateTxtController.text.trim().isEmpty ? '' : convertFromToDate(DateTime.parse(alc.toDateTxtController.text.trim()),'to'));
    var rows = (data!['data']['data'] as List).map((e) =>
        CatererItemModel.fromJson(e)).toList();
    debugPrint('-------- ${rows.length}');
    countData = data['data']['total'];
    if (rows.isEmpty) {
      return AsyncRowsResponse(0, []);
    }
    else {
      return AsyncRowsResponse(
        rows.length,
        rows.map((e) =>
            DataRow(
                color: rows
                    .indexOf(e)
                    .isEven
                    ? const WidgetStatePropertyAll(Colors.white)
                    : WidgetStatePropertyAll(Colors.grey.shade100),
                cells: [
                  DataCell(Center(
                      child: Text('${rows.indexOf(e) + 1 + startIndex}'))),
                  DataCell(
                      Center(child: SelectableText(e.code ?? ''))),
                  DataCell(
                      Center(child: SelectableText(e.name ?? ''))),
                  DataCell(
                      Center(child: SelectableText(e.category == null ? '' : e.category!.name!))),
                  DataCell(
                      Center(child: SelectableText(e.subCategory == null ? '' : e.subCategory!.name!))),
                  DataCell(
                      Center(child: SelectableText(e.unit == null ? '' : e.unit!.name!))),
                  DataCell(
                      Center(child: SelectableText(e.brand == null ? '' : e.brand!.name!))),
                  DataCell(
                      Center(child: SelectableText(e.price ?? ''))),
                  DataCell(
                      Center(child: SelectableText(e.mrp ?? ''))),
                  DataCell(
                      Center(child: SelectableText(e.ratio ?? ''))),
                  DataCell(
                      Center(child: SelectableText(e.itemEnable! ? "Enable" : "Disable"))),
                  DataCell(
                      Center(child: IconButton(onPressed: (){
                        // alc.modifyItemDialog(model: e);
                        alc.updateOpenItemDialog(model: e);
                      }, icon: Icon(Icons.edit)))),

                ])).toList(),
      );
    }
  }
}
