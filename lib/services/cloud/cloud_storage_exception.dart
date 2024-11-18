class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotAddImageException implements CloudStorageException {}

class CouldNotGetAllImagesException implements CloudStorageException {}

class CouldNotDeleteImageException implements CloudStorageException {}
