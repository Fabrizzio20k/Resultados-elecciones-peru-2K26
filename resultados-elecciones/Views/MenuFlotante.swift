import SwiftUI

enum Seccion: String, CaseIterable, Identifiable {
    case resultados
    case avance
    case proceso

    var id: Self { self }

    var titulo: String {
        switch self {
        case .resultados: return "Resultados"
        case .avance: return "Avance"
        case .proceso: return "Proceso"
        }
    }

    var icono: String {
        switch self {
        case .resultados: return "chart.bar.fill"
        case .avance: return "chart.pie.fill"
        case .proceso: return "info.circle.fill"
        }
    }
}

struct MenuFlotante: View {
    @Binding var seleccion: Seccion
    @Namespace private var animacion

    var body: some View {
        HStack(spacing: 4) {
            ForEach(Seccion.allCases) { seccion in
                Button {
                    withAnimation(.snappy(duration: 0.3)) {
                        seleccion = seccion
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: seccion.icono)
                            .font(.system(size: 17, weight: .semibold))
                        Text(seccion.titulo)
                            .font(.system(size: 11, weight: .medium))
                    }
                    .frame(width: 74, height: 50)
                    .foregroundStyle(seleccion == seccion ? .white : .secondary)
                    .background {
                        if seleccion == seccion {
                            Capsule()
                                .fill(Color.accentColor)
                                .matchedGeometryEffect(id: "seleccion", in: animacion)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(6)
        .glassEffect(.regular, in: .capsule)
    }
}
