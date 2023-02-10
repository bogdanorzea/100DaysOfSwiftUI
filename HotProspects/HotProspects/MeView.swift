//
//  MeView.swift
//  HotProspects
//
//  Created by Bogdan Orzea on 2023-02-06.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct MeView: View {
    @State private var name = "Anonymous"
    @State private var email = "you@yoursite.com"
    @State private var qrCode = UIImage()
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationView {
            Form {
                Section("My info") {
                    TextField("Name", text: $name)
                        .textContentType(.name)
                    
                    TextField("E-mail", text: $email)
                        .textContentType(.emailAddress)
                }
                
                Section("QR Code") {
                    Image(uiImage: qrCode)
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .contextMenu {
                            Button {
                                ImageSaver().writeToPhotoAlbum(image: qrCode)
                            } label: {
                                Label("Save to Photos", systemImage: "square.and.arrow.down")
                            }
                        }
                }
            }
        }
        .navigationTitle("Me")
        .onAppear(perform: updateCode)
        .onChange(of: name, perform: { _ in updateCode() })
        .onChange(of: email, perform: { _ in updateCode() })
    }
    
    func updateCode() {
        qrCode = generateQRCode(from: "\(name)\n\(email)")
    }
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return UIImage.init(systemName: "xmark.cicle") ?? UIImage()
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
