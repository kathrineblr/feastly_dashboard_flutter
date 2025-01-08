
import 'package:data_table_2/data_table_2.dart';
import 'package:feastly_dashboard/controller/customer_controller.dart';
import 'package:feastly_dashboard/models/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../constants/constants.dart';
import '../routes/string_routes.dart';
import '../widgets/header_widget.dart';
import '../widgets/side_menu_items.dart';


class CustomerPage extends StatelessWidget {
   CustomerPage({super.key});

   final CustomerController cc = Get.put(CustomerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: SideMenuItems()),
          Expanded(
            flex: flexValue,
            child: Column(
              children: [
                const HeaderWidget(title: 'Customers'),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: GetBuilder<CustomerController>(
                              id: 'listOfCustomers',
                              builder: (logic) {
                                return Container(
                                  // decoration: BoxDecoration(
                                  //     border: Border.all(color: Colors.grey)
                                  // ),
                                  child: AsyncPaginatedDataTable2(
                                    columnSpacing: 12,
                                    horizontalMargin: 12,
                                    minWidth: Get.width - 100,
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
                                    columns: cc.columList,
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
    var alc = Get.find<CustomerController>();
    var model = {"limit":count,"skip":startIndex};
    var data = await CustomerModel().getAllCustomers(model);

    // var data = await CallHistoryModel().listOfAllCallsPagination(startIndex, count, searchValue,alc.fromDateTxtController.text.trim().isEmpty ? '' : convertFromToDate(DateTime.parse(alc.fromDateTxtController.text.trim()), 'from'),alc.toDateTxtController.text.trim().isEmpty ? '' : convertFromToDate(DateTime.parse(alc.toDateTxtController.text.trim()),'to'));
    var rows = (data!['data']['data'] as List).map((e) =>
        CustomerModel.fromJson(e)).toList();
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
                      Center(child: SelectableText(e.firstName ?? ''))),
                  DataCell(
                      Center(child: SelectableText(e.lastName ?? ''))),
                  DataCell(
                      Center(child: SelectableText(e.email ?? ''))),
                  DataCell(
                      Center(child: SelectableText(e.phone ?? ''))),

                ])).toList(),
      );
    }
  }
}