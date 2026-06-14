import SwiftUI

struct ProcesoView: View {
    let vm: ResultadosViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    if let proceso = vm.proceso {
                        encabezado(proceso)
                        detalle(proceso)
                    } else if vm.error == nil {
                        Esqueleto(radio: 20).frame(height: 160)
                        Esqueleto(radio: 20).frame(height: 220)
                    }

                    Color.clear.frame(height: 90)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .navigationTitle("Proceso")
            .background(Color(.systemGroupedBackground))
            .refreshable { await vm.cargar() }
        }
    }

    private func encabezado(_ proceso: ProcesoElectoral) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "building.columns.fill")
                .font(.system(size: 34))
                .foregroundStyle(.tint)

            Text(proceso.nombre)
                .font(.title2.weight(.bold))
                .multilineTextAlignment(.center)

            Text(proceso.acronimo)
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(.tertiarySystemBackground), in: Capsule())
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func detalle(_ proceso: ProcesoElectoral) -> some View {
        VStack(spacing: 0) {
            fila("Fecha", proceso.fecha.formatted(date: .long, time: .omitted))
            Divider().padding(.leading, 16)
            fila("Tipo de proceso", proceso.tipoLegible)
            Divider().padding(.leading, 16)
            fila("Elección", "N.° \(proceso.idEleccionPrincipal)")
            Divider().padding(.leading, 16)
            fila("Estado", proceso.activoFechaProceso ? "Activo" : "Inactivo")
        }
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func fila(_ titulo: String, _ valor: String) -> some View {
        HStack {
            Text(titulo)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(valor)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.trailing)
        }
        .padding(16)
    }
}
