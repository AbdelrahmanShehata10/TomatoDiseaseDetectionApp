import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:objectdetection/main.dart';
import 'package:tflite/tflite.dart';


class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}
class _homeState extends State<home> {
  CameraImage ?imgcamera;
  CameraController ?cameraController;
  bool isworking=false;
  String res="";
  loadmodel()async{
    await Tflite.loadModel(model: "assets/model_unquant.tflite",labels: "assets/labels.txt");

  }
  // to open camera
  initCamera(){
    cameraController=CameraController(cameras![0],ResolutionPreset.medium);
    cameraController!.initialize().then((value) {
      if(!mounted){
        return;
      }
      else {
        setState(() {
          cameraController?.startImageStream((imagesFromStream) => {
            if(!isworking)
//معناها لو الكاميرا مش مشغوله في حاجه تانيه
              {
                isworking=true,
                imgcamera=imagesFromStream,
                runStreamDetection(),
              }
          });
        });
      }
    });
  }
  runStreamDetection()async{
    if(imgcamera !=null){
      var recognition= await Tflite.runModelOnFrame(bytesList: imgcamera!.planes.map((plane) {
        return plane.bytes;
      }).toList(),
        imageHeight: imgcamera!.height,
        imageWidth: imgcamera!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 3,
        threshold:0.1,
        asynch: true,
      );
      res="";
      recognition!.forEach((element) {

        res+=element["label"]+"  "+(element["confidence"] as double).toString()+"\n\n";
      });
      setState(() {
        res;
      });
      isworking=false;
    }
  }
  @override
  void initState() {
    loadmodel();
    super.initState();
  }
  @override
  void dispose() async{
    // TODO: implement dispose
    super.dispose();
    await Tflite.close();
    cameraController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
            child: Scaffold(
              backgroundColor: CupertinoColors.white,
              appBar:AppBar(
                title: Text('Disease Detection'),
                backgroundColor:Colors.teal ,
                actions: [
                  MaterialButton(onPressed: (){
                    imgcamera =null;
                    print(imgcamera);
                  },
                      child: Text('Done',style: TextStyle(color: Colors.white),))
                ],

              ) ,
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(

                    children: [
                      Image.asset('assets/working-scientists-laboratory-research-analysis_102902-6827.jpg',height:200,width:double.infinity,),
                      SizedBox(height:20 ),
                      Column(
                        children: [
                          Text("Test the health of your crop now!"
                              ,style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,

                              )),
                          SizedBox(height:20 ),
                          MaterialButton(onPressed: (){
                            initCamera();
                          },
                            child:Container(
                              height: 400,
                              width: double.infinity,
                              child: imgcamera ==null ? Container(
                                height: 400,
                                width: double.infinity,
                                child: Icon(Icons.image_search_sharp,color: Colors.teal,size: 40,),
                              ) : AspectRatio(aspectRatio: cameraController!.value.aspectRatio,
                                child: CameraPreview(cameraController!),

                              ),
                            ),
                          ),
                          SizedBox(height:7 ),
                          Text("$res",style: TextStyle(color: Colors.teal),),
                        ],
                      )
                    ],
                  ),
                ),

              ),
            ),

    ));}}