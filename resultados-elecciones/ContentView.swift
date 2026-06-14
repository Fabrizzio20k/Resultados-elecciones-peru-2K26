import SwiftUI

struct ContentView: View {
    @State private var vm = ResultadosViewModel()

    var body: some View {
        TabView {
            Tab("Resultados", systemImage: "chart.bar.fill") {
                ResultadosView(vm: vm)
            }
            Tab("Avance", systemImage: "chart.pie.fill") {
                AvanceView(vm: vm)
            }
            Tab("Proceso", systemImage: "info.circle.fill") {
                ProcesoView(vm: vm)
            }
        }
        .task {
            await vm.cargar()
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(300))
                await vm.cargar()
            }
        }
    }
}

#Preview {
    ContentView()
}
