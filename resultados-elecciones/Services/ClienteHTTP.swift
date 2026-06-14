import Foundation

enum ClienteHTTP {
    static let cabeceras: [String: String] = [
        "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36",
        "accept": "*/*",
        "accept-language": "es-419,es;q=0.9,en;q=0.6",
        "referer": "https://resultadosegundavuelta.onpe.gob.pe/main/resumen",
        "sec-ch-ua": "\"Google Chrome\";v=\"149\", \"Chromium\";v=\"149\", \"Not)A;Brand\";v=\"24\"",
        "sec-ch-ua-mobile": "?0",
        "sec-ch-ua-platform": "\"macOS\"",
        "sec-fetch-dest": "empty",
        "sec-fetch-mode": "cors",
        "sec-fetch-site": "same-origin"
    ]

    static func peticion(_ url: URL, json: Bool = false) -> URLRequest {
        var request = URLRequest(url: url)
        for (clave, valor) in cabeceras {
            request.setValue(valor, forHTTPHeaderField: clave)
        }
        if json {
            request.setValue("application/json", forHTTPHeaderField: "content-type")
        }
        return request
    }

    static func obtener<T: Decodable>(_ url: URL) async throws -> T {
        let (data, _) = try await URLSession.shared.data(for: peticion(url, json: true))
        let respuesta = try JSONDecoder().decode(RespuestaAPI<T>.self, from: data)
        return respuesta.data
    }

    static func descargar(_ url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(for: peticion(url))
        return data
    }
}
