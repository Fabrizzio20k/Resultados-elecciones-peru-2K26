import Foundation

struct RespuestaAPI<T: Decodable>: Decodable {
    let success: Bool
    let message: String
    let data: T
}
