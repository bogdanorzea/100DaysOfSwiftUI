//
//  ContentView.swift
//  Instafilter
//
//  Created by Bogdan Orzea on 2022-10-16.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity: Double = 0.5
    @State private var filterRadius: Double = 0.5
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    @State private var showingFilterSheet = false
    @State private var processedImage: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle().fill(.gray)
                    
                    Text("Tap to select picture")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    image?.resizable().scaledToFit()
                }.onTapGesture {
                    showingImagePicker = true
                }
                
                HStack {
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity) { _ in applyProcessing() }
                }.padding()
                
                HStack {
                    Text("Radius")
                    Slider(value: $filterRadius)
                        .onChange(of: filterRadius) { _ in applyProcessing() }
                }.padding()
                
                HStack {
                    Button("Change filter") { showingFilterSheet = true }
                    
                    Spacer()
                    
                    Button("Save", action: save)
                        .disabled(processedImage == nil)
                }.padding()
            }
            .navigationTitle("InstaFilter")
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .onChange(of: inputImage) { _ in loadImage() }
            .confirmationDialog("Pick a Filter", isPresented: $showingFilterSheet) {
                Group {
                    Button("Bokeh Blur") { setFilter(filter: CIFilter.bokehBlur()) }
                    Button("Crystallize") { setFilter(filter: CIFilter.crystallize()) }
                    Button("Edges") { setFilter(filter: CIFilter.edges()) }
                    Button("Gaussian Blur") { setFilter(filter: CIFilter.gaussianBlur()) }
                    Button("Hatched Screen") { setFilter(filter: CIFilter.hatchedScreen()) }
                    Button("Motion Blur") { setFilter(filter: CIFilter.motionBlur()) }
                    Button("Pixellate") { setFilter(filter: CIFilter.pixellate()) }
                    Button("Sepia Tone") { setFilter(filter: CIFilter.sepiaTone()) }
                    Button("Unsharp Mask") { setFilter(filter: CIFilter.unsharpMask()) }
                    Button("Vignette") { setFilter(filter: CIFilter.vignette()) }
                }
                
                Button("Cancel", role: .cancel) { }
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    func save() {
        guard let processedImage = processedImage else { return }
        
        let imageSaver = ImageSaver()
        
        imageSaver.successHandler = {
            print("Success!")
        }
        
        imageSaver.errorHandler = { error in
            print("Error: \(error)")
        }
        
        imageSaver.writeToPhotoAlbum(image: processedImage)
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
        
    }
    
    func setFilter(filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
