import 'package:hotspotassignment/hotspot/model/hot_model.dart';

class  ApiState<T> {
  final bool isLoading;
  final List <Experience>? experience;
  final String? error;

  ApiState({this.isLoading = false, this.experience =const [], this.error});

  ApiState copyWith({
    bool? isLoading,
    List<Experience>? experience,
    String? error
}){
    return ApiState(
      isLoading: isLoading ?? this.isLoading,
      experience: experience ?? this.experience,
      error:  error ?? this.error
    );
  }
}