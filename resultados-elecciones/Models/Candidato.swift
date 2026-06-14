import Foundation

struct Candidato: Identifiable, Decodable {
    var id: Int { codigoAgrupacionPolitica }
    let nombreAgrupacionPolitica: String
    let codigoAgrupacionPolitica: Int
    let nombreCandidato: String
    let dniCandidato: String
    let totalVotosValidos: Int
    let porcentajeVotosValidos: Double
    let porcentajeVotosEmitidos: Double
}

extension Candidato {
    var urlRostro: URL? {
        URL(string: "https://resultadosegundavuelta.onpe.gob.pe/assets/img-reales/candidatos/\(dniCandidato).png")
    }

    var urlLogo: URL? {
        let codigo = String(format: "%08d", codigoAgrupacionPolitica)
        return URL(string: "https://resultadosegundavuelta.onpe.gob.pe/assets/img-reales/partidos/\(codigo).png")
    }
}
