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

                    acercaDe

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

    private var version: String {
        let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let b = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(v) (\(b))"
    }

    private var acercaDe: some View {
        VStack(spacing: 0) {
            VStack(spacing: 6) {
                Text("Acerca de")
                    .font(.headline)
                Text("Resultados en vivo de las Elecciones Generales del Perú 2026, con datos oficiales de la ONPE.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(20)

            Divider().padding(.leading, 16)
            fila("Desarrollador", "Fabrizzio Vilchez")
            Divider().padding(.leading, 16)
            fila("Versión", version)
            Divider().padding(.leading, 16)

            Link(destination: URL(string: "https://github.com/Fabrizzio20k")!) {
                HStack {
                    Label("GitHub", systemImage: "chevron.left.forwardslash.chevron.right")
                        .font(.subheadline.weight(.semibold))
                    Spacer()
                    Text("@Fabrizzio20k")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Image(systemName: "arrow.up.right")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.tertiary)
                }
                .padding(16)
            }
            .tint(.primary)

            Divider().padding(.leading, 16)

            Text("Datos: ONPE · Proyecto sin fines de lucro")
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
