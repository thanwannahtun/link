enum BlocStatus {
  initial,

  limited,

  fetching,
  fetched,
  fetchFailed,

  adding,
  added,
  addFailed,

  deleting,
  deleted,
  deleteFailed,

  uploading,
  uploaded,
  uploadFailed,
}
