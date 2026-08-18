import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/quote_item.dart';
import '../../../products/domain/entities/product.dart';

abstract class QuoteRequestEvent extends Equatable {
  const QuoteRequestEvent();
  @override
  List<Object?> get props => [];
}

class AddProductToRequest extends QuoteRequestEvent {
  final Product product;
  final double quantity;
  const AddProductToRequest(this.product, {this.quantity = 1.0});

  @override
  List<Object?> get props => [product, quantity];
}

class RemoveProductFromRequest extends QuoteRequestEvent {
  final String productId;
  const RemoveProductFromRequest(this.productId);

  @override
  List<Object?> get props => [productId];
}

class UpdateRequestQuantity extends QuoteRequestEvent {
  final String productId;
  final double quantity;
  const UpdateRequestQuantity(this.productId, this.quantity);

  @override
  List<Object?> get props => [productId, quantity];
}

class ClearRequest extends QuoteRequestEvent {}

class QuoteRequestState extends Equatable {
  final List<QuoteItem> items;
  
  const QuoteRequestState({this.items = const []});

  @override
  List<Object?> get props => [items];
}

class QuoteRequestBloc extends Bloc<QuoteRequestEvent, QuoteRequestState> {
  QuoteRequestBloc() : super(const QuoteRequestState()) {
    on<AddProductToRequest>((event, emit) {
      final existingIndex = state.items.indexWhere((i) => i.productId == event.product.id);
      if (existingIndex >= 0) {
        final updatedItems = List<QuoteItem>.from(state.items);
        updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
          quantity: updatedItems[existingIndex].quantity + event.quantity,
        );
        emit(QuoteRequestState(items: updatedItems));
      } else {
        final newItem = QuoteItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          quoteId: '',
          productId: event.product.id,
          productName: event.product.name,
          sku: event.product.sku,
          categoryId: event.product.categoryId,
          categoryName: event.product.categoryName,
          quantity: event.quantity,
          unit: event.product.unit,
          quotedPrice: 0.0,
        );
        emit(QuoteRequestState(items: [...state.items, newItem]));
      }
    });

    on<RemoveProductFromRequest>((event, emit) {
      emit(QuoteRequestState(
        items: state.items.where((i) => i.productId != event.productId).toList(),
      ));
    });

    on<UpdateRequestQuantity>((event, emit) {
      final updatedItems = state.items.map((item) {
        if (item.productId == event.productId) {
          return item.copyWith(quantity: event.quantity);
        }
        return item;
      }).toList();
      emit(QuoteRequestState(items: updatedItems));
    });

    on<ClearRequest>((event, emit) => emit(const QuoteRequestState()));
  }
}
