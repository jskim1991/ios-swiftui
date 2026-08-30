//
//  ContentView.swift
//  photo-gallery-app
//
//  Created by jay on 8/29/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        PhotoGalleryApp()
    }
}

#Preview {
    ContentView()
}

struct PhotoGalleryApp: View {
    @State private var selectedImage: String? = nil
    let images = ["photo1", "photo2", "photo3"]
    
    var body: some View {
        NavigationStack {
            VStack {
                if let selectedImage {
                    EnlargedPhotoView(imageName: selectedImage) {
                        self.selectedImage = nil
                    }
                } else {
                    ScrollView {
                        VStack {
                            ForEach(images, id: \.self) { image in
                                Image(image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 300)
                                    .clipShape(.rect(cornerRadius: 10))
                                    .shadow(radius: 5)
                                    .onTapGesture {
                                        self.selectedImage = image
                                    }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle("Photo Gallery")
        }
        
    }
}

struct EnlargedPhotoView: View {
    let imageName: String
    let onClose: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .background(Color.white)
                    .clipShape(.rect(cornerRadius: 20))
                    .shadow(radius: 10)
                
                Button(action: onClose) {
                    Text("Close")
                        .foregroundStyle(Color.white)
                        .padding()
                        .background(Color.red)
                        .clipShape(.rect(cornerRadius: 10))
                }
                .padding(.top, 20)
            }
        }
    }
}
