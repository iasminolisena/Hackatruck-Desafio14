//
//  ViewModel.swift
//  Desafio14
//
//  Created by Turma01-7 on 12/05/26.
//

import Foundation
import Vision
import Combine
import UIKit

class ViewModel: ObservableObject{
    @Published var detectedText = ""
    
    @MainActor func detectBarCode(photo: UIImage?) async {
        let request = RecognizeDocumentsRequest()
        guard let image = photo else { return }
        guard let cgImage = image.cgImage else { return }
        let result = try? await request.perform(on: cgImage)
        let texto = result?.first?.document.text.transcript
        detectedText = texto ?? ""
    }
}
