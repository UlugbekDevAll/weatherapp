import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';
import '../data/my_data.dart';

part 'weather_event.dart';

part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<WeatherEvent>((event, emit) async {
      emit(WeatherBlocLoading());
      try {
        WeatherFactory weatherFactory =
            WeatherFactory(API_KEY, language: Language.ENGLISH);
        Position position = await Geolocator.getCurrentPosition();

        Weather weather = await weatherFactory.currentWeatherByLocation(
            position.latitude, position.longitude);

        emit(WeatherBlocSuccess(weather));
      } catch (e) {
        emit(WeatherBlocFailure());
      }
    });
  }
}
