import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:opennutritracker/features/add_meal/domain/entity/product_entity.dart';
import 'package:opennutritracker/features/add_meal/domain/usecase/search_products_usecase.dart';

part 'food_event.dart';

part 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final log = Logger('FoodBloc');

  final SearchProductsUseCase searchProductUseCase = SearchProductsUseCase();

  String _searchString = "";

  FoodBloc() : super(FoodInitial()) {
    on<LoadFoodEvent>((event, emit) async {
      if (event.searchString != _searchString) {
        _searchString = event.searchString;
        emit(FoodLoadingState());
        try {
          final result =
              await searchProductUseCase.searchFDCFoodByString(_searchString);
          emit(FoodLoadedState(food: result));
        } catch (error) {
          log.severe(error);
          emit(FoodFailedState());
        }
      }
    });
  }
}