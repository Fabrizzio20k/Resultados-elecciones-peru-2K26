import Foundation

enum ONPEServicio {
    private static let base = "https://resultadosegundavuelta.onpe.gob.pe/presentacion-backend"
    private static let idEleccion = 10

    static func participantes() async throws -> [Candidato] {
        let url = URL(string: "\(base)/resumen-general/participantes?idEleccion=\(idEleccion)&tipoFiltro=eleccion")!
        return try await ClienteHTTP.obtener(url)
    }

    static func totales() async throws -> Totales {
        let url = URL(string: "\(base)/resumen-general/totales?idEleccion=\(idEleccion)&tipoFiltro=eleccion")!
        return try await ClienteHTTP.obtener(url)
    }

    static func proceso() async throws -> ProcesoElectoral {
        let url = URL(string: "\(base)/proceso/proceso-electoral-activo")!
        return try await ClienteHTTP.obtener(url)
    }
}
