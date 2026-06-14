import SwiftUI

struct ResultadosView: View {
    let vm: ResultadosViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 18) {
                    if vm.candidatos.isEmpty && vm.error == nil {
                        TarjetaEsqueleto()
                        TarjetaEsqueleto()
                    }

                    if let error = vm.error, vm.candidatos.isEmpty {
                        ContentUnavailableView {
                            Label("No se pudo cargar", systemImage: "wifi.slash")
                        } description: {
                            Text(error)
                        } actions: {
                            Button("Reintentar") {
                                Task { await vm.cargar() }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding(.top, 40)
                    }

                    ForEach(Array(vm.candidatos.enumerated()), id: \.element.id) { indice, candidato in
                        TarjetaCandidato(candidato: candidato, lider: indice == 0)
                    }

                    Color.clear.frame(height: 90)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .navigationTitle("Resultados")
            .background(Color(.systemGroupedBackground))
            .refreshable { await vm.cargar() }
        }
    }
}
