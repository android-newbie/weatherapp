//weather_block.dart

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:weatherapp/data/repository/weather_repository.dart';
import 'package:weatherapp/models/weather_model.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherRepository weatherRepository;
  WeatherBloc(
    this.weatherRepository,
  ) : super(WeatherInitial()) {
    on<WeatherFetched>(_getCurrentWeather );
  }

   _getCurrentWeather(
      WeatherFetched event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    
    try {
      final weather = await weatherRepository.getCurrentWeather(event.cityName);
      print("fteched");
      emit(WeatherSuccess(weatherModel: weather,event.cityName));
    } catch (e) {
      emit(WeatherFailure(e.toString()));
    }
  }
}
