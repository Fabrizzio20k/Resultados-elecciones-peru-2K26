import SwiftUI
import UIKit

struct Esqueleto: View {
    var radio: CGFloat = 12
    @State private var desplazamiento: CGFloat = -1

    var body: some View {
        RoundedRectangle(cornerRadius: radio, style: .continuous)
            .fill(Color(.systemGray5))
            .overlay {
                GeometryReader { geo in
                    LinearGradient(
                        colors: [.clear, Color(.systemBackground).opacity(0.55), .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geo.size.width * 0.7)
                    .offset(x: desplazamiento * geo.size.width * 1.7)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: radio, style: .continuous))
            .onAppear {
                withAnimation(.linear(duration: 1.1).repeatForever(autoreverses: false)) {
                    desplazamiento = 1
                }
            }
    }
}

@MainActor
@Observable
final class CargadorImagen {
    var imagen: UIImage?
    private var cargando = false

    func cargar(_ url: URL?) async {
        guard imagen == nil, !cargando, let url else { return }
        cargando = true
        defer { cargando = false }

        guard let data = try? await ClienteHTTP.descargar(url),
              let img = UIImage(data: data) else { return }
        imagen = img
    }
}

struct ImagenRemota<Placeholder: View>: View {
    private let url: URL?
    private let contentMode: ContentMode
    private let placeholder: () -> Placeholder
    @State private var cargador = CargadorImagen()

    init(
        url: URL?,
        contentMode: ContentMode = .fill,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.contentMode = contentMode
        self.placeholder = placeholder
    }

    var body: some View {
        Group {
            if let imagen = cargador.imagen {
                Image(uiImage: imagen)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else {
                placeholder()
            }
        }
        .task { await cargador.cargar(url) }
    }
}
