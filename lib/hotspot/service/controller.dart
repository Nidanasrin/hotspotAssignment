import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hotspotassignment/hotspot/model/hot_model.dart';
import 'package:hotspotassignment/hotspot/service/state.dart';

final apiProvider = StateNotifierProvider<ApiController,ApiState>((ref){
  return ApiController();
});
class ApiController extends StateNotifier<ApiState>{
  ApiController() : super(ApiState());

  final Dio dio = Dio();
    var url = 'https://staging.chamberofsecrets.8club.co/v1/experiences?active=true';
  Future<void>fetchData()async{
    state = state.copyWith(isLoading: true,error: null);

    try{
       final response = await dio.get(url);
       if(response.statusCode == 200){
         final hotspot = Hotspot.fromJson(response.data);
         final experience = hotspot.data?.experiences ?? [];
         state = state.copyWith(
           isLoading: false,
           experience: experience,
           error: null
         );
       }else {
         throw Exception('Failed to load carts');
       }
    }catch(e){
      state = state.copyWith(
        isLoading: false,
        error: e.toString()
      );
      throw Exception( "Error : $e");
    }
  }
}

