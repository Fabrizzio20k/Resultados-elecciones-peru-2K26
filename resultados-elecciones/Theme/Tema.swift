import SwiftUI

extension Candidato {
    var color: Color {
        switch codigoAgrupacionPolitica {
        case 8: return .orange
        case 10: return .green
        default: return .blue
        }
    }
}
