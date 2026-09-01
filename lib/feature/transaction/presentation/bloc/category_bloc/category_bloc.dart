import 'package:bloc/bloc.dart';
import 'package:expense_tracker/feature/transaction/domain/usecases/transaction_categories_usecase.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/category_bloc/category_event.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/category_bloc/category_states.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryStates> {
  final TransactionCategoriesUsecase transactionCategoriesUsecase;
  CategoryBloc({required this.transactionCategoriesUsecase})
    : super(const CategoryInitial()) {
    on<GetCategoryTransaction>(_getCategoryTransaction);
  }

  Future<void> _getCategoryTransaction(
    GetCategoryTransaction event,
    Emitter<CategoryStates> emit,
  ) async {
    final result = await transactionCategoriesUsecase();

    result.fold(
      (failure) {
        emit(CategoryFailure(failure.message));
      },
      (category) {
        emit(CategoryLoaded(category));
      },
    );
  }
}
