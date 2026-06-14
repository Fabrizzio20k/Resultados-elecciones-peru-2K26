import SwiftUI

struct ContentView: View {
    @State private var vm = ResultadosViewModel()
    @State private var seccion: Seccion = .resultados

    var body: some View {
        ZStack(alignment: .bottom) {
            seccionActual
            MenuFlotante(seleccion: $seccion)
                .padding(.bottom, 6)
        }
        .task {
            if vm.candidatos.isEmpty {
                await vm.cargar()
            }
        }
    }

    @ViewBuilder
    private var seccionActual: some View {
        switch seccion {
        case .resultados:
            ResultadosView(vm: vm)
        case .avance:
            AvanceView(vm: vm)
        case .proceso:
            ProcesoView(vm: vm)
        }
    }
}

#Preview {
    ContentView()
}
