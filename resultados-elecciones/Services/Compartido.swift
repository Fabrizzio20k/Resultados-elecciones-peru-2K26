import Foundation
import WidgetKit

struct CandidatoCompartido: Codable, Identifiable {
    let id: Int
    let apellido: String
    let porcentaje: Double
    let logo: Data?
}

struct InstantaneaResultados: Codable {
    let candidatos: [CandidatoCompartido]
    let actasContabilizadas: Double
    let actualizado: Date
    let cacheado: Date
}

extension InstantaneaResultados {
    static let demo = InstantaneaResultados(
        candidatos: [
            CandidatoCompartido(id: 10, apellido: "Sánchez", porcentaje: 49.95, logo: nil),
            CandidatoCompartido(id: 8, apellido: "Fujimori", porcentaje: 50.05, logo: nil)
        ],
        actasContabilizadas: 98.55,
        actualizado: Date(),
        cacheado: Date()
    )
}

func apellidoCorto(_ nombre: String) -> String {
    let partes = nombre.split(separator: " ")
    let elegido = partes.count > 2 ? partes[2] : (partes.last ?? Substring(nombre))
    return String(elegido).capitalized
}

enum AlmacenCompartido {
    static let grupo = "group.cazaputas.resultados-elecciones"
    private static let clave = "instantanea"
    private static var defaults: UserDefaults? { UserDefaults(suiteName: grupo) }

    static func guardar(_ instantanea: InstantaneaResultados) {
        guard let data = try? JSONEncoder().encode(instantanea) else { return }
        defaults?.set(data, forKey: clave)
    }

    static func leer() -> InstantaneaResultados? {
        guard let data = defaults?.data(forKey: clave) else { return nil }
        return try? JSONDecoder().decode(InstantaneaResultados.self, from: data)
    }
}

enum Compartido {
    static func instantanea(candidatos: [Candidato], totales: Totales) async -> InstantaneaResultados {
        let ordenados = candidatos.sorted { $0.porcentajeVotosValidos > $1.porcentajeVotosValidos }

        var compartidos: [CandidatoCompartido] = []
        for candidato in ordenados.prefix(2) {
            var logo: Data?
            if let url = candidato.urlLogo {
                logo = try? await ClienteHTTP.descargar(url)
            }
            compartidos.append(CandidatoCompartido(
                id: candidato.codigoAgrupacionPolitica,
                apellido: apellidoCorto(candidato.nombreCandidato),
                porcentaje: candidato.porcentajeVotosValidos,
                logo: logo
            ))
        }

        return InstantaneaResultados(
            candidatos: compartidos,
            actasContabilizadas: totales.actasContabilizadas,
            actualizado: totales.fechaActualizada,
            cacheado: Date()
        )
    }

    static func publicar(candidatos: [Candidato], totales: Totales) async {
        let instantanea = await instantanea(candidatos: candidatos, totales: totales)
        AlmacenCompartido.guardar(instantanea)
        WidgetCenter.shared.reloadAllTimelines()
    }

    static func construir() async throws -> InstantaneaResultados {
        async let participantes = ONPEServicio.participantes()
        async let totales = ONPEServicio.totales()
        let (lista, resumen) = try await (participantes, totales)
        return await instantanea(candidatos: lista, totales: resumen)
    }
}
