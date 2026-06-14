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

            let ordenados = lista.sorted { $0.porcentajeVotosValidos > $1.porcentajeVotosValidos }
            self.candidatos = ordenados
            self.totales = resumen
            self.proceso = info

            Task { await Compartido.publicar(candidatos: ordenados, totales: resumen) }
        } catch {
            self.error = error.localizedDescription
        }
    }
}
