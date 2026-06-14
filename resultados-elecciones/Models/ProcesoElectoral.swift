import Foundation

struct ProcesoElectoral: Decodable {
    let id: Int
    let nombre: String
    let acronimo: String
    let fechaProceso: Double
    let idEleccionPrincipal: Int
    let tipoProcesoElectoral: String
    let activoFechaProceso: Bool
}

extension ProcesoElectoral {
    var fecha: Date {
        Date(timeIntervalSince1970: fechaProceso / 1000)
    }

    var tipoLegible: String {
        tipoProcesoElectoral.capitalized
    }
}
