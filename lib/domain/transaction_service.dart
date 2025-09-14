import '../../data/transaction_model.dart';

class TransactionService {
  final List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  void addTransaction(TransactionModel tx) {
    _transactions.add(tx);
  }

  double get totalSpending =>
      _transactions.fold(0.0, (sum, tx) => sum + tx.amount);
}
