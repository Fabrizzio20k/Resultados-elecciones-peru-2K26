import SwiftUI

struct TarjetaCandidato: View {
    let candidato: Candidato
    let lider: Bool

    private var color: Color { candidato.color }

    var body: some View {
        VStack(spacing: 0) {
            banner
            estadisticas
        }
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .strokeBorder(Color(.separator).opacity(0.5), lineWidth: 0.5)
        }
        .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
    }

    private var banner: some View {
        ImagenRemota(url: candidato.urlRostro, contentMode: .fill) {
            Esqueleto(radio: 0)
        }
        .frame(height: 240)
        .frame(maxWidth: .infinity)
        .clipped()
        .overlay {
            LinearGradient(
                colors: [.clear, .black.opacity(0.2), .black.opacity(0.8)],
                startPoint: .center,
                endPoint: .bottom
            )
        }
        .overlay(alignment: .bottomLeading) {
            VStack(alignment: .leading, spacing: 4) {
                Text(candidato.nombreAgrupacionPolitica)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.85))
                    .lineLimit(1)
                Text(candidato.nombreCandidato)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
            }
            .padding(16)
        }
        .overlay(alignment: .topTrailing) {
            chipLogo.padding(12)
        }
        .overlay(alignment: .topLeading) {
            if lider {
                Label("Va ganando", systemImage: "crown.fill")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.black)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.yellow, in: Capsule())
                    .padding(12)
            }
        }
    }

    private var chipLogo: some View {
        ImagenRemota(url: candidato.urlLogo, contentMode: .fit) {
            Esqueleto(radio: 10)
        }
        .padding(7)
        .frame(width: 46, height: 46)
        .background(.white, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
    }

    private var estadisticas: some View {
        VStack(spacing: 14) {
            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text(candidato.porcentajeVotosValidos, format: .number.precision(.fractionLength(2)))
                    .font(.system(size: 38, weight: .heavy, design: .rounded))
                    .foregroundStyle(color)
                Text("%")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(color.opacity(0.7))
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(candidato.totalVotosValidos, format: .number)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text("votos válidos")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            barra
        }
        .padding(16)
        .background(color.opacity(0.10))
    }

    private var barra: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(color.opacity(0.2))
                Capsule()
                    .fill(color)
                    .frame(width: geo.size.width * candidato.porcentajeVotosValidos / 100)
            }
        }
        .frame(height: 10)
    }
}

struct TarjetaEsqueleto: View {
    var body: some View {
        VStack(spacing: 0) {
            Esqueleto(radio: 0)
                .frame(height: 240)
            VStack(spacing: 14) {
                HStack {
                    Esqueleto().frame(width: 120, height: 36)
                    Spacer()
                    Esqueleto().frame(width: 80, height: 30)
                }
                Esqueleto(radio: 6).frame(height: 10)
            }
            .padding(16)
        }
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
    }
}
