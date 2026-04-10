import 'package:flutter/material.dart';
import 'package:power_state/power_state.dart';
import 'package:secure_note/core/constants/dimension_theme.dart';
import 'package:secure_note/web/features_web/delete_data/controller/delete_data_controller.dart';
import 'package:secure_note/web/features_web/delete_data/data/model/delete_model.dart';
import 'package:secure_note/web/features_web/delete_data/data/model/status_model.dart';

class DeleteDataScreen extends StatefulWidget {
  const DeleteDataScreen({super.key});

  @override
  State<DeleteDataScreen> createState() => _DeleteDataScState();
}

class _DeleteDataScState extends State<DeleteDataScreen> {
  TextEditingController messageControler = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 300,
          ),
          child: PowerBuilder<DeleteDataController>(
            builder: (DeleteDataController deleteDataController) {
              return Container(
                padding: EdgeInsets.all(Dimension.paddingSmall),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(Dimension.borderRadius),
              
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Delete Data",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: Dimension.paddingSmall),                            

                    Text(
                      "Please submit a delete request with detailed information, including your account ID or email. You must also verify that you are the owner of the account.",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                    SizedBox(height: Dimension.paddingSmall),

                    TextField(
                      controller: messageControler,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onChanged: (val){
                        deleteDataController.setStatusModel(null);
                      },
                    ),
              
                    const SizedBox(
                      height: Dimension.paddingDefault,
                    ),
              
                    SizedBox(
                      height: 30,
                      width: deleteDataController.isLoading ? 30 : double.infinity,
                      child: ElevatedButton(
                        onPressed: deleteDataController.isLoading
                            ? null
                            : () {
                                final String id =
                                    "${DateTime.now().millisecondsSinceEpoch}";
                                deleteDataController.sendDeleteMessage(
                                  DeleteModel(
                                    id: id,
                                    message: messageControler.text,
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.blueAccent.shade100,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.zero, // important for perfect circle
                        ),
                        child: deleteDataController.isLoading
                          ? const SizedBox(
                            height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.blueAccent,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text("Send"),    
                      ),
                    ),
        
                    if(deleteDataController.getStatusModel != null)
                    ...[
                      const SizedBox(height: Dimension.paddingDefault,),
                      Container(
                        padding: EdgeInsets.all(Dimension.paddingSmall),
                        decoration: BoxDecoration(
                          color: deleteDataController.getStatusModel?.responseState == ResponseState.success? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(Dimension.borderRadius),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              deleteDataController.getStatusModel?.responseState == ResponseState.success? "Successed" : "Error", 
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),

                            Text(
                              "Request Id : ${deleteDataController.getStatusModel?.id}", 
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            SizedBox(height: Dimension.paddingSmall),
                           
                            Text(
                              "${deleteDataController.getStatusModel?.message}",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ],      
                  
                  ],
                ),
              );
            }
          ),
        ),
      ],
    );
  }
}