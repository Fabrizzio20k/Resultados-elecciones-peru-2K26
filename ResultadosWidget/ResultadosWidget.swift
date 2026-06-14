import WidgetKit
import SwiftUI
import UIKit

func colorPartido(_ codigo: Int) -> Color {
    switch codigo {
    case 8: return .orange
    case 10: return .green
    default: return .blue
    }
}

struct EntradaResultados: TimelineEntry {
    let date: Date
    let instantanea: InstantaneaResultados?
}

struct Proveedor: TimelineProvider {
    func placeholder(in context: Context) -> EntradaResultados {
        EntradaResultados(date: .now, instantanea: .demo)
    }

    func getSnapshot(in context: Context, completion: @escaping (EntradaResultados) -> Void) {
        completion(EntradaResultados(date: .now, instantanea: AlmacenCompartido.leer() ?? .demo))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<EntradaResultados>) -> Void) {
        Task {
            let ahora = Date()
            var instantanea = AlmacenCompartido.leer()

            let vencida = instantanea == nil || ahora.timeIntervalSince(instantanea!.cacheado) > 300
            if vencida, let fresca = try? await Compartido.construir() {
                AlmacenCompartido.guardar(fresca)
                instantanea = fresca
            }

            let entrada = EntradaResultados(date: ahora, instantanea: instantanea)
            let proxima = ahora.addingTimeInterval(300)
            completion(Timeline(entries: [entrada], policy: .after(proxima)))
        }
    }
}

struct VistaWidget: View {
    @Environment(\.widgetFamily) private var familia
    let instantanea: InstantaneaResultados?

    var body: some View {
        if let datos = instantanea, datos.candidatos.count >= 2 {
            if familia == .systemSmall {
                compacto(datos)
            } else {
                completo(datos)
            }
        } else {
            VStack(spacing: 6) {
                Image(systemName: "chart.bar.xaxis")
                    .font(.title2)
                Text("Abre la app")
                    .font(.caption)
            }
            .foregroundStyle(.secondary)
        }
    }

    private func completo(_ datos: InstantaneaResultados) -> some View {
        let a = datos.candidatos[0]
        let b = datos.candidatos[1]
        return VStack(spacing: 10) {
            HStack {
                Text("Segunda Vuelta")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.secondary)
                Spacer()
                pildoraContado(datos.actasContabilizadas)
            }

            HStack(alignment: .center) {
                lado(a, alineacion: .leading)
                Spacer(minLength: 8)
                lado(b, alineacion: .trailing)
            }

            barra(a, b)

            HStack(spacing: 4) {
                Image(systemName: "clock")
                Text("Actualizado \(datos.actualizado.formatted(date: .omitted, time: .shortened))")
                Spacer()
            }
            .font(.system(size: 10))
            .foregroundStyle(.secondary)
        }
    }

    private func compacto(_ datos: InstantaneaResultados) -> some View {
        let a = datos.candidatos[0]
        let b = datos.candidatos[1]
        return VStack(spacing: 8) {
            HStack {
                chip(a)
                Spacer()
                chip(b)
            }
            barra(a, b)
            HStack {
                Text(a.porcentaje, format: .number.precision(.fractionLength(3)))
                    .foregroundStyle(colorPartido(a.id))
                Spacer()
                Text(b.porcentaje, format: .number.precision(.fractionLength(3)))
                    .foregroundStyle(colorPartido(b.id))
            }
            .font(.caption.weight(.bold))
            pildoraContado(datos.actasContabilizadas)
        }
    }

    private func lado(_ c: CandidatoCompartido, alineacion: HorizontalAlignment) -> some View {
        HStack(spacing: 8) {
            if alineacion == .trailing {
                info(c, alineacion: alineacion)
                chip(c)
            } else {
                chip(c)
                info(c, alineacion: alineacion)
            }
        }
    }

    private func info(_ c: CandidatoCompartido, alineacion: HorizontalAlignment) -> some View {
        VStack(alignment: alineacion, spacing: 0) {
            Text(c.apellido)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.primary)
                .lineLimit(1)
            HStack(alignment: .firstTextBaseline, spacing: 1) {
                Text(c.porcentaje, format: .number.precision(.fractionLength(3)))
                    .font(.title3.weight(.heavy))
                Text("%")
                    .font(.caption2.weight(.bold))
            }
            .foregroundStyle(colorPartido(c.id))
        }
    }

    private func chip(_ c: CandidatoCompartido) -> some View {
        ZStack {
            Circle().fill(.white)
            if let data = c.logo, let img = UIImage(data: data) {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .padding(5)
            } else {
                Circle().fill(colorPartido(c.id).opacity(0.5))
            }
        }
        .frame(width: 30, height: 30)
        .overlay(Circle().strokeBorder(.white.opacity(0.7), lineWidth: 0.5))
        .shadow(color: .black.opacity(0.15), radius: 2, y: 1)
    }

    private func pildoraContado(_ porcentaje: Double) -> some View {
        HStack(spacing: 4) {
            Image(systemName: "checkmark.seal.fill")
            Text("\(porcentaje, specifier: "%.1f")% contado")
        }
        .font(.system(size: 10, weight: .semibold))
        .foregroundStyle(.secondary)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(.ultraThinMaterial, in: Capsule())
    }

    private func barra(_ a: CandidatoCompartido, _ b: CandidatoCompartido) -> some View {
        GeometryReader { geo in
            let total = max(a.porcentaje + b.porcentaje, 0.0001)
            let anchoA = geo.size.width * a.porcentaje / total
            HStack(spacing: 0) {
                colorPartido(a.id).frame(width: anchoA)
                colorPartido(b.id)
            }
            .overlay(
                LinearGradient(
                    colors: [.white.opacity(0.3), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .clipShape(Capsule())
        }
        .frame(height: 16)
    }
}

struct ResultadosWidget: Widget {
    let kind = "ResultadosWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Proveedor()) { entry in
            VistaWidget(instantanea: entry.instantanea)
                .containerBackground(for: .widget) {
                    LinearGradient(
                        colors: [
                            colorPartido(10).opacity(0.14),
                            Color(.systemBackground),
                            colorPartido(8).opacity(0.14)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
        }
        .configurationDisplayName("Resultados ONPE")
        .description("Conteo en vivo de la segunda vuelta.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemMedium) {
    ResultadosWidget()
} timeline: {
    EntradaResultados(date: .now, instantanea: .demo)
}
