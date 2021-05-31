import Foundation

enum DataLoadingPresentation<DataType> {
    case loading
    case loaded(DataType)
    case loadingFailed(Error)
}
