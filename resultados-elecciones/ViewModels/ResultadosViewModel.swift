import Foundation
import Observation

@MainActor
@Observable
final class ResultadosViewModel {
    var candidatos: [Candidato] = []
    var totales: Totales?
    var proceso: ProcesoElectoral?
    var cargando = false
    var error: String?

    func cargar() async {
        cargando = true
        error = nil
        defer { cargando = false }

        do {
            async let participantes = ONPEServicio.participantes()
            async let totales = ONPEServicio.totales()
            async let proceso = ONPEServicio.proceso()

            let (lista, resumen, info) = try await (participantes, totales, proceso)

            self.candidatos = lista.sorted { $0.porcentajeVotosValidos > $1.porcentajeVotosValidos }
            self.totales = resumen
            self.proceso = info
        } catch {
            self.error = error.localizedDescription
        }
    }
}
