import SwiftUI

struct AvanceView: View {
    let vm: ResultadosViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    if let totales = vm.totales {
                        medidores(totales)
                        detalle(totales)
                        actualizacion(totales)
                    } else if vm.error == nil {
                        Esqueleto(radio: 20).frame(height: 170)
                        Esqueleto(radio: 20).frame(height: 240)
                    }

                    Color.clear.frame(height: 90)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .navigationTitle("Avance")
            .background(Color(.systemGroupedBackground))
            .refreshable { await vm.cargar() }
        }
    }

    private func medidores(_ totales: Totales) -> some View {
        HStack(spacing: 14) {
            medidor(
                valor: totales.actasContabilizadas,
                titulo: "Actas contabilizadas",
                color: .blue
            )
            medidor(
                valor: totales.participacionCiudadana,
                titulo: "Participación",
                color: .indigo
            )
        }
    }

    private func medidor(valor: Double, titulo: String, color: Color) -> some View {
        VStack(spacing: 12) {
            Gauge(value: valor, in: 0...100) {
                EmptyView()
            } currentValueLabel: {
                Text("\(valor, format: .number.precision(.fractionLength(1)))%")
                    .font(.system(.callout, design: .rounded, weight: .bold))
            }
            .gaugeStyle(.accessoryCircularCapacity)
            .tint(color)
            .scaleEffect(1.2)
            .frame(height: 70)

            Text(titulo)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func detalle(_ totales: Totales) -> some View {
        VStack(spacing: 0) {
            fila("Votos emitidos", totales.totalVotosEmitidos.formatted(), destacado: true)
            Divider().padding(.leading, 16)
            fila("Votos válidos", totales.totalVotosValidos.formatted())
            Divider().padding(.leading, 16)
            fila("Actas procesadas", "\(totales.contabilizadas.formatted()) / \(totales.totalActas.formatted())")
            Divider().padding(.leading, 16)
            fila("Enviadas a JEE", totales.enviadasJee.formatted())
            Divider().padding(.leading, 16)
            fila("Pendientes JEE", totales.pendientesJee.formatted())
        }
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func fila(_ titulo: String, _ valor: String, destacado: Bool = false) -> some View {
        HStack {
            Text(titulo)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(valor)
                .font(destacado ? .headline : .subheadline.weight(.semibold))
                .foregroundStyle(.primary)
        }
        .padding(16)
    }

    private func actualizacion(_ totales: Totales) -> some View {
        Label(
            "Actualizado: \(totales.fechaActualizada.formatted(date: .abbreviated, time: .shortened))",
            systemImage: "clock.arrow.circlepath"
        )
        .font(.caption)
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity)
    }
}
