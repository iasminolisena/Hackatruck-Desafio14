//
//  ContentView.swift
//  Desafio14
//
//  Created by Turma01-7 on 12/05/26.
//

import SwiftUI
import PhotosUI
import AVFoundation

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    @State private var photoPicked: PhotosPickerItem?
    @State private var imageToAnalise: UIImage?
    
    let sintetizador = AVSpeechSynthesizer()
    
    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea()
            
            VStack{
                Text("StudyCast")
                    .foregroundStyle(Color.white)
                    .bold()
                
                
                
                if let image = imageToAnalise {
                    
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .cornerRadius(20)
                        .padding(.horizontal)
                    
                    HStack(spacing: 15) {
                        
                        Button(action: {
                            Task {
                                await viewModel.detectBarCode(photo: imageToAnalise)
                            }
                        }) {
                            Text("Analisar Texto")
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.indigo)
                                .foregroundStyle(.white)
                                .cornerRadius(20)
                        }
                        Button(action: {
                            let enunciado = AVSpeechUtterance(string: viewModel.detectedText)
                            
                            enunciado.voice = AVSpeechSynthesisVoice(language: "pt-BR")
                            enunciado.rate = 0.5
                            
                            sintetizador.speak(enunciado)
                        }) {
                            Text("Escutar Texto")
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.indigo)
                                .foregroundStyle(.white)
                                .cornerRadius(20)
                        }
                        
                    }
                    
                }
                Spacer()
                ScrollView {
                    Text(viewModel.detectedText)
                        .foregroundStyle(.white)
                        .padding()
                    
                    
                }
                
                if imageToAnalise == nil {
                    
                    Text("Nenhuma foto para analisar")
                        .foregroundStyle(.white)
                        .font(.title3)
                }
                
                PhotosPicker(selection: $photoPicked,
                             matching: .images,
                             photoLibrary: .shared()) {
                    
                    Text("Pegar da Galeria")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.indigo)
                        .foregroundStyle(.white)
                        .cornerRadius(25)
                        .padding(.horizontal)
                }
                             .onChange(of: photoPicked) { oldValue, newValue in
                                 if let newPhoto = newValue {
                                     Task {
                                         if let data = try? await newPhoto.loadTransferable(type: Data.self),
                                            let image = UIImage(data: data) {
                                             
                                             imageToAnalise = image
                                         }
                                     }
                                 }
                             }
                Spacer()
            }
            .padding(.horizontal)
            
            
        }
        
        
    }
    
}
#Preview {
    ContentView()
}
