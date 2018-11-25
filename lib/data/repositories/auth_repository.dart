class AuthRepository {
  final String _authToken;

  final String _fileKey;

  AuthRepository(this._authToken, this._fileKey);

  String getToken() {
    return _authToken;
  }

  String getFileKey() {
    return _fileKey;
  }
}
