import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan_data/mobichan_data.dart';

class BoardRepositoryImpl extends BoardRepository {
  final BoardLocalDatasource localDatasource;
  final BoardRemoteDatasource remoteDatasource;

  BoardRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
  });

  @override
  Future<void> addBoardToFavorites(Board board) async {
    return localDatasource.addBoardToFavorites(BoardModel.fromEntity(board));
  }

  @override
  Future<List<Board>> getBoards() async {
    return remoteDatasource.getBoards();
  }

  @override
  Future<List<Board>> getFavoriteBoards() async {
    return localDatasource.getFavoriteBoards();
  }

  @override
  Future<bool> isBoardInFavorites(Board board) async {
    return localDatasource.isBoardInFavorites(BoardModel.fromEntity(board));
  }

  @override
  Future<void> removeBoardFromFavorites(Board board) async {
    return localDatasource
        .removeBoardFromFavorites(BoardModel.fromEntity(board));
  }

  @override
  Future<Board> getLastVisitedBoard() async {
    return localDatasource.getLastVisitedBoard();
  }

  @override
  Future<void> saveLastVisitedBoard(Board board) async {
    return localDatasource.saveLastVisitedBoard(BoardModel.fromEntity(board));
  }
}