import Foundation

struct Totales: Decodable {
    let actasContabilizadas: Double
    let contabilizadas: Int
    let totalActas: Int
    let participacionCiudadana: Double
    let actasEnviadasJee: Double
    let enviadasJee: Int
    let actasPendientesJee: Double
    let pendientesJee: Int
    let fechaActualizacion: Double
    let totalVotosEmitidos: Int
    let totalVotosValidos: Int
    let porcentajeVotosEmitidos: Double
    let porcentajeVotosValidos: Double
}

extension Totales {
    var fechaActualizada: Date {
        Date(timeIntervalSince1970: fechaActualizacion / 1000)
    }
}
